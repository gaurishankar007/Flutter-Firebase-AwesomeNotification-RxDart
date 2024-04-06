import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../models/contact.dart';

typedef _SnapShots = QuerySnapshot<Map<String, dynamic>>;
typedef _Document = DocumentReference<Map<String, dynamic>>;

extension Unwrap<T> on Stream<T?> {
  Stream<T> unwrap() => switchMap((optional) async* {
        if (optional != null) yield optional;
      });
}

@immutable
class ContactBloc {
  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;
  final Sink<void> deleteAllContacts;
  final Stream<Iterable<Contact>> contacts;
  final StreamSubscription<void> _createContactSubscription;
  final StreamSubscription<void> _deleteContactSubscription;
  final StreamSubscription<void> _deleteAllContactsSubscription;

  const ContactBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.deleteAllContacts,
    required this.contacts,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
    required StreamSubscription<void> deleteAllContactsSubscription,
  })  : _createContactSubscription = createContactSubscription,
        _deleteContactSubscription = deleteContactSubscription,
        _deleteAllContactsSubscription = deleteAllContactsSubscription;

  void dispose() {
    userId.close();
    createContact.close();
    deleteContact.close();
    _createContactSubscription.cancel();
    _deleteContactSubscription.cancel();
    _deleteAllContactsSubscription.cancel();
  }

  factory ContactBloc() {
    final backend = FirebaseFirestore.instance;

    // User Id
    final userId = BehaviorSubject<String?>();

    // Upon changes to user id, retrieve our contacts
    final Stream<Iterable<Contact>> contacts = userId
        // switchMap returns a new stream unlike map returning dynamic value
        .switchMap<_SnapShots>((userId) {
      if (userId == null) return const Stream<_SnapShots>.empty();

      return backend.collection(userId).snapshots();
    })
        // sync* for returning iterable value, and async* for returning stream valueF
        .map((snapshots) sync* {
      for (final doc in snapshots.docs) {
        yield Contact.fromJson(
          doc.data(),
          id: doc.id,
        );
      }

      // or
      // final Iterable<Contact> list =
      //     snapshots.docs.map((e) => Contact.fromJson(e.data(), id: e.id));
      // yield* list;
    });

    // Create Contact
    final createContact = BehaviorSubject<Contact>();
    final createContactSubscription = createContact.switchMap((contactToCreate) {
      return userId
          .take(1)
          .unwrap()
          .asyncMap((userId) => backend.collection(userId).add(contactToCreate.json));
    }).listen((event) {});

    // Delete Contact
    final deleteContact = BehaviorSubject<Contact>();
    final deleteContactSubscription = deleteContact.switchMap((contactToDelete) {
      return userId
          .take(1)
          .unwrap()
          .asyncMap((userId) => backend.collection(userId).doc(contactToDelete.id).delete());
    }).listen((event) {});

    // Delete all contacts
    final deleteAllContacts = BehaviorSubject<void>();
    final StreamSubscription<void> deleteAllContactsSubscription = deleteAllContacts
        .switchMap((_) => userId.take(1).unwrap())
        .asyncMap((userId) => backend.collection(userId).get())
        .switchMap((collection) =>
            Stream.fromFutures(collection.docs.map((doc) => doc.reference.delete())))
        .listen((_) {});

    return ContactBloc._(
      userId: userId,
      createContact: createContact,
      deleteContact: deleteContact,
      deleteAllContacts: deleteAllContacts,
      contacts: contacts,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription,
      deleteAllContactsSubscription: deleteAllContactsSubscription,
    );
  }
}

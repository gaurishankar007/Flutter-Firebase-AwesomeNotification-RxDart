import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/remote/models/person_model.dart';
import '../../../data/remote/repositories/firebase_auth_repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CollectionReference _personRef =
      FirebaseFirestore.instance.collection("users");

  final Stream<QuerySnapshot<Map<String, dynamic>>> personStream =
      FirebaseFirestore.instance.collection("users").snapshots();

  HomeBloc() : super(HomeInitialState()) {
    final User? user = AuthFirebase().currentUser;

    final formKey = GlobalKey<FormState>();

    on<HomeLoadedEvent>((event, emit) {
      emit(HomeLoadedState(
        userEmail: user?.email ?? "User",
        formKey: formKey,
        personStream: personStream,
      ));
    });
    on<AddPersonEvent>(_addPerson);
    on<UpdatePersonEvent>(_updatePerson);
    on<DeletePersonEvent>(_deleteUser);
  }

  _addPerson(event, emit) async {
    await _personRef.add(event.person.toJson());
  }

  _updatePerson(event, emit) async {
    await _personRef.doc(event.personId).update(event.person.toJson());
  }

  _deleteUser(event, emit) async {
    await _personRef.doc(event.personId).delete();
  }
}

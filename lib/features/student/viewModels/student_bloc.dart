import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../form/update_student_form.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../models/student.dart';

typedef _Map = Map<String, dynamic>;
typedef _QuerySnapshot = QuerySnapshot<_Map>;
typedef _DocumentReference = DocumentReference<_Map>;

extension Unwrap<T> on Stream<T?> {
  /// Skips null values
  Stream<T> unwrap() {
    return switchMap((optional) async* {
      if (optional != null) yield optional;
    });
  }
}

@immutable
class StudentBloc {
  final Sink<String?> userId;
  final Sink<Student> createStudent;
  final Sink<UpdateStudentForm> updateStudent;
  final Sink<Student> deleteStudent;
  final Sink<void> deleteAllStudents;
  final Stream<Iterable<Student>> students;
  final StreamSubscription<void> _createStudentSubscription;
  final StreamSubscription<void> _updateStudentSubscription;
  final StreamSubscription<void> _deleteStudentSubscription;
  final StreamSubscription<void> _deleteAllStudentsSubscription;

  const StudentBloc._({
    required this.userId,
    required this.createStudent,
    required this.updateStudent,
    required this.deleteStudent,
    required this.deleteAllStudents,
    required this.students,
    required StreamSubscription<void> createStudentSubscription,
    required StreamSubscription<void> updateStudentSubscription,
    required StreamSubscription<void> deleteStudentSubscription,
    required StreamSubscription<void> deleteAllStudentsSubscription,
  })  : _createStudentSubscription = createStudentSubscription,
        _updateStudentSubscription = updateStudentSubscription,
        _deleteStudentSubscription = deleteStudentSubscription,
        _deleteAllStudentsSubscription = deleteAllStudentsSubscription;

  void dispose() {
    userId.close();
    createStudent.close();
    updateStudent.close();
    deleteStudent.close();
    _createStudentSubscription.cancel();
    _updateStudentSubscription.cancel();
    _deleteStudentSubscription.cancel();
    _deleteAllStudentsSubscription.cancel();
  }

  factory StudentBloc() {
    final backend = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;
    final CollectionReference<_Map> collection = backend.collection("students");

    // User Id
    final userIdSubject = BehaviorSubject<String?>();

    // Upon changes to user id, retrieve our students
    final Stream<Iterable<Student>> students = userIdSubject.switchMap<_QuerySnapshot>((userId) {
      // switchMap returns a new stream unlike map returning dynamic value
      if (userId == null) {
        return const Stream<_QuerySnapshot>.empty();
      }

      Query<_Map> query = collection.where("user_id", isEqualTo: userId);
      Stream<_QuerySnapshot> snapshots = query.snapshots();

      return snapshots;
    }).map((snapshots) sync* {
      // sync* for returning iterable value, and async* for returning stream value
      for (final doc in snapshots.docs) {
        yield Student.fromJson(doc.data(), id: doc.id);
      }
    });

    // Create Student
    final createStudentSubject = BehaviorSubject<Student>();
    final createStudentSubscription = createStudentSubject.switchMap((studentToCreate) {
      Stream<String> userIdStream = userIdSubject.take(1).unwrap();

      Stream<_DocumentReference> stream = userIdStream.asyncMap((userId) {
        _Map studentJson = studentToCreate.copyWith(userId: userId).json();
        Future<_DocumentReference> reference = collection.add(studentJson);

        return reference;
      });

      return stream;
    }).listen((event) {});

    // Update Student
    final updateStudent = BehaviorSubject<UpdateStudentForm>();
    final updateStudentSubscription = updateStudent.asyncMap((form) {
      Student student = form.student;
      if (form.imagePath.isNotEmpty) {
        Reference reference = storage.ref("profile_pictures/${student.id}");

        reference
            .putFile(File(form.imagePath))
            .then((task) => task.ref.getDownloadURL())
            .then((url) {
          student = student.copyWith(profilePicture: url);
          _DocumentReference reference = collection.doc(student.id);
          Future<void> future = reference.update(student.json());
          return future;
        });
      }

      _DocumentReference reference = collection.doc(student.id);
      Future<void> future = reference.update(student.json());
      return future;
    }).listen((event) {});

    // Delete Student
    final deleteStudent = BehaviorSubject<Student>();
    final deleteStudentSubscription = deleteStudent.asyncMap((studentToDelete) {
      return collection.doc(studentToDelete.id).delete();
    }).listen((event) {});

    // Delete all students
    final deleteAllStudentsSubject = BehaviorSubject<void>();
    final StreamSubscription<void> deleteAllStudentsSubscription = deleteAllStudentsSubject
        .switchMap((_) => userIdSubject.take(1).unwrap())
        .asyncMap((userId) {
      Query<_Map> query = collection.where("user_id", isEqualTo: userId);
      Future<_QuerySnapshot> snapshot = query.get();

      return snapshot;
    }).switchMap((snapshot) {
      Iterable<Future<void>> futureTasks = snapshot.docs.map((doc) => doc.reference.delete());
      Stream<void> stream = Stream.fromFutures(futureTasks);

      return stream;
    }).listen((_) {});

    return StudentBloc._(
      userId: userIdSubject,
      createStudent: createStudentSubject,
      updateStudent: updateStudent,
      deleteStudent: deleteStudent,
      deleteAllStudents: deleteAllStudentsSubject,
      students: students,
      createStudentSubscription: createStudentSubscription,
      updateStudentSubscription: updateStudentSubscription,
      deleteStudentSubscription: deleteStudentSubscription,
      deleteAllStudentsSubscription: deleteAllStudentsSubscription,
    );
  }
}

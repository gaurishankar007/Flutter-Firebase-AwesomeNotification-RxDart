part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoadedEvent extends HomeEvent {}

class AddPersonEvent extends HomeEvent {
  final Person person;

  const AddPersonEvent({required this.person});

  @override
  List<Object> get props => [];
}

class UpdatePersonEvent extends HomeEvent {
  final Person person;
  final String personId;

  const UpdatePersonEvent({
    required this.person,
    required this.personId,
  });

  @override
  List<Object> get props => [person, personId];
}

class DeletePersonEvent extends HomeEvent {
  final String personId;

  const DeletePersonEvent({required this.personId});

  @override
  List<Object> get props => [personId];
}

part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadedState extends HomeState {
  final String userEmail;
  final GlobalKey<FormState> formKey;
  final Stream<QuerySnapshot<Map<String, dynamic>>> personStream;

  const HomeLoadedState({
    required this.userEmail,
    required this.formKey,
    required this.personStream,
  });

  @override
  List<Object> get props => [
        userEmail,
        formKey,
        personStream,
      ];
}

import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';

import 'current_view.dart';

@immutable
class ViewBloc {
  final Sink<CurrentView> goToView;
  final Stream<CurrentView> currentView;

  const ViewBloc._({
    required this.goToView,
    required this.currentView,
  });

  void dispose() {
    goToView.close();
  }

  factory ViewBloc() {
    final goToViewSubject = BehaviorSubject<CurrentView>();

    return ViewBloc._(
      goToView: goToViewSubject,
      currentView: goToViewSubject.startWith(
        CurrentView.login,
      ),
    );
  }
}

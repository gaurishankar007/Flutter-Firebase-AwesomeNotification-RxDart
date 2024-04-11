import 'package:flutter/foundation.dart' show immutable;
import 'package:rxdart/rxdart.dart';

import '../models/view_data.dart';
import 'current_view.dart';

@immutable
class ViewBloc {
  final Sink<ViewData> goToView;
  final Stream<ViewData> viewData;

  const ViewBloc._({
    required this.goToView,
    required this.viewData,
  });

  void dispose() {
    goToView.close();
  }

  factory ViewBloc() {
    final goToViewSubject = BehaviorSubject<ViewData>();

    return ViewBloc._(
      goToView: goToViewSubject,
      viewData: goToViewSubject.startWith(
        const ViewData(currentView: CurrentView.login),
      ),
    );
  }
}

import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdateLoadingScreen = bool Function(String string);

/// A controller for closing and updating the text of the loading screen
@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({required this.close, required this.update});
}

import 'dart:async';

import 'package:flutter/material.dart';

import 'loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final LoadingScreen _singleton = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _singleton;

  LoadingScreenController? controller;

  /// Displays an overlay on the screen
  void show({
    required BuildContext context,
    required String text,
  }) {
    // update text if loading screen is present in the screen
    if (controller?.update(text) ?? false) return;

    controller = _showOverlay(context, text);
  }

  /// Removes the overlay from the screen
  void hide() {
    controller?.close();
    controller = null;
  }

  LoadingScreenController _showOverlay(
    BuildContext context,
    String text,
  ) {
    final textObserver = StreamController<String>();
    textObserver.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final availableSize = renderBox.size;

    final container = Container(
      constraints: BoxConstraints(
        maxWidth: availableSize.width * 0.8,
        minWidth: availableSize.width * 0.5,
        maxHeight: availableSize.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            const CircularProgressIndicator(),
            const SizedBox(height: 10.0),
            StreamBuilder<String>(
              stream: textObserver.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.requireData, textAlign: TextAlign.center);
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(child: container),
        );
      },
    );

    // Display the overlay
    final state = Overlay.of(context);
    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        textObserver.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textObserver.add(text);
        return true;
      },
    );
  }
}

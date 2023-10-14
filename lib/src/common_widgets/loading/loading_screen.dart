import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocketfi/src/constants/strings.dart';

import 'loading_screen_controller.dart';

class LoadingScreen {
  // private constructor
  LoadingScreen.sharedInstance();

  // singleton
  static final LoadingScreen _shared = LoadingScreen.sharedInstance();

  // factory constructor
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  // show loading screen (based on controller)
  // if controller is null, create new controller
  void show({
    required BuildContext context,
    String text = Strings.loading,
  }) {
    if (_controller?.update(text) ?? false) {
      // return if controller is not null and update is successful
      return;
    } else {
      // else create new controller
      _controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  // hide loading screen (based on controller)
  void hide() {
    _controller?.close();
    _controller = null;
  }

  // update loading screen )
  LoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    // get overlay state
    final state = Overlay.of(context);
    // ignore: unnecessary_null_comparison
    if (state == null) {
      return null; // return if state is null
    }

    // create stream controller
    // this is used to update the text in the loading screen
    // without having to rebuild the entire loading screen
    // (which will cause the loading screen to flicker)
    // this is because the loading screen is an overlay
    // and it will be rebuilt every time the state changes
    // (which is every time the text is updated)
    // so we use a stream to update the text
    final textController = StreamController<String>(); // create stream
    textController.add(text); // add initial text in stream

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // create overlay of loading screen (UI)
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150), // dim background
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10.0),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10.0),
                      StreamBuilder<String>(
                          stream: textController.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.requireData,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                    ),
                              );
                            } else {
                              return Container();
                            }
                          }),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    // add overlay to state
    state.insert(overlay);

    // return controller
    return LoadingScreenController(
      close: () {
        textController.close();
        overlay.remove();
        return true;
      },
      update: (String text) {
        textController.add(text);
        return true;
      },
    );
  }
}

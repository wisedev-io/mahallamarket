import 'dart:async';
import 'package:flutter/material.dart';

void installErrorOverlay() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.current);
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SelectionArea(
            child: Text(
              '💥 Widget error:\\n\\n${details.exceptionAsString()}\\n\\n${details.stack ?? ''}',
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  };
}

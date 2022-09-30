// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider_signin_playground/src/app.dart';
import 'package:provider_signin_playground/src/exceptions/async_error_logger.dart';
import 'package:provider_signin_playground/src/exceptions/error_logger.dart';

void main() async {
  late ErrorLogger errorLogger;
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);

    final container = ProviderContainer(
      observers: [AsyncErrorLogger()],
    );
    errorLogger = container.read(errorLoggerProvider);
    runApp(UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ));

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

    ErrorWidget.builder = (details) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text('An error occurred'),
        ),
        body: Center(child: Text(details.toString())),
      );
    };
  }, (Object error, StackTrace stack) {
    errorLogger.logError(error, stack);
    // print(error);
  });
}

// void main() {
//   runApp(const ProviderScope(
//       child: MyApp(),
//     ));
// }

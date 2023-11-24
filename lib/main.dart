import 'dart:io';

import 'package:avd_manager/app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';

import 'src/widgets/desktop_window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // If desktop
  if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    await windowManager.ensureInitialized();
  }

  runApp(const ProviderScope(child: DesktopWindowManager(child: MyApp())));
}

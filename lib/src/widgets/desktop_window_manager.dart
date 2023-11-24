import 'dart:convert';

import 'package:avd_manager/src/constants/shared_preferences_keys.dart';
import 'package:avd_manager/src/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class DesktopWindowManager extends StatefulWidget {
  const DesktopWindowManager({super.key, required this.child});

  final Widget child;

  @override
  State<DesktopWindowManager> createState() => _DesktopWindowManagerState();
}

class _DesktopWindowManagerState extends State<DesktopWindowManager>
    with WindowListener {
  late final _debounce = Debounce(duration: const Duration(milliseconds: 500));

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);

    restoreWindowSize();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _debounce.dispose();
    super.dispose();
  }

  @override
  void onWindowResize() {
    _debounce.run(() => saveWindowSize());
  }

  Future<void> restoreWindowSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? windowSizeFromStorage =
        prefs.getString(SharedPreferencesKeys.desktopWindowSize);

    final windowSize = windowSizeFromStorage == null
        ? const WindowSize(width: 400, height: 300)
        : WindowSize.fromJson(
            jsonDecode(windowSizeFromStorage) as Map<String, dynamic>,
          );
    await windowManager.setSize(Size(windowSize.width, windowSize.height));
  }

  Future<void> saveWindowSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final size = await windowManager.getSize();
    final windowSize = WindowSize(
      width: size.width,
      height: size.height,
    ).toJson();
    await prefs.setString(
      SharedPreferencesKeys.desktopWindowSize,
      jsonEncode(windowSize),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class WindowSize {
  final double width;
  final double height;

  const WindowSize({
    required this.width,
    required this.height,
  });

  factory WindowSize.fromJson(Map<String, dynamic> json) {
    return WindowSize(
      width: json['width'] as double,
      height: json['height'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
    };
  }
}

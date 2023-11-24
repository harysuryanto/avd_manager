import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:process_run/shell.dart';

final adbDevicesProvider = FutureProvider<List<String>>(
  (ref) async {
    final shell = Shell();
    final results = await shell.run('adb devices');
    return results.map((e) => e.outText).first.trim().split('\n')..removeAt(0);
  },
);

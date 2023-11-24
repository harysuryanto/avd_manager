import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:process_run/shell.dart';

final avdsProvider = FutureProvider<List<String>>(
  (ref) async {
    final results = await run('emulator -list-avds');
    return results.map((e) => e.outText).toList();
  },
);

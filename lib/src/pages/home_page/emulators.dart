import 'package:avd_manager/src/providers/adb_devices_provider.dart';
import 'package:avd_manager/src/providers/avds_provider.dart';
import 'package:avd_manager/src/widgets/async_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:process_run/shell.dart';

class Emulators extends ConsumerWidget {
  const Emulators({super.key});

  Future<void> _startAvd(WidgetRef ref, String name) async {
    final shell = Shell();
    await shell.run('emulator -avd $name -no-boot-anim');
    ref.invalidate(adbDevicesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = avdsProvider;

    return AsyncValueWidget(
      value: ref.watch(provider),
      refreshAction: () => ref.refresh(provider.future),
      skipLoadingOnRefresh: true,
      data: (data) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: data
            .map(
              (e) => ListTile(
                title: Text(e),
                trailing: TextButton(
                  onPressed: () => _startAvd(ref, e),
                  child: const Text('Start'),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

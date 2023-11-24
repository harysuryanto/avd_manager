import 'package:avd_manager/src/pages/home_page/adb_devices.dart';
import 'package:avd_manager/src/pages/home_page/emulators.dart';
import 'package:avd_manager/src/providers/adb_devices_provider.dart';
import 'package:avd_manager/src/providers/avds_provider.dart';
import 'package:avd_manager/src/utils/snackbar_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:process_run/shell.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  /// Returns [true] if success, otherwise returns [false].
  Future<bool> _connectDevice(
    WidgetRef ref,
    BuildContext context,
    String serialNumber,
  ) async {
    final result = (await run('adb connect $serialNumber')).first.outText;

    if (context.mounted) {
      context.showSnackBarMessage(result);

      final isConnected = result.contains('connected');
      if (isConnected) {
        ref.invalidate(adbDevicesProvider);
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final serialNumberController = useTextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Emulators',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => ref.refresh(avdsProvider.future),
                  icon: const Icon(Icons.refresh),
                )
              ],
            ),
            const Card(child: Emulators()),
            const Gap(8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'ADB devices',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog.adaptive(
                      title: const Text('Connect new device'),
                      content: TextFormField(
                        controller: serialNumberController,
                        decoration: InputDecoration(
                          hintText: 'Type serial number',
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final clipboard = (await Clipboard.getData(
                                      Clipboard.kTextPlain))
                                  ?.text;
                              if (clipboard != null) {
                                serialNumberController.text = clipboard;
                              }
                            },
                            icon: const Icon(Icons.paste),
                          ),
                        ),
                        autofocus: true,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            final isSuccess = await _connectDevice(
                              ref,
                              context,
                              serialNumberController.text,
                            );
                            if (context.mounted && isSuccess) {
                              serialNumberController.text = '';
                              // Close modal
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Connect'),
                        ),
                      ],
                    ),
                  ),
                  icon: const Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () => ref.refresh(adbDevicesProvider.future),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const Card(child: AdbDevices()),
            const Gap(16),
            Text(
              'Developed by Hary Suryanto',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

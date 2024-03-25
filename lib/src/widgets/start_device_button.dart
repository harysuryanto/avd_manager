import 'package:avd_manager/src/providers/adb_devices_provider.dart';
import 'package:avd_manager/src/utils/snackbar_message.dart';
import 'package:avd_manager/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:process_run/shell.dart';

class StartDeviceButton extends HookConsumerWidget {
  const StartDeviceButton({
    super.key,
    required this.serialNumber,
  });

  final String serialNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStarting = useState(false);

    /// Returns [true] if success, otherwise returns [false].
    Future<bool> connectDevice(
      String serialNumber, [
      bool coldBoot = false,
    ]) async {
      isStarting.value = true;

      final result = (await run(
        'emulator @$serialNumber ${coldBoot ? '-no-snapshot-load' : ''}',
      ))
          .first
          .outText;

      isStarting.value = false;

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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Button(
          onPressed: () => connectDevice(serialNumber),
          isLoading: isStarting.value,
          child: const Text('Start'),
        ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              onTap: () => connectDevice(serialNumber, true),
              child: const Text('Cold start'),
            ),
          ],
        ),
      ],
    );
  }
}

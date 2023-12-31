import 'dart:async';

import 'package:avd_manager/src/providers/adb_devices_provider.dart';
import 'package:avd_manager/src/utils/snackbar_message.dart';
import 'package:avd_manager/src/widgets/async_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:process_run/shell.dart';

class _DeviceStatus {
  static const offline = 'offline';
  static const device = 'device';
  static const noDevice = 'no device';

  const _DeviceStatus._();
}

class AdbDevices extends HookConsumerWidget {
  const AdbDevices({super.key});

  Future<void> _connectDevice(
    WidgetRef ref,
    BuildContext context,
    String serialNumber,
  ) async {
    final result = (await run('adb connect $serialNumber')).first.outText;
    ref.invalidate(adbDevicesProvider);

    if (context.mounted) {
      context.showSnackBarMessage(result);
    }
  }

  Future<void> _disconnectDevice(
    WidgetRef ref,
    BuildContext context,
    String serialNumber,
  ) async {
    final result = (await run('adb disconnect $serialNumber')).first.outText;
    ref.invalidate(adbDevicesProvider);

    if (context.mounted) {
      context.showSnackBarMessage(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = adbDevicesProvider;

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        ref.invalidate(adbDevicesProvider);
      });
      return () => timer.cancel();
    }, []);

    return AsyncValueWidget(
      value: ref.watch(provider),
      refreshAction: () => ref.refresh(provider.future),
      skipLoadingOnRefresh: true,
      data: (data) => data.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text('Empty'),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: data.map(
                (e) {
                  final serialNumber = e.split('	').first;
                  final status = e.split('	').last;
                  return ListTile(
                    title: Row(
                      children: [
                        Text(serialNumber),
                        const Gap(4),
                        InkWell(
                          onTap: () => Clipboard.setData(
                            ClipboardData(text: serialNumber),
                          ).then(
                            (value) => context.showSnackBarMessage(
                              'Copied $serialNumber',
                            ),
                          ),
                          child: const Icon(Icons.copy, size: 10),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(status),
                        const Gap(4),
                        Tooltip(
                          message: switch (status) {
                            _DeviceStatus.offline =>
                              'The device is not connected to adb or is not responding',
                            _DeviceStatus.device =>
                              'The device is connected to the adb server. Note that this state does not imply that the Android system is fully booted and operational, because the device connects to adb while the system is still booting. After boot-up, this is the normal operational state of a device.',
                            _DeviceStatus.noDevice =>
                              'There is no device connected',
                            _ => ''
                          },
                          child: const Icon(Icons.info_outline, size: 10),
                        ),
                      ],
                    ),
                    trailing: TextButton(
                      onPressed: () => status == _DeviceStatus.device
                          ? _disconnectDevice(ref, context, serialNumber)
                          : _connectDevice(ref, context, serialNumber),
                      child: Text(
                        status == _DeviceStatus.device
                            ? 'Disconnect'
                            : 'Connect',
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
    );
  }
}

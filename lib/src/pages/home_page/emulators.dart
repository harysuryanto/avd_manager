import 'dart:async';

import 'package:avd_manager/src/providers/adb_devices_provider.dart';
import 'package:avd_manager/src/providers/avds_provider.dart';
import 'package:avd_manager/src/widgets/async_value_widget.dart';
import 'package:avd_manager/src/widgets/start_device_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Emulators extends HookConsumerWidget {
  const Emulators({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = avdsProvider;

    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 10), (timer) {
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
              children: data
                  .map(
                    (serialNumber) => ListTile(
                      title: Text(serialNumber),
                      trailing: StartDeviceButton(serialNumber: serialNumber),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

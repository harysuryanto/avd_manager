import 'package:avd_manager/src/pages/home/adb_devices.dart';
import 'package:avd_manager/src/pages/home/emulators.dart';
import 'package:avd_manager/src/providers/adb_devices_provider.dart';
import 'package:avd_manager/src/providers/avds_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Emulators'),
                IconButton(
                  onPressed: () => ref.refresh(avdsProvider.future),
                  icon: ref.watch(avdsProvider).isRefreshing
                      ? const CircularProgressIndicator.adaptive()
                      : const Icon(Icons.refresh),
                )
              ],
            ),
            const Emulators(),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ADB devices'),
                IconButton(
                  onPressed: () => ref.refresh(adbDevicesProvider.future),
                  icon: ref.watch(adbDevicesProvider).isRefreshing
                      ? const CircularProgressIndicator.adaptive()
                      : const Icon(Icons.refresh),
                )
              ],
            ),
            const AdbDevices(),
          ],
        ),
      ),
    );
  }
}

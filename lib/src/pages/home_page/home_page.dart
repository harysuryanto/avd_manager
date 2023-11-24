import 'package:avd_manager/src/pages/home_page/adb_devices.dart';
import 'package:avd_manager/src/pages/home_page/emulators.dart';
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
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emulators',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => ref.refresh(avdsProvider.future),
                  icon: ref.watch(avdsProvider).isRefreshing
                      ? const CircularProgressIndicator.adaptive()
                      : const Icon(Icons.refresh),
                )
              ],
            ),
            const Card(child: Emulators()),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ADB devices',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () => ref.refresh(adbDevicesProvider.future),
                  icon: ref.watch(adbDevicesProvider).isRefreshing
                      ? const CircularProgressIndicator.adaptive()
                      : const Icon(Icons.refresh),
                )
              ],
            ),
            const Card(child: AdbDevices()),
          ],
        ),
      ),
    );
  }
}

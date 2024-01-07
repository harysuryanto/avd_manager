import 'dart:async';

import 'package:avd_manager/src/widgets/my_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.child,
    this.backgroundColor,
  });

  final FutureOr<void> Function()? onPressed;
  final bool isLoading;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isLoading,
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.none,
              child: isLoading
                  ? const Row(
                      children: [
                        MyProgressIndicator(padding: EdgeInsets.zero),
                        Gap(10),
                      ],
                    )
                  : const SizedBox(),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

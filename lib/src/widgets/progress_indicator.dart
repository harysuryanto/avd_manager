import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: Theme.of(context).textTheme.bodyMedium?.fontSize,
      child: const CircularProgressIndicator.adaptive(strokeWidth: 3),
    );
  }
}

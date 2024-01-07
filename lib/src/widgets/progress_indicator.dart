import 'package:flutter/material.dart';

class MyProgressIndicator extends StatelessWidget {
  const MyProgressIndicator({
    super.key,
    this.padding = const EdgeInsets.all(8),
  });

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox.square(
        dimension: Theme.of(context).textTheme.bodyMedium?.fontSize,
        child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
      ),
    );
  }
}

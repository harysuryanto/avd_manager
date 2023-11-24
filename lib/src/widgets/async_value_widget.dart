import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Helps reduce repetitive code by providing default [loading] and [error] prop
/// for [AsyncValue], so you only need to assign the [data] prop.
///
/// [refreshAction] shows a refresh button if it is not null and [value] is error.
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.refreshAction,
    required this.data,
    this.error,
    this.loading,
    this.skipLoadingOnRefresh = false,
  });

  final AsyncValue<T> value;
  final void Function()? refreshAction;
  final Widget Function(T data) data;
  final Widget Function(
    Object error,
    StackTrace stackTrace,
    Widget defaultWidget,
  )? error;
  final Widget Function(Widget defaultWidget)? loading;
  final bool skipLoadingOnRefresh;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      error: (error, stackTrace) {
        if (this.error == null) {
          return _buildDefaultErrorWidget(error);
        }

        return this.error!(
          error,
          stackTrace,
          _buildDefaultErrorWidget(error),
        );
      },
      loading: () {
        if (this.loading == null) {
          return _buildDefaultLoadingWidget();
        }

        return this.loading!(_buildDefaultLoadingWidget());
      },
      skipLoadingOnRefresh: skipLoadingOnRefresh,
    );
  }

  Widget _buildDefaultLoadingWidget() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  Widget _buildDefaultErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(error.toString()),
          if (refreshAction != null) ...[
            const Gap(12),
            _RefreshButton(
              refreshAction: refreshAction!,
              isRefreshing: value.isRefreshing,
            ),
          ],
        ],
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({
    required this.refreshAction,
    required this.isRefreshing,
  });

  final void Function() refreshAction;
  final bool isRefreshing;

  @override
  Widget build(BuildContext context) {
    return isRefreshing
        ? const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: 14,
                child: CircularProgressIndicator.adaptive(strokeWidth: 2),
              ),
              Gap(8),
              Text('Refreshing'),
            ],
          )
        : ElevatedButton(
            onPressed: refreshAction,
            child: const Text('Refresh'),
          );
  }
}

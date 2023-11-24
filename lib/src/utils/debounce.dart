import 'dart:async';
import 'dart:ui';

class Debounce {
  /// Defaults to 500ms.
  final Duration? duration;
  Timer? _timer;

  Debounce({this.duration});

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) _timer?.cancel();

    _timer = Timer(
      duration ?? const Duration(milliseconds: 500),
      action,
    );
  }

  void dispose() => _timer?.cancel();
}

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// A widget that lets the user drag the entire window by clicking & dragging it.
/// Wrap any part of your UI with this to make it draggable.
class DragHandle extends StatelessWidget {
  final Widget child;

  const DragHandle({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onPanStart/Update/End track the drag gesture
      onPanStart: (_) {
        // Tell window_manager to start the drag operation.
        // This uses native Windows drag — much smoother than manual offset calculation.
        windowManager.startDragging();
      },
      child: child,
    );
  }
}
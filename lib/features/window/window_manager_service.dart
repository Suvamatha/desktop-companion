import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:screen_retriever/screen_retriever.dart';
import '../../core/constants/app_constants.dart';

class WindowManagerService {
  static final WindowManagerService _instance = WindowManagerService._internal();
  factory WindowManagerService() => _instance;
  WindowManagerService._internal();

  Future<void> initialize() async {
    await windowManager.ensureInitialized();

    // NOTE: removed `position:` from WindowOptions — newer window_manager
    // versions handle position separately via setPosition(). Safer to
    // create the window first, THEN move it.
    final WindowOptions options = WindowOptions(
      size: const Size(AppConstants.windowWidth, AppConstants.windowHeight),
      minimumSize: const Size(AppConstants.windowMinWidth, AppConstants.windowMinHeight),
      backgroundColor: Colors.transparent,
      skipTaskbar: true,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: false,
      alwaysOnTop: true,
    );

    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
      await windowManager.focus();

      // setAsFramelessWindow() doesn't exist in current versions —
      // TitleBarStyle.hidden above already gives us the frameless look.
      await windowManager.setHasShadow(false);

      await _positionBottomRight();
    });
  }

  Future<void> _positionBottomRight() async {
    final display = await screenRetriever.getPrimaryDisplay();
    final screenWidth = display.visibleSize?.width ?? 1920;
    final screenHeight = display.visibleSize?.height ?? 1080;

    final x = screenWidth - AppConstants.windowWidth - 24;
    final y = screenHeight - AppConstants.windowHeight - 60;

    await windowManager.setPosition(Offset(x, y));
  }

  Future<void> moveWindow(Offset delta) async {
    final currentPosition = await windowManager.getPosition();
    final newPosition = Offset(
      currentPosition.dx + delta.dx,
      currentPosition.dy + delta.dy,
    );

    final display = await screenRetriever.getPrimaryDisplay();
    final screenW = display.visibleSize?.width ?? 1920;
    final screenH = display.visibleSize?.height ?? 1080;

    final clampedX = newPosition.dx.clamp(0.0, screenW - AppConstants.windowWidth);
    final clampedY = newPosition.dy.clamp(0.0, screenH - AppConstants.windowHeight);

    await windowManager.setPosition(Offset(clampedX, clampedY));
  }

  Future<void> hide() async => await windowManager.hide();
  Future<void> show() async => await windowManager.show();
  Future<void> close() async => await windowManager.close();

  Future<bool> get isVisible async => await windowManager.isVisible();
}
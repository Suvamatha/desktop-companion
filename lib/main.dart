import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/window/window_manager_service.dart';
import 'shared/widgets/drag_handle.dart';

Future<void> main() async {
  // Must be called before any Flutter engine initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (local database) — stores data in AppData/Roaming
  await Hive.initFlutter();

  // Set up the transparent floating window
  final windowService = WindowManagerService();
  await windowService.initialize();

  runApp(
    MultiProvider(
      providers: [
        // We'll add Providers here in future phases
        // For now, just the window service is enough
      ],
      child: const DesktopCompanionApp(),
    ),
  );
}

class DesktopCompanionApp extends StatelessWidget {
  const DesktopCompanionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const CompanionShell(),
    );
  }
}

class CompanionShell extends StatelessWidget {
  const CompanionShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DragHandle(
        child: Container(
          decoration: BoxDecoration(
            // Glass morphism effect
            color: AppTheme.glassFill,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.glassBorder,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: const CompanionBody(),
          ),
        ),
      ),
    );
  }
}

class CompanionBody extends StatelessWidget {
  const CompanionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(context),

        Expanded(
          flex: 3,
          child: _buildCharacterPlaceholder(),
        ),

        Expanded(
          flex: 2,
          child: _buildStatsPlaceholder(context),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(color: AppTheme.glassBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Companion',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.onSurface,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          // Minimize button
          IconButton(
            icon: const Icon(Icons.remove_rounded, size: 18),
            color: AppTheme.onSurface.withOpacity(0.6),
            onPressed: () => WindowManagerService().hide(),
            tooltip: 'Minimize to tray',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterPlaceholder() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('(◕‿◕✿)', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text(
              'Phase 2: Character goes here',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsPlaceholder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Stats',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          _buildStatRow('CPU', '-- %', AppTheme.primaryColor),
          _buildStatRow('RAM', '-- GB', AppTheme.secondaryColor),
          _buildStatRow('Battery', '-- %', AppTheme.accentColor),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(label,
            style: const TextStyle(color: AppTheme.onSurface, fontSize: 13)),
          const Spacer(),
          Text(value,
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
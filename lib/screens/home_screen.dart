import 'dart:io';

import 'package:flutter/material.dart';
import '../theme/feather_icons.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import '../sessions/scan_session.dart';
import '../sessions/session_store.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'detect_screen.dart';
import 'session_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ScanSession> _sessions = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<ScanSession> sessions = await SessionStore.instance.all();
    if (mounted) setState(() => _sessions = sessions);
  }

  Future<void> _openDetect() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DetectScreen()),
    );
    _load();
  }

  Future<void> _openSession(ScanSession session) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SessionDetailScreen(session: session)),
    );
    _load();
  }

  void _pickLanguage() {
    final AppLocalizations l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  l10n.selectLanguage,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  LocaleController.setLocale(const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('हिंदी'),
                onTap: () {
                  LocaleController.setLocale(const Locale('hi'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LeafLens'),
        actions: [
          IconButton(
            onPressed: _pickLanguage,
            icon: Icon(FeatherIcons.globe,
                color: theme.colorScheme.onSurface),
            tooltip: l10n.selectLanguage,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          _FeatureCard(
            icon: FeatherIcons.camera,
            title: l10n.homeCardTitle,
            body: l10n.homeCardBody,
            actionLabel: l10n.scanLeaf,
            onTap: _openDetect,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(l10n.recentScans, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          if (_sessions.isEmpty)
            Text(l10n.noScansYet, style: theme.textTheme.bodyMedium)
          else
            for (final session in _sessions)
              _SessionTile(
                session: session,
                onTap: () => _openSession(session),
              ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: theme.dividerColor, width: 1),
        boxShadow: AppShadows.hard,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: theme.colorScheme.onSurface),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(body, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: onTap,
            child: Text(actionLabel.toUpperCase()),
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({required this.session, required this.onTap});

  final ScanSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String when =
        DateFormat('d MMM · h:mm a').format(session.createdAt);
    final Color statusColor =
        session.isHealthy ? theme.colorScheme.tertiary : theme.colorScheme.error;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppRadius.smRadius,
              child: Image.file(
                File(session.imagePath),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.displayName,
                      style: theme.textTheme.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text('$when · ${session.confidenceLabel}',
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                  color: statusColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(FeatherIcons.chevronRight,
                color: theme.colorScheme.secondary),
          ],
        ),
      ),
    );
  }
}

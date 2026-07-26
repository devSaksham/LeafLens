import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../sessions/scan_session.dart';
import '../theme/app_spacing.dart';
import 'treatment_screen.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({super.key, required this.session});

  final ScanSession session;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(session.displayName)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          ClipRRect(
            borderRadius: AppRadius.lgRadius,
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.file(File(session.imagePath), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(session.displayName, style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Chip(
                label: Text(
                    session.isHealthy ? l10n.healthyChip : l10n.diseaseChip),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.confidence(session.confidenceLabel),
                  style: theme.textTheme.labelLarge),
            ],
          ),
          if (!session.isHealthy) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TreatmentScreen(
                    rawLabel: session.rawLabel,
                    displayName: session.displayName,
                  ),
                ),
              ),
              child: Text(l10n.viewTreatment),
            ),
          ],
        ],
      ),
    );
  }
}

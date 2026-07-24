import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../theme/feather_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../ml/diagnosis.dart';
import '../ml/plant_disease_classifier.dart';
import '../sessions/session_store.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'assistant_screen.dart';
import 'treatment_screen.dart';

class DetectScreen extends StatefulWidget {
  const DetectScreen({super.key});

  @override
  State<DetectScreen> createState() => _DetectScreenState();
}

class _DetectScreenState extends State<DetectScreen> {
  final ImagePicker _picker = ImagePicker();

  Uint8List? _imageBytes;
  Diagnosis? _result;
  bool _analyzing = false;
  bool _hasRun = false;
  bool _failed = false;

  Future<void> _pick(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source);
      if (picked == null) return;
      final Uint8List bytes = await picked.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _result = null;
        _hasRun = false;
        _analyzing = true;
        _failed = false;
      });
      final Diagnosis? diagnosis =
          await PlantDiseaseClassifier.instance.classify(bytes);
      if (diagnosis != null && !diagnosis.isBackground) {
        await SessionStore.instance.add(imageBytes: bytes, diagnosis: diagnosis);
      }
      if (!mounted) return;
      setState(() {
        _result = diagnosis;
        _hasRun = true;
        _analyzing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _analyzing = false;
        _hasRun = true;
        _failed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.detectTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          Text(l10n.scanLeaf, style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(l10n.detectSubtitle, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          _ImageFrame(bytes: _imageBytes, analyzing: _analyzing),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _analyzing ? null : () => _pick(ImageSource.camera),
                  child: Text(l10n.camera),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      _analyzing ? null : () => _pick(ImageSource.gallery),
                  child: Text(l10n.gallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_failed)
            Text(l10n.analyzeError, style: theme.textTheme.bodyMedium)
          else if (_hasRun)
            _ResultCard(result: _result),
        ],
      ),
    );
  }
}

class _ImageFrame extends StatelessWidget {
  const _ImageFrame({required this.bytes, required this.analyzing});

  final Uint8List? bytes;
  final bool analyzing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: theme.colorScheme.onSurface, width: 2),
        ),
        clipBehavior: Clip.antiAlias,
        child: analyzing
            ? Center(
                child: CircularProgressIndicator(
                    color: theme.colorScheme.primary))
            : bytes == null
                ? Center(
                    child: Icon(
                      FeatherIcons.image,
                      size: 64,
                      color: theme.colorScheme.secondary,
                    ),
                  )
                : Image.memory(bytes!, fit: BoxFit.cover),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.result});

  final Diagnosis? result;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (result == null || result!.isBackground) {
      return _shell(
        theme,
        title: l10n.noPlantDetected,
        body: l10n.noPlantBody,
      );
    }

    final Diagnosis r = result!;
    final Color statusColor =
        r.isHealthy ? theme.colorScheme.tertiary : theme.colorScheme.error;

    return _shell(
      theme,
      title: r.displayName,
      body: r.isHealthy ? l10n.healthyMessage : l10n.diseaseMessage,
      accent: statusColor,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(
                label: Text(r.isHealthy ? l10n.healthyChip : l10n.diseaseChip),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(l10n.confidence(r.confidenceLabel),
                  style: theme.textTheme.labelLarge),
            ],
          ),
          if (!r.isHealthy) ...[
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TreatmentScreen(
                    rawLabel: r.rawLabel,
                    displayName: r.displayName,
                  ),
                ),
              ),
              child: Text(l10n.viewTreatment),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AssistantScreen(disease: r.displayName),
                ),
              ),
              child: Text(l10n.askAssistant),
            ),
          ],
        ],
      ),
    );
  }

  Widget _shell(
    ThemeData theme, {
    required String title,
    required String body,
    Color? accent,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: accent ?? theme.colorScheme.onSurface,
          width: 2,
        ),
        boxShadow: AppShadows.hard,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(body, style: theme.textTheme.bodyMedium),
          if (trailing != null) ...[
            const SizedBox(height: AppSpacing.md),
            trailing,
          ],
        ],
      ),
    );
  }
}

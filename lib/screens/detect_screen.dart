import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../theme/feather_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/app_localizations.dart';
import '../ml/diagnosis.dart';
import '../ml/plant_disease_classifier.dart';
import '../ml/saliency_map.dart';
import '../sessions/session_store.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../widgets/saliency_overlay.dart';
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
  SaliencyMap? _saliency;
  bool _analyzing = false;
  bool _explaining = false;
  bool _showFocus = true;
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
        _saliency = null;
        _hasRun = false;
        _analyzing = true;
        _explaining = false;
        _showFocus = true;
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
        _explaining = diagnosis != null && !diagnosis.isBackground;
      });
      if (_explaining) await _explain(bytes, diagnosis!);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _analyzing = false;
        _explaining = false;
        _hasRun = true;
        _failed = true;
      });
    }
  }

  Future<void> _explain(Uint8List bytes, Diagnosis diagnosis) async {
    SaliencyMap? map;
    try {
      map = await PlantDiseaseClassifier.instance.saliencyFor(bytes, diagnosis);
    } catch (e) {
      map = null;
    }
    if (!mounted) return;
    setState(() {
      _saliency = map;
      _explaining = false;
    });
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
          _ImageFrame(
            bytes: _imageBytes,
            analyzing: _analyzing,
            saliency: _showFocus ? _saliency : null,
          ),
          if (_explaining || _saliency != null) ...[
            const SizedBox(height: AppSpacing.md),
            _FocusPanel(
              busy: _explaining,
              showingFocus: _showFocus,
              onToggle: () => setState(() => _showFocus = !_showFocus),
            ),
          ],
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
  const _ImageFrame({
    required this.bytes,
    required this.analyzing,
    this.saliency,
  });

  final Uint8List? bytes;
  final bool analyzing;
  final SaliencyMap? saliency;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: theme.dividerColor, width: 1),
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
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(bytes!, fit: BoxFit.cover),
                      if (saliency != null) SaliencyOverlay(map: saliency!),
                    ],
                  ),
      ),
    );
  }
}

class _FocusPanel extends StatelessWidget {
  const _FocusPanel({
    required this.busy,
    required this.showingFocus,
    required this.onToggle,
  });

  final bool busy;
  final bool showingFocus;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.aiFocusTitle, style: theme.textTheme.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        if (busy)
          Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(l10n.focusComputing,
                    style: theme.textTheme.bodySmall),
              ),
            ],
          )
        else ...[
          Text(l10n.focusCaption, style: theme.textTheme.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(
            onPressed: onToggle,
            child: Text(showingFocus ? l10n.focusHide : l10n.focusShow),
          ),
        ],
      ],
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
          color: accent ?? theme.dividerColor,
          width: 1,
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

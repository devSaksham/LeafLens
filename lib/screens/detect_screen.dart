import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../ml/diagnosis.dart';
import '../ml/plant_disease_classifier.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'assistant_screen.dart';

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
  String? _error;

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
        _error = null;
      });
      final Diagnosis? diagnosis =
          await PlantDiseaseClassifier.instance.classify(bytes);
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
        _error = 'Could not analyze this image.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Detect')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          Text('Scan a leaf', style: theme.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Point at a single leaf in good light for the best result.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          _ImageFrame(bytes: _imageBytes, analyzing: _analyzing),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _analyzing ? null : () => _pick(ImageSource.camera),
                  child: Text('CAMERA'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      _analyzing ? null : () => _pick(ImageSource.gallery),
                  child: Text('GALLERY'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_error != null)
            Text(_error!, style: theme.textTheme.bodyMedium)
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
            ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
            : bytes == null
                ? Center(
                    child: Icon(
                      Icons.image_outlined,
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

    if (result == null || result!.isBackground) {
      return _shell(
        theme,
        title: 'No plant detected',
        body: 'Try again with a clearer photo of a single leaf.',
      );
    }

    final Diagnosis r = result!;
    final Color statusColor =
        r.isHealthy ? theme.colorScheme.tertiary : theme.colorScheme.error;

    return _shell(
      theme,
      title: r.displayName,
      body: r.isHealthy
          ? 'This plant looks healthy.'
          : 'A disease was detected. Ask the assistant for treatment tips.',
      accent: statusColor,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Chip(label: Text(r.isHealthy ? 'HEALTHY' : 'DISEASE')),
              const SizedBox(width: AppSpacing.sm),
              Text('Confidence ${r.confidenceLabel}',
                  style: theme.textTheme.labelLarge),
            ],
          ),
          if (!r.isHealthy) ...[
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AssistantScreen(disease: r.displayName),
                ),
              ),
              child: Text('ASK ASSISTANT'),
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

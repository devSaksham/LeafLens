import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../location/location_service.dart';
import '../ml/gemini_assistant.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import '../treatment/treatment.dart';
import '../treatment/treatment_repository.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({
    super.key,
    required this.rawLabel,
    required this.displayName,
  });

  final String rawLabel;
  final String displayName;

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  bool _started = false;
  bool _loading = true;
  Treatment? _treatment;
  String? _regionalNote;
  bool _loadingNote = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _load(Localizations.localeOf(context).languageCode);
  }

  Future<void> _load(String languageCode) async {
    final Treatment? t =
        await TreatmentRepository.instance.forLabel(widget.rawLabel);
    if (!mounted) return;
    setState(() {
      _treatment = t;
      _loading = false;
    });
    if (t == null || t.isHealthy) return;

    setState(() => _loadingNote = true);
    try {
      final String? location = await LocationService.instance.currentPlace();
      final String base = '${t.summary} ${t.doNow.join('; ')}';
      final String note = await GeminiAssistant.instance.locationNuance(
        disease: widget.displayName,
        baseAdvice: base,
        languageCode: languageCode,
        location: location,
      );
      if (!mounted) return;
      setState(() {
        _regionalNote = note;
        _loadingNote = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingNote = false);
    }
  }

  String _pretty(String token) => token
      .split('_')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.treatmentTitle)),
      body: _loading
          ? Center(
              child:
                  CircularProgressIndicator(color: theme.colorScheme.primary))
          : _treatment == null
              ? Padding(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  child: Text(l10n.noTreatment,
                      style: theme.textTheme.bodyLarge),
                )
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.gutter),
                  children: [
                    Text(widget.displayName,
                        style: theme.textTheme.displaySmall),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        if (_treatment!.cause.isNotEmpty &&
                            _treatment!.cause != 'none')
                          Chip(label: Text(_pretty(_treatment!.cause))),
                        if (_treatment!.severity.isNotEmpty)
                          Chip(label: Text(_pretty(_treatment!.severity))),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(_treatment!.summary, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: AppSpacing.lg),
                    _Section(title: l10n.doNow, items: _treatment!.doNow),
                    _Section(
                        title: l10n.organicLabel, items: _treatment!.organic),
                    _Section(
                        title: l10n.chemicalLabel, items: _treatment!.chemical),
                    _Section(
                        title: l10n.preventLabel, items: _treatment!.prevent),
                    if (_loadingNote || _regionalNote != null)
                      _RegionalNote(
                        title: l10n.regionalNote,
                        loadingText: l10n.loadingRegionalNote,
                        note: _regionalNote,
                        loading: _loadingNote,
                      ),
                  ],
                ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: theme.colorScheme.onSurface, width: 2),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: theme.textTheme.bodyMedium),
                  Expanded(
                    child: Text(item, style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RegionalNote extends StatelessWidget {
  const _RegionalNote({
    required this.title,
    required this.loadingText,
    required this.note,
    required this.loading,
  });

  final String title;
  final String loadingText;
  final String? note;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: theme.colorScheme.tertiary, width: 2),
        boxShadow: AppShadows.hard,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          if (loading)
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                    child: Text(loadingText,
                        style: theme.textTheme.bodyMedium)),
              ],
            )
          else
            Text(note ?? '', style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

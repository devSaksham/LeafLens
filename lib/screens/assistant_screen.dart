import 'package:flutter/material.dart';
import '../theme/feather_icons.dart';

import '../l10n/app_localizations.dart';
import '../location/location_service.dart';
import '../ml/gemini_assistant.dart';
import '../theme/app_spacing.dart';

class _Message {
  final String text;
  final bool fromUser;
  const _Message(this.text, {required this.fromUser});
}

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key, this.disease});

  final String? disease;

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> _messages = [];
  bool _thinking = false;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String greeting = widget.disease == null
        ? l10n.assistantGreeting
        : l10n.assistantGreetingDisease(widget.disease!);
    _messages.add(_Message(greeting, fromUser: false));
    LocationService.instance.requestPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final String text = _controller.text.trim();
    if (text.isEmpty || _thinking) return;
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String languageCode = Localizations.localeOf(context).languageCode;
    setState(() {
      _messages.add(_Message(text, fromUser: true));
      _controller.clear();
      _thinking = true;
    });
    try {
      final String? location = await LocationService.instance.currentPlace();
      final String answer = await GeminiAssistant.instance.reply(
        history:
            _messages.map((m) => (text: m.text, fromUser: m.fromUser)).toList(),
        disease: widget.disease,
        languageCode: languageCode,
        location: location,
      );
      if (!mounted) return;
      setState(() => _messages.add(_Message(answer, fromUser: false)));
    } catch (_) {
      if (!mounted) return;
      setState(() => _messages.add(_Message(l10n.assistantError, fromUser: false)));
    } finally {
      if (mounted) setState(() => _thinking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.assistantTitle)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              itemCount: _messages.length + (_thinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= _messages.length) {
                  return const _Bubble(message: _Message('…', fromUser: false));
                }
                return _Bubble(message: _messages[index]);
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_thinking,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(hintText: l10n.askQuestion),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _thinking ? null : _send,
                    icon: Icon(FeatherIcons.send,
                        color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final _Message message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool user = message.fromUser;
    final Color bg = user ? theme.colorScheme.tertiary : theme.cardColor;
    final Color fg =
        user ? theme.colorScheme.onTertiary : theme.colorScheme.onSurface;

    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(color: theme.colorScheme.onSurface, width: 2),
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyMedium?.copyWith(color: fg),
        ),
      ),
    );
  }
}

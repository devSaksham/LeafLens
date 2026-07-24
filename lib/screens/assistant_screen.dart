import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    final String greeting = widget.disease == null
        ? 'Hi! I\'m the LeafLens assistant. Ask me anything about plant care.'
        : 'I can help with ${widget.disease}. Ask about symptoms, causes, or treatment.';
    _messages.add(_Message(greeting, fromUser: false));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(text, fromUser: true));
      _messages.add(_Message(_reply(text), fromUser: false));
      _controller.clear();
    });
  }

  String _reply(String prompt) {
    final String subject = widget.disease ?? 'your plant';
    return 'For $subject: remove affected leaves, avoid overhead watering, '
        'improve airflow, and apply an appropriate treatment. '
        '(Connect an AI backend to make this a real conversation.)';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _Bubble(message: _messages[index]),
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
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(hintText: 'Ask a question'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    onPressed: _send,
                    icon: Icon(Icons.send, color: theme.colorScheme.onPrimary),
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
    final Color bg =
        user ? theme.colorScheme.tertiary : theme.cardColor;
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

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_spacing.dart';
import '../theme/app_theme.dart';
import 'assistant_screen.dart';
import 'detect_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openCommunity() async {
    final Uri uri = Uri.parse('https://icar.org.in');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LeafLens')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [
          _FeatureCard(
            icon: Icons.eco_outlined,
            title: "Check your plant's health",
            body:
                'Take or select a photo of a plant to detect the disease and get guidance.',
            actionLabel: 'Scan a leaf',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DetectScreen()),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _FeatureCard(
            icon: Icons.groups_outlined,
            title: 'Community panel',
            body:
                'An open forum to discuss ideas about green life and healthy crops.',
            actionLabel: 'Open forum',
            onTap: _openCommunity,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AssistantScreen()),
        ),
        child: const Icon(Icons.chat_bubble_outline),
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
        border: Border.all(color: theme.colorScheme.onSurface, width: 2),
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

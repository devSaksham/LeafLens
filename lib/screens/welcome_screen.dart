import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/auth_service.dart';
import '../l10n/app_localizations.dart';
import '../l10n/locale_controller.dart';
import '../theme/app_spacing.dart';
import '../theme/feather_icons.dart';
import 'home_screen.dart';

class _Leaf {
  final String emoji;
  final double left;
  final double top;
  final double size;
  final double phase;
  const _Leaf(this.emoji, this.left, this.top, this.size, this.phase);
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  StreamSubscription<AuthState>? _authSub;
  bool _signingIn = false;

  static const List<_Leaf> _leaves = [
    _Leaf('🍃', 0.10, 0.14, 36, 0.0),
    _Leaf('🌿', 0.78, 0.18, 44, 1.1),
    _Leaf('🍀', 0.18, 0.60, 30, 2.0),
    _Leaf('🍃', 0.82, 0.66, 34, 3.3),
    _Leaf('🌱', 0.48, 0.08, 28, 4.2),
    _Leaf('🍃', 0.62, 0.82, 32, 5.0),
    _Leaf('🌿', 0.08, 0.82, 30, 5.8),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _authSub = AuthService.instance.onAuthStateChange.listen((state) {
      if (state.event == AuthChangeEvent.signedIn) _goHome();
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _signInWithGoogle() async {
    final AppLocalizations l10n = AppLocalizations.of(context);
    setState(() => _signingIn = true);
    try {
      await AuthService.instance.signInWithGoogle();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.googleSignInFailed)),
        );
      }
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
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
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          for (final leaf in _leaves)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double t = _controller.value * 2 * math.pi + leaf.phase;
                final double dy = math.sin(t) * 14;
                final double dx = math.cos(t) * 6;
                return Positioned(
                  left: size.width * leaf.left + dx,
                  top: size.height * leaf.top + dy,
                  child: Transform.rotate(
                    angle: math.sin(t) * 0.2,
                    child: child,
                  ),
                );
              },
              child: Text(leaf.emoji, style: TextStyle(fontSize: leaf.size)),
            ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🌿', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.welcomeHeadline, style: theme.textTheme.displayMedium),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.welcomeTagline, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: AppSpacing.xl),
                  ElevatedButton(
                    onPressed: _signingIn ? null : _signInWithGoogle,
                    child: Text(
                      _signingIn ? l10n.signingIn : l10n.continueWithGoogle,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: _signingIn ? null : _goHome,
                    child: Text(l10n.continueAsGuest),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: IconButton(
                onPressed: _pickLanguage,
                icon: Icon(FeatherIcons.globe, color: theme.colorScheme.onSurface),
                tooltip: l10n.selectLanguage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

/// Feather icons, bundled locally via `assets/fonts/feather.ttf`.
///
/// Published feather packages subclass [IconData], which is a final class in
/// current Flutter and no longer compiles, so we declare plain [IconData]
/// constants against the bundled "Feather" font family instead.
class FeatherIcons {
  FeatherIcons._();

  static const String _family = 'Feather';

  static const IconData camera = IconData(0xe928, fontFamily: _family);
  static const IconData chevronRight = IconData(0xe930, fontFamily: _family);
  static const IconData globe = IconData(0xe978, fontFamily: _family);
  static const IconData image = IconData(0xe981, fontFamily: _family);
  static const IconData messageCircle = IconData(0xe999, fontFamily: _family);
  static const IconData send = IconData(0xe9cd, fontFamily: _family);
}

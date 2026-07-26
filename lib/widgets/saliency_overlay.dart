import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../ml/saliency_map.dart';

class SaliencyOverlay extends StatelessWidget {
  const SaliencyOverlay({super.key, required this.map});

  final SaliencyMap map;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return CustomPaint(
      painter: _SaliencyPainter(
        map: map,
        low: scheme.tertiary,
        high: scheme.error,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _SaliencyPainter extends CustomPainter {
  const _SaliencyPainter({
    required this.map,
    required this.low,
    required this.high,
  });

  final SaliencyMap map;
  final Color low;
  final Color high;

  static const double _floor = 0.12;
  static const double _peakOpacity = 0.72;
  static const double _blurRatio = 0.6;

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = size.width / map.gridSize;
    final double cellHeight = size.height / map.gridSize;

    canvas.saveLayer(
      Offset.zero & size,
      Paint()
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: cellWidth * _blurRatio,
          sigmaY: cellHeight * _blurRatio,
          tileMode: TileMode.decal,
        ),
    );

    for (int y = 0; y < map.gridSize; y++) {
      for (int x = 0; x < map.gridSize; x++) {
        final double value = map.at(x, y);
        if (value < _floor) continue;
        canvas.drawRect(
          Rect.fromLTWH(x * cellWidth, y * cellHeight, cellWidth, cellHeight),
          Paint()
            ..color = Color.lerp(low, high, value)!
                .withValues(alpha: value * _peakOpacity),
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_SaliencyPainter oldDelegate) =>
      oldDelegate.map != map ||
      oldDelegate.low != low ||
      oldDelegate.high != high;
}

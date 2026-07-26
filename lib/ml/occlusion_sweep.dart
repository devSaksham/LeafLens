import 'dart:math' as math;

import 'saliency_map.dart';

typedef ClassScoreProbe = Future<double> Function();

Future<SaliencyMap?> occlusionSweep({
  required List<List<List<double>>> pixels,
  required int size,
  required int gridSize,
  required double baseline,
  required double level,
  required ClassScoreProbe probe,
}) async {
  if (gridSize <= 0 || size <= 0 || baseline <= 0) return null;

  final int cell = (size / gridSize).ceil();
  final List<double> drops = List<double>.filled(gridSize * gridSize, 0);
  final List<double> saved = [];

  for (int gy = 0; gy < gridSize; gy++) {
    for (int gx = 0; gx < gridSize; gx++) {
      final int x0 = gx * cell;
      final int y0 = gy * cell;
      if (x0 >= size || y0 >= size) continue;
      final int x1 = math.min(x0 + cell, size);
      final int y1 = math.min(y0 + cell, size);

      saved.clear();
      for (int y = y0; y < y1; y++) {
        final List<List<double>> row = pixels[y];
        for (int x = x0; x < x1; x++) {
          final List<double> pixel = row[x];
          saved.addAll(pixel);
          pixel[0] = level;
          pixel[1] = level;
          pixel[2] = level;
        }
      }

      final double score = await probe();
      drops[gy * gridSize + gx] = math.max(0.0, baseline - score);

      int i = 0;
      for (int y = y0; y < y1; y++) {
        final List<List<double>> row = pixels[y];
        for (int x = x0; x < x1; x++) {
          final List<double> pixel = row[x];
          pixel[0] = saved[i++];
          pixel[1] = saved[i++];
          pixel[2] = saved[i++];
        }
      }
    }
    await Future<void>.delayed(Duration.zero);
  }

  return SaliencyMap.fromDrops(gridSize, drops);
}

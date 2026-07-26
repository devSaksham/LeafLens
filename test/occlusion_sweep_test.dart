import 'package:flutter_test/flutter_test.dart';
import 'package:leaflens/ml/occlusion_sweep.dart';
import 'package:leaflens/ml/saliency_map.dart';

const int _size = 200;
const int _grid = 8;
const double _level = 0.5;

List<List<List<double>>> _syntheticPixels() {
  return List.generate(
    _size,
    (y) => List.generate(
      _size,
      (x) => [x / _size, y / _size, ((x + y) % 255) / 255.0],
    ),
  );
}

List<List<List<double>>> _deepCopy(List<List<List<double>>> src) {
  return src
      .map((row) => row.map((px) => List<double>.from(px)).toList())
      .toList();
}

bool _regionIsOccluded(
  List<List<List<double>>> pixels,
  int x0,
  int y0,
  int x1,
  int y1,
) {
  for (int y = y0; y < y1; y++) {
    for (int x = x0; x < x1; x++) {
      for (int c = 0; c < 3; c++) {
        if (pixels[y][x][c] != _level) return false;
      }
    }
  }
  return true;
}

void main() {
  group('occlusionSweep', () {
    test('restores every pixel it occludes', () async {
      final pixels = _syntheticPixels();
      final original = _deepCopy(pixels);

      await occlusionSweep(
        pixels: pixels,
        size: _size,
        gridSize: _grid,
        baseline: 0.9,
        level: _level,
        probe: () async => 0.5,
      );

      for (int y = 0; y < _size; y++) {
        for (int x = 0; x < _size; x++) {
          expect(pixels[y][x], original[y][x],
              reason: 'pixel ($x,$y) was not restored');
        }
      }
    });

    test('probes each cell exactly once', () async {
      int probes = 0;
      await occlusionSweep(
        pixels: _syntheticPixels(),
        size: _size,
        gridSize: _grid,
        baseline: 0.9,
        level: _level,
        probe: () async {
          probes++;
          return 0.5;
        },
      );
      expect(probes, _grid * _grid);
    });

    test('peaks on the region the synthetic model depends on', () async {
      final pixels = _syntheticPixels();
      const int cell = _size ~/ _grid;
      const int hotGx = 5;
      const int hotGy = 2;
      const int hx0 = hotGx * cell;
      const int hy0 = hotGy * cell;

      final SaliencyMap? map = await occlusionSweep(
        pixels: pixels,
        size: _size,
        gridSize: _grid,
        baseline: 0.9,
        level: _level,
        probe: () async {
          final bool blinded =
              _regionIsOccluded(pixels, hx0, hy0, hx0 + cell, hy0 + cell);
          return blinded ? 0.1 : 0.9;
        },
      );

      expect(map, isNotNull);
      expect(map!.at(hotGx, hotGy), 1.0);

      for (int gy = 0; gy < _grid; gy++) {
        for (int gx = 0; gx < _grid; gx++) {
          if (gx == hotGx && gy == hotGy) continue;
          expect(map.at(gx, gy), 0.0,
              reason: 'cell ($gx,$gy) should not be salient');
        }
      }
    });

    test('returns null when the model is indifferent to occlusion', () async {
      final SaliencyMap? map = await occlusionSweep(
        pixels: _syntheticPixels(),
        size: _size,
        gridSize: _grid,
        baseline: 0.9,
        level: _level,
        probe: () async => 0.9,
      );
      expect(map, isNull);
    });

    test('covers the full image when size is not divisible by the grid',
        () async {
      const int oddSize = 10;
      const int oddGrid = 3;
      final pixels = List.generate(
        oddSize,
        (y) => List.generate(oddSize, (x) => [0.1, 0.2, 0.3]),
      );
      final Set<String> touched = {};

      await occlusionSweep(
        pixels: pixels,
        size: oddSize,
        gridSize: oddGrid,
        baseline: 0.9,
        level: _level,
        probe: () async {
          for (int y = 0; y < oddSize; y++) {
            for (int x = 0; x < oddSize; x++) {
              if (pixels[y][x][0] == _level) touched.add('$x,$y');
            }
          }
          return 0.5;
        },
      );

      expect(touched.length, oddSize * oddSize);
    });
  });
}

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import 'diagnosis.dart';
import 'occlusion_sweep.dart';
import 'saliency_map.dart';

class PlantDiseaseClassifier {
  PlantDiseaseClassifier._();
  static final PlantDiseaseClassifier instance = PlantDiseaseClassifier._();

  static const String _modelAsset = 'assets/model/model.tflite';
  static const String _labelsAsset = 'assets/model/labelmap.txt';
  static const int _inputSize = 200;
  static const double _threshold = 0.4;
  static const int _saliencyGrid = 8;
  static const double _occlusionLevel = 0.5;

  Interpreter? _interpreter;
  List<String> _labels = const [];

  bool get isReady => _interpreter != null;

  Future<void> load() async {
    if (_interpreter != null) return;
    _interpreter = await Interpreter.fromAsset(_modelAsset);
    final String raw = await rootBundle.loadString(_labelsAsset);
    _labels = raw.split('\n').map((line) => line.trimRight()).toList();
  }

  Future<Diagnosis?> classify(Uint8List imageBytes) async {
    await load();
    final img.Image? decoded = img.decodeImage(imageBytes);
    if (decoded == null) return null;

    final img.Image resized =
        img.copyResize(decoded, width: _inputSize, height: _inputSize);
    final input = _toInputTensor(resized);
    final output = [List<double>.filled(_labels.length, 0)];

    _interpreter!.run(input, output);
    return _topDiagnosis(output.first);
  }

  Future<SaliencyMap?> saliencyFor(
    Uint8List imageBytes,
    Diagnosis diagnosis, {
    int gridSize = _saliencyGrid,
  }) async {
    await load();
    final int labelIndex = _labels.indexOf(diagnosis.rawLabel);
    if (labelIndex == -1) return null;

    final img.Image? decoded = img.decodeImage(imageBytes);
    if (decoded == null) return null;

    final img.Image resized =
        img.copyResize(decoded, width: _inputSize, height: _inputSize);
    final input = _toInputTensor(resized);
    final List<List<List<double>>> rows = input.first;
    final output = [List<double>.filled(_labels.length, 0)];

    _interpreter!.run(input, output);
    final double baseline = output.first[labelIndex];
    if (baseline <= 0) return null;

    return occlusionSweep(
      pixels: rows,
      size: _inputSize,
      gridSize: gridSize,
      baseline: baseline,
      level: _occlusionLevel,
      probe: () async {
        _interpreter!.run(input, output);
        return output.first[labelIndex];
      },
    );
  }

  List<List<List<List<double>>>> _toInputTensor(img.Image image) {
    return [
      List.generate(_inputSize, (y) {
        return List.generate(_inputSize, (x) {
          final img.Pixel pixel = image.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        });
      }),
    ];
  }

  Diagnosis? _topDiagnosis(List<double> scores) {
    int bestIndex = -1;
    double bestScore = 0;
    for (int i = 0; i < scores.length && i < _labels.length; i++) {
      if (scores[i] > bestScore) {
        bestScore = scores[i];
        bestIndex = i;
      }
    }
    if (bestIndex == -1 || bestScore < _threshold) return null;
    return Diagnosis.fromLabel(_labels[bestIndex], bestScore);
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}

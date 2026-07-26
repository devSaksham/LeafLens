import 'dart:convert';

import 'package:flutter/services.dart';

import 'treatment.dart';

class TreatmentRepository {
  TreatmentRepository._();
  static final TreatmentRepository instance = TreatmentRepository._();

  static const String _asset = 'assets/treatments.json';
  Map<String, dynamic>? _bundled;

  Future<Map<String, dynamic>> _loadBundled() async {
    if (_bundled != null) return _bundled!;
    final String raw = await rootBundle.loadString(_asset);
    _bundled = jsonDecode(raw) as Map<String, dynamic>;
    return _bundled!;
  }

  /// Looks up treatment for the given raw model label in the bundled
  /// knowledge base. Loaded once, cached, and works entirely offline.
  Future<Treatment?> forLabel(String label) async {
    final Map<String, dynamic> bundled = await _loadBundled();
    final entry = bundled[label];
    if (entry is Map<String, dynamic>) return Treatment.fromJson(entry);
    return null;
  }
}

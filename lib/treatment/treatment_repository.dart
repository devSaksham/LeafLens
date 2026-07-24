import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// Looks up treatment for the given raw model label. Tries the Supabase
  /// `treatments` table first (so cures can be updated without an app release)
  /// and falls back to the bundled JSON when the table is absent or offline.
  Future<Treatment?> forLabel(String label) async {
    try {
      final data = await Supabase.instance.client
          .from('treatments')
          .select()
          .eq('label', label)
          .maybeSingle();
      if (data != null) return Treatment.fromJson(data);
    } catch (_) {
      // Table missing / offline / RLS — fall through to bundled data.
    }

    final Map<String, dynamic> bundled = await _loadBundled();
    final entry = bundled[label];
    if (entry is Map<String, dynamic>) return Treatment.fromJson(entry);
    return null;
  }
}

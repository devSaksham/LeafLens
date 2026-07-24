import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ml/diagnosis.dart';
import 'scan_session.dart';

class SessionStore {
  SessionStore._();
  static final SessionStore instance = SessionStore._();

  static const String _key = 'scan_sessions';

  Future<Directory> _imagesDir() async {
    final Directory base = await getApplicationDocumentsDirectory();
    final Directory dir = Directory('${base.path}/sessions');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<List<ScanSession>> all() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> raw = prefs.getStringList(_key) ?? const [];
    final List<ScanSession> sessions = raw
        .map((s) => ScanSession.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sessions;
  }

  Future<ScanSession> add({
    required Uint8List imageBytes,
    required Diagnosis diagnosis,
  }) async {
    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final Directory dir = await _imagesDir();
    final File file = File('${dir.path}/$id.jpg');
    await file.writeAsBytes(imageBytes);

    final ScanSession session = ScanSession(
      id: id,
      imagePath: file.path,
      rawLabel: diagnosis.rawLabel,
      displayName: diagnosis.displayName,
      confidence: diagnosis.confidence,
      isHealthy: diagnosis.isHealthy,
      createdAt: DateTime.now(),
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_key) ?? <String>[];
    list.add(jsonEncode(session.toJson()));
    await prefs.setStringList(_key, list);
    return session;
  }

  Future<void> delete(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList(_key) ?? <String>[];
    list.removeWhere((s) {
      final map = jsonDecode(s) as Map<String, dynamic>;
      if (map['id'] == id) {
        final f = File(map['imagePath'] as String);
        if (f.existsSync()) f.deleteSync();
        return true;
      }
      return false;
    });
    await prefs.setStringList(_key, list);
  }
}

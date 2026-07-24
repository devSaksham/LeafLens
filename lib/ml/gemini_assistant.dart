import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/gemini_config.dart';

typedef ChatTurn = ({String text, bool fromUser});

class GeminiAssistant {
  GeminiAssistant._();
  static final GeminiAssistant instance = GeminiAssistant._();

  Future<String> reply({
    required List<ChatTurn> history,
    String? disease,
    String? languageCode,
    String? location,
  }) async {
    final String key = GeminiConfig.randomKey;
    final Uri uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '${GeminiConfig.model}:generateContent?key=$key',
    );

    final StringBuffer sb = StringBuffer(
      disease == null
          ? 'You are LeafLens, a friendly plant-care assistant. Answer briefly '
              'with practical, safe gardening advice.'
          : 'You are LeafLens, a plant-care assistant. The user\'s plant was '
              'diagnosed with "$disease". Give concise, practical treatment and '
              'prevention steps. Remind them this is guidance, not a substitute '
              'for a professional agronomist.',
    );
    if (location != null && location.isNotEmpty) {
      sb.write(' The user is located in $location. Tailor advice to that '
          'region\'s climate, growing seasons, and locally available products.');
    }
    if (languageCode == 'hi') {
      sb.write(' Respond in Hindi using Devanagari script.');
    }
    final String system = sb.toString();

    final List<ChatTurn> trimmed = [...history];
    while (trimmed.isNotEmpty && !trimmed.first.fromUser) {
      trimmed.removeAt(0);
    }

    final contents = trimmed
        .map((turn) => {
              'role': turn.fromUser ? 'user' : 'model',
              'parts': [
                {'text': turn.text}
              ],
            })
        .toList();

    final http.Response resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'system_instruction': {
          'parts': [
            {'text': system}
          ]
        },
        'contents': contents,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception('Gemini request failed (${resp.statusCode}).');
    }

    final Map<String, dynamic> data =
        jsonDecode(resp.body) as Map<String, dynamic>;
    final String? text = data['candidates']?[0]?['content']?['parts']?[0]?['text']
        as String?;
    return text?.trim() ?? 'Sorry, I could not answer that.';
  }

  /// Second-pass query used after a stored/curated response is shown: asks for
  /// a short region-specific nuance for the given disease.
  Future<String> locationNuance({
    required String disease,
    required String baseAdvice,
    String? languageCode,
    String? location,
  }) {
    final String prompt =
        'A plant has "$disease". General guidance already shown to the user:\n'
        '$baseAdvice\n\nAdd a short location-specific note (2-3 sentences) with '
        'regional nuance: local season/timing and locally available products. '
        'Do not repeat the general guidance.';
    return reply(
      history: [(text: prompt, fromUser: true)],
      disease: disease,
      languageCode: languageCode,
      location: location,
    );
  }
}

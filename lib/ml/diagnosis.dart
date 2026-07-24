class Diagnosis {
  final String rawLabel;
  final String displayName;
  final double confidence;
  final bool isHealthy;
  final bool isBackground;

  const Diagnosis({
    required this.rawLabel,
    required this.displayName,
    required this.confidence,
    required this.isHealthy,
    required this.isBackground,
  });

  String get confidenceLabel => '${(confidence * 100).toStringAsFixed(1)}%';

  factory Diagnosis.fromLabel(String label, double confidence) {
    final bool isBackground = label.trim() == 'background';
    final bool isHealthy = label.contains('healthy');
    return Diagnosis(
      rawLabel: label,
      displayName: _prettifyLabel(label),
      confidence: confidence,
      isHealthy: isHealthy,
      isBackground: isBackground,
    );
  }

  static String _prettifyLabel(String label) {
    final int firstSpace = label.indexOf(' ');
    if (firstSpace == -1) return _titleCase(label);

    final String rest = label.substring(firstSpace + 1);
    final int restSpace = rest.indexOf(' ');
    final String cropWord = label.substring(0, firstSpace);
    final String restFirstWord = restSpace == -1 ? rest : rest.substring(0, restSpace);

    final String chosen = cropWord == restFirstWord ? rest : label;
    return _titleCase(chosen);
  }

  static String _titleCase(String value) => value
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

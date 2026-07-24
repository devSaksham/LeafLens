class ScanSession {
  final String id;
  final String imagePath;
  final String rawLabel;
  final String displayName;
  final double confidence;
  final bool isHealthy;
  final DateTime createdAt;

  const ScanSession({
    required this.id,
    required this.imagePath,
    required this.rawLabel,
    required this.displayName,
    required this.confidence,
    required this.isHealthy,
    required this.createdAt,
  });

  String get confidenceLabel => '${(confidence * 100).toStringAsFixed(1)}%';

  Map<String, dynamic> toJson() => {
        'id': id,
        'imagePath': imagePath,
        'rawLabel': rawLabel,
        'displayName': displayName,
        'confidence': confidence,
        'isHealthy': isHealthy,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ScanSession.fromJson(Map<String, dynamic> json) => ScanSession(
        id: json['id'] as String,
        imagePath: json['imagePath'] as String,
        rawLabel: json['rawLabel'] as String,
        displayName: json['displayName'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        isHealthy: json['isHealthy'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

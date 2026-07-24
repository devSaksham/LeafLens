class Treatment {
  final String cause;
  final String severity;
  final String summary;
  final List<String> doNow;
  final List<String> organic;
  final List<String> chemical;
  final List<String> prevent;

  const Treatment({
    required this.cause,
    required this.severity,
    required this.summary,
    required this.doNow,
    required this.organic,
    required this.chemical,
    required this.prevent,
  });

  bool get isHealthy => severity == 'healthy';

  static List<String> _stringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  factory Treatment.fromJson(Map<String, dynamic> json) => Treatment(
        cause: (json['cause'] ?? '').toString(),
        severity: (json['severity'] ?? '').toString(),
        summary: (json['summary'] ?? '').toString(),
        doNow: _stringList(json['do_now']),
        organic: _stringList(json['organic']),
        chemical: _stringList(json['chemical']),
        prevent: _stringList(json['prevent']),
      );
}

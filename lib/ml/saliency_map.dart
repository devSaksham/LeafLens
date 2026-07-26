class SaliencyMap {
  const SaliencyMap({required this.gridSize, required this.values});

  final int gridSize;
  final List<double> values;

  double at(int x, int y) => values[y * gridSize + x];

  static SaliencyMap? fromDrops(int gridSize, List<double> drops) {
    double peak = 0;
    for (final double drop in drops) {
      if (drop > peak) peak = drop;
    }
    if (peak <= 0) return null;
    return SaliencyMap(
      gridSize: gridSize,
      values: List<double>.generate(
        drops.length,
        (i) => (drops[i] / peak).clamp(0.0, 1.0),
        growable: false,
      ),
    );
  }
}

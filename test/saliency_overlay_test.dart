import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leaflens/ml/saliency_map.dart';
import 'package:leaflens/theme/app_theme.dart';
import 'package:leaflens/widgets/saliency_overlay.dart';

Widget _host(SaliencyMap map, ThemeData theme) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 240,
          height: 240,
          child: SaliencyOverlay(map: map),
        ),
      ),
    ),
  );
}

void main() {
  final SaliencyMap map = SaliencyMap(
    gridSize: 8,
    values: List<double>.generate(64, (i) => (i % 8) / 7.0),
  );

  testWidgets('paints without error in light theme', (tester) async {
    await tester.pumpWidget(_host(map, AppTheme.light));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(SaliencyOverlay), findsOneWidget);
  });

  testWidgets('paints without error in dark theme', (tester) async {
    await tester.pumpWidget(_host(map, AppTheme.dark));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('paints an all-zero map without error', (tester) async {
    await tester.pumpWidget(
      _host(
        SaliencyMap(gridSize: 8, values: List<double>.filled(64, 0)),
        AppTheme.light,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

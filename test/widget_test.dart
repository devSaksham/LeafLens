import 'package:flutter_test/flutter_test.dart';

import 'package:leaflens/main.dart';

void main() {
  testWidgets('Home renders the feature cards', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text("Check your plant's health"), findsOneWidget);
    expect(find.text('SCAN A LEAF'), findsOneWidget);
  });
}

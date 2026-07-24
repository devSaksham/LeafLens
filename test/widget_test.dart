import 'package:flutter_test/flutter_test.dart';

import 'package:leaflens/main.dart';

void main() {
  testWidgets('Welcome screen shows the hero line and login CTA',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Heal your plants,\none leaf at a time.'), findsOneWidget);
    expect(find.text('CONTINUE WITH GOOGLE'), findsOneWidget);
  });
}

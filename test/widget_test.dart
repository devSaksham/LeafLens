import 'package:flutter_test/flutter_test.dart';

import 'package:leaflens/main.dart';

void main() {
  testWidgets('boots straight into the home screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('LeafLens'), findsOneWidget);
    expect(find.text("Check your plant's health"), findsOneWidget);
    expect(find.text('SCAN A LEAF'), findsOneWidget);
  });

  testWidgets('no sign-in or assistant entry points remain', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('CONTINUE WITH GOOGLE'), findsNothing);
    expect(find.text('ASK THE ASSISTANT'), findsNothing);
  });
}

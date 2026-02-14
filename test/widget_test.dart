// Basic Flutter widget test for PumpShield Bharat

import 'package:flutter_test/flutter_test.dart';
import 'package:pump_shield_bharat/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PumpShieldApp());

    // Verify that the app starts
    expect(find.text('PumpShield Bharat'), findsAny);
  });
}

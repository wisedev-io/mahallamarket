import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:mahallamarket/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('launches and renders first frame', (tester) async {
    // Start the app
    app.main();
    await tester.pumpAndSettle();

    // Basic sanity: app renders something Material-ish
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

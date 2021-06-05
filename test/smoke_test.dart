import 'package:flutter/material.dart';
import 'package:flutter_integration_test_examples/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();

  testWidgets('Smoke test', (WidgetTester tester) async {
    final Finder loginBtn = find.byKey(ValueKey('loginBtn'));
    final Finder userText = find.byKey(ValueKey('userText'));
    final Finder passText = find.byKey(ValueKey('passText'));

    // Run app
    await tester.pumpWidget(MyApp());
    // Enter text
    await tester.enterText(userText, 'shawn@gskinner.com');
    await tester.enterText(passText, 'password');
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    // Tap btn
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    // Check internal state
    MyAppState state = tester.state(find.byType(MyApp));
    expect(state.isLoggedInState.value, true);
    // Show a dialog
    showDialog(context: state.navKey.currentContext!, builder: (_) => Dialog(child: Placeholder()));
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    // Close dialog
    state.navKey.currentState!.pop();
    await tester.pumpAndSettle();
    await Future.delayed(Duration(seconds: 2));
    // Enumarate all states that exist in the app
    tester.allStates.forEach((s) => print(s));
  });
}
//flutter drive --driver=test_driver/main.dart --target=integration_test/smoke_test.dart -d windows

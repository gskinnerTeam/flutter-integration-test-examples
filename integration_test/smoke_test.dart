import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_integration_test_examples/main.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();

  testWidgets('Smoke test', (WidgetTester tester) async {
    // Run app
    await tester.pumpWidget(MyApp()); // Create main app
    await tester.pumpAndSettle(); // Finish animations and scheduled microtasks
    await tester.pump(Duration(seconds: 2)); // Wait some time

    // Enumerate all states that exist in the app just to show we can
    print("All states: ");
    tester.allStates.forEach((s) => print(s));

    // Find textFields
    final Finder userText = find.byKey(ValueKey('userText'));
    final Finder passText = find.byKey(ValueKey('passText'));

    // Ensure there is a login and password field on the initial page
    expect(userText, findsOneWidget);
    expect(passText, findsOneWidget);

    // Enter text
    await tester.enterText(userText, 'test@test.com');
    await tester.enterText(passText, 'password');
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 2));

    // Tap btn
    final Finder loginBtn = find.byKey(ValueKey('loginBtn'));
    await tester.tap(loginBtn, warnIfMissed: true);
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 2));

    // Check internal state
    MyAppState state = tester.state(find.byType(MyApp));
    expect(state.isLoggedInState.value, true);

    // Get navigator and show a dialog
    NavigatorState navigator = state.navKey.currentState!;
    print(navigator.context);
    showDialog(
      context: navigator.context,
      builder: (c) => _SomeDialog(),
    );
    await tester.pumpAndSettle();
    await tester.pump(Duration(seconds: 1));

    // Close dialog, method 1
    navigator.pop();
    await tester.pumpAndSettle();

    // Verify dialog was closed
    expect(find.byWidget(_SomeDialog()), findsNothing);

    // Show dialog again
    showDialog(context: navigator.context, builder: (c) => _SomeDialog());
    await tester.pumpAndSettle();

    // Close dialog, method 2
    await tester.tap(find.byKey(ValueKey('okBtn')));
    await tester.pumpAndSettle();

    // Verify dialog was closed
    expect(find.byType(_SomeDialog), findsNothing);

    // Expect all anims have finished
    expect(SchedulerBinding.instance!.transientCallbackCount, 0);

    // Wait a bit more...
    await tester.pump(Duration(seconds: 2));
  });
}

class _SomeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        OutlinedButton(
          key: ValueKey("okBtn"),
          onPressed: () => Navigator.pop(context),
          child: Text("Ok"),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // Simulate some state within our app, that the test cares about
  ValueNotifier<bool> isLoggedInState = ValueNotifier(false);

  // Create a key for the navigator, so our tests can control dialogs
  GlobalKey<NavigatorState> navKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      home: Material(
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoggedInState,
          builder: (_, isLoggedIn, __) {
            if (isLoggedIn == false) {
              return Column(
                children: [
                  TextField(key: ValueKey("userText")),
                  TextField(key: ValueKey("passText"), obscureText: true),
                  OutlinedButton(
                    key: ValueKey("loginBtn"),
                    child: const Text("Login"),
                    onPressed: () => isLoggedInState.value = true,
                  ),
                ],
              );
            } else {
              return const Center(child: Text("Login Success!"));
            }
          },
        ),
      ),
    );
  }
}

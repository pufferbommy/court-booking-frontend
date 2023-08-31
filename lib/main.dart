import 'package:flutter/material.dart';

import './pages/login.dart';
import './pages/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Court Booking',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => HomePage(
              arguments: ModalRoute.of(context)!.settings.arguments,
            ),
      },
    );
  }
}

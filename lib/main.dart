import 'package:employee_app/pages/form_page.dart';
import 'package:employee_app/pages/home_page.dart';
import 'package:employee_app/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load();
  String user = await _getUser();
  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final String user;

  const MyApp({super.key, required this.user});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
        child: MaterialApp(
        initialRoute: user != '' ? '/home' : '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/home': (context) => HomePage(),
          '/form': (context) => FormPage(),
        },
      )
    );
  }
}

Future<String> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? '';
  }
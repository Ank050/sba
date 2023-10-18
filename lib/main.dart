import 'package:flutter/material.dart';
import "package:flutter/services.dart";

import './screens/home_screen.dart';
import './screens/about.dart';
import 'screens/relay_screen.dart';
import './screens/setup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: "HOME",
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        primarySwatch: Colors.blue, // Use the blue swatch directly

        primaryColor: const Color.fromARGB(255, 0, 0, 0),

        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Use the blue swatch directly
        ),
        fontFamily: 'Ubuntu',
        primaryTextTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      routes: {
        About.route: (ctx) => const About(),
        Setup.route: (ctx) => const Setup(),
        // ControlItem.route: (ctx) => ControlItem()
      },
    );
  }
}

const Map<int, Color> color = {
  50: Color.fromRGBO(255, 255, 255, .1),
  100: Color.fromRGBO(255, 255, 255, .2),
  200: Color.fromRGBO(255, 255, 255, .3),
  300: Color.fromRGBO(255, 255, 255, .4),
  400: Color.fromRGBO(255, 255, 255, .5),
  500: Color.fromRGBO(255, 255, 255, .6),
  600: Color.fromRGBO(255, 255, 255, .7),
  700: Color.fromRGBO(255, 255, 255, .8),
  800: Color.fromRGBO(255, 255, 255, .9),
  900: Color.fromRGBO(255, 255, 255, 1),
};

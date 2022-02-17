import 'package:flutter/material.dart';
import 'package:hello_world/home_controller.dart';

import 'home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MaterialApp(
      theme: tema.copyWith(
          colorScheme: tema.colorScheme.copyWith(
        primary: const Color.fromARGB(255, 255, 96, 90),
        //secondary: Color.fromARGB(100, 255, 176, 110)
      )),
      home: HomeController(
        child: const HomePage(),
      ),
    );
  }
}

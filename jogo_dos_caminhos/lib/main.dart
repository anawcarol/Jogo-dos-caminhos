// lib/main.dart
import 'package:flutter/material.dart';
import 'components/home_screen.dart';
import 'components/SoloGame/win_game.dart';
import 'components/SoloGame/kill_game.dart';
import 'components/TwoGame/win_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),  // Chamando a HomeScreen do arquivo home_screen.dart dentro de components
    );
  }
}

// lib/main.dart
import 'package:flutter/material.dart';
import 'components/home_screen.dart';
import 'components/choose_screen.dart';
import 'components/rules_bot.dart';
import 'components/solo_game.dart';
  // Ajuste a importação para refletir a pasta "components"

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocationSelectionScreen(),  // Chamando a HomeScreen do arquivo home_screen.dart dentro de components
    );
  }
}

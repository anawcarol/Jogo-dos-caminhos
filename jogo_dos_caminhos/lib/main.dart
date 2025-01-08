// lib/main.dart
import 'package:flutter/material.dart';
import 'components/home_screen.dart';  // Ajuste a importação para refletir a pasta "components"

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),  // Chamando a HomeScreen do arquivo home_screen.dart dentro de components
    );
  }
}

// lib/main.dart
import 'package:flutter/material.dart';
import 'components/home_screen.dart';
import 'package:flutter/services.dart';



void main() {
  // Configurações para tela cheia:
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky); // Modo imersivo
  SystemChrome.setPreferredOrientations([ // Trava a orientação (opcional)
    DeviceOrientation.landscapeLeft,  // Para jogos horizontais
    DeviceOrientation.landscapeRight,
    // DeviceOrientation.portraitUp,  // Use para jogos verticais
  ]);
  
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

// lib/main.dart
import 'package:flutter/material.dart';
import 'components/home_screen.dart';
import 'components/choose_screen.dart';
import 'components/rules_bot.dart';
import 'components/solo_game.dart';
import 'components/info_screen.dart';
import 'components/game_screen.dart';
import 'components/win_game.dart';
import 'components/kill_game.dart';
import 'components/rules_pvp.dart';
import 'components/rules_pvp_plus.dart';
import 'components/game_screen_dois.dart';
import 'components/solo_game.dart';
import 'components/two_game.dart';
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
      home: HomeScreen(),  // Chamando a HomeScreen do arquivo home_screen.dart dentro de components
    );
  }
}

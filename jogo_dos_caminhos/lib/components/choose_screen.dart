import 'package:flutter/material.dart';
import 'home_screen.dart';

class GameModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose the Game Mode',
                style: TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para iniciar o modo jogador vs jogador
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    Text(' vs '),
                    Icon(Icons.person),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Lógica para iniciar o modo jogador vs máquina
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    Text(' vs '),
                    Icon(Icons.smart_toy),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
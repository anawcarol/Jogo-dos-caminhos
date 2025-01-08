// lib/components/home_screen.dart
import 'package:flutter/material.dart';

class ChooseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centraliza verticalmente
            crossAxisAlignment: CrossAxisAlignment.center,  // Centraliza horizontalmente
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  GradientBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3088BE), // Cor inicial
            Color(0xFF163F58), // Cor final
          ],
          stops: [0.3, 1.0], // Define a posição das cores no degradê (30% e 100%)
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}



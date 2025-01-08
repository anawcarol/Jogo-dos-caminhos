// lib/components/home_screen.dart
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: PlayButton(
            onPressed: () {
              // Ação quando o botão for pressionado
              print("Play Button Pressed");
            },
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
          colors: [Color(0xFF3088BE), Color(0xFF163F58)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}

class PlayButton extends StatelessWidget {
  final VoidCallback onPressed;

  PlayButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(), backgroundColor: Colors.transparent,
        padding: EdgeInsets.all(20),
        shadowColor: Colors.transparent,
      ),
      child: Icon(
        Icons.play_arrow,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}

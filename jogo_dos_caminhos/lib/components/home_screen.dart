// lib/components/home_screen.dart
import 'package:flutter/material.dart';
import 'choose_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centraliza verticalmente
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centraliza horizontalmente
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.black
                        .withOpacity(0.1), // Cor do ícone e opacidade
                    size: 300, // Tamanho do ícone
                  ),
                  PlayText(), // Exibindo o texto "Jogo dos Caminhos"
                ],
              ),
              SizedBox(height: 20), // Espaço entre o texto e o botão
              PlayButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChooseScreen()));
                },
              ),
            ],
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
          stops: [
            0.3,
            1.0
          ], // Define a posição das cores no degradê (30% e 100%)
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
        side: BorderSide(
            color: Color(0xFFF5B51C),
            width: 3), // Borda circular com cor F5B51C
      ),
      child: Icon(
        Icons.play_arrow,
        color: Color(0xFFF5B51C), // Cor do ícone igual ao texto
        size: 50,
      ),
    );
  }
}

class PlayText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Jogo\n dos\n Caminhos',
      textAlign: TextAlign.center, // Alinhando o texto no centro
      style: TextStyle(
        fontFamily: 'Aclonica', // Usando a fonte Aclonica
        fontSize: 50,
        color: Color(0xFFF5B51C), // Cor do texto F5B51C
      ),
    );
  }
}

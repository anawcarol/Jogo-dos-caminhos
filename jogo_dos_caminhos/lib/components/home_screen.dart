import 'package:flutter/material.dart';
import 'choose_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.black.withOpacity(0.1),
                    size: screenWidth * 0.7, // Proporção dinâmica
                  ),
                  const PlayText(),
                ],
              ),
              SizedBox(height: screenHeight * 0.02), // Espaçamento proporcional
              PlayButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameModeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // Botão de informação no canto superior direito com fundo redondo
      floatingActionButton: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: ElevatedButton(
          onPressed: () {
            // Lógica para exibir informações
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: const Color(0xFF3088BE), // Cor do fundo
            padding: EdgeInsets.all(screenWidth * 0), // Ajuste o tamanho do botão
            shadowColor: Colors.transparent,
          ),
          child: Icon(
            Icons.info_outline,
            size: screenWidth * 0.1, // Tamanho dinâmico do ícone
            color: const Color(0xFFF5B51C),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop, // Posicionamento no topo direito
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF163F58),
            Color(0xFF3088BE),
          ],
          stops: [0.3, 1.0],
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

  const PlayButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Color(0xFF3088BE),
        padding: EdgeInsets.all(screenWidth * 0.08), // Dinâmico
        shadowColor: Colors.transparent,
        side: const BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        Icons.play_arrow,
        color: const Color(0xFFF5B51C),
        size: screenWidth * 0.15, // Dinâmico
      ),
    );
  }
}

class PlayText extends StatelessWidget {
  const PlayText({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Text(
      'Jogo\n dos\n Caminhos',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Aclonica',
        fontSize: screenWidth * 0.1, // Dinâmico
        color: const Color(0xFFF5B51C),
      ),
    );
  }
}

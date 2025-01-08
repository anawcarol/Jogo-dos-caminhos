import 'package:flutter/material.dart';
import 'home_screen.dart';

class GameModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04), // 4% da largura da tela
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para voltar
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Color(0xFF3088BE),
                    padding: EdgeInsets.all(screenWidth * 0.05), // 5% da largura
                    shadowColor: Colors.transparent,
                    side: BorderSide(
                      color: Color(0xFFF5B51C),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_outlined,
                    size: screenWidth * 0.07, // Ícone proporcional
                    color: Color(0xFFF5B51C),
                  ),
                ),
              ),
            ),
            Positioned(
              top: screenHeight * 0.15, // 15% da altura da tela
              left: screenWidth * 0.1, // 10% da largura da tela
              right: screenWidth * 0.1, // 10% da largura da tela
              child: Text(
                'Escolha o modo de jogar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.08, // 8% da largura da tela
                  fontFamily: 'Aclonica',
                  color: Color(0xFFF5B51C),
                ),
              ),
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Alinha na parte inferior
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para iniciar o modo jogador vs jogador
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02, // 2% da altura
                        horizontal: screenWidth * 0.1, // 10% da largura
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.02), // Espaçamento entre os ícones
                        Text(
                          'vs',
                          style: TextStyle(fontSize: screenWidth * 0.05),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Icon(Icons.person, size: screenWidth * 0.06),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02), // Espaçamento entre os botões
                  ElevatedButton(
                    onPressed: () {
                      // Lógica para iniciar o modo jogador vs máquina
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                        horizontal: screenWidth * 0.1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person, size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          'vs',
                          style: TextStyle(fontSize: screenWidth * 0.05),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Icon(Icons.smart_toy, size: screenWidth * 0.06),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05), // Espaçamento da base
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

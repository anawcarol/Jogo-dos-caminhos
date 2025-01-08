import 'package:flutter/material.dart';
import 'home_screen.dart';

class GameModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Botão de voltar no topo
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // 4% da largura da tela
              child: Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
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

            // Texto centralizado
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
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

            // Botão Jogador vs Jogador
            ElevatedButton(
              onPressed: () {
                // Lógica para iniciar o modo jogador vs jogador
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B51C),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02, // 2% da altura
                  horizontal: screenWidth * 0.1, // 10% da largura
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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

            // Botão Jogador vs Máquina
            ElevatedButton(
              onPressed: () {
                // Lógica para iniciar o modo jogador vs máquina
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF5B51C),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.02,
                  horizontal: screenWidth * 0.1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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

            Spacer(), // Adiciona espaço no final para centralizar melhor
          ],
        ),
      ),
    );
  }
}

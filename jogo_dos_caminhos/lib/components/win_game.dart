import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'info_screen.dart';

class WinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Linha para os botões de Info e Volume no topo
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), // 4% da largura da tela
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircularButton(
                    icon: Icons.info_outline,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameInfoScreen()),
                      );
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05), // Espaço entre os botões
                  _buildCircularButton(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {
                      // Lógica para som
                    },
                  ),
                ],
              ),
            ),

            // Reduzi o espaço antes do título "Vitória!!!"
            SizedBox(height: screenHeight * 0.05),

            // Texto "Vitória!!!"
            Text(
              'Vitória!!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.12, // 12% da largura da tela
                fontFamily: 'Aclonica',
                color: Color(0xFFF5B51C),
              ),
            ),

            // Reduzi ainda mais o espaço antes da imagem
            SizedBox(height: screenHeight * 0.02),

            // Imagem do troféu aumentada e melhor posicionada
            Image.asset(
              'assets/imagens/trofeu.png',
              width: screenWidth * 0.8,  // Aumentei a largura
              height: screenHeight * 0.5, // Aumentei a altura
              fit: BoxFit.contain,
            ),

            // Adicionei um espaço maior entre a imagem e o botão Home
            SizedBox(height: screenHeight * 0.02),

            // Botão Home no centro e mais para baixo
            _buildCircularButton(
              icon: Icons.home,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              isLarger: true, // Define um tamanho maior para o botão Home
            ),

            Spacer(), // Garante que o layout fique equilibrado
          ],
        ),
      ),
    );
  }

  // Método para criar botões circulares reutilizáveis
  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isLarger = false, // Controle de tamanho para o botão Home
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Color(0xFF3088BE),
        padding: EdgeInsets.all(isLarger ? 40 : 20), // Botão Home maior
        side: BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 60 : 35, // Ícone maior para o botão Home
        color: Color(0xFFF5B51C),
      ),
    );
  }
}

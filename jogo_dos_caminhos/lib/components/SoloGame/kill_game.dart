import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../info_screen.dart';
import 'solo_game.dart';

class KillScreen extends StatelessWidget {
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
              'Tente novamente!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.12, // Ajustado para o mesmo tamanho da tela WinScreen
                fontFamily: 'Aclonica',
                color: Color(0xFFF5B51C),
              ),
            ),

            // Reduzi ainda mais o espaço antes da imagem
            SizedBox(height: screenHeight * 0.02),

            // Imagem do troféu aumentada e melhor posicionada
            Image.asset(
              'assets/imagens/image.png',
              width: screenWidth * 0.6,  // Igual ao da tela WinScreen
              height: screenHeight * 0.4, // Igual ao da tela WinScreen
              fit: BoxFit.contain,
            ),

            // Adicionei um espaço maior entre a imagem e o botão Home
            SizedBox(height: screenHeight * 0.02),

            // Linha para os botões Home e Refresh centralizados
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularButton(
                  icon: Icons.home,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  isLarger: true,
                ),
                SizedBox(width: screenWidth * 0.05), // Espaço entre os botões
                _buildCircularButton(
                  icon: Icons.refresh, // Ícone de seta circular
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LocationSelectionScreen()),
                    );
                  },
                  isLarger: true,
                ),
              ],
            ),

            Spacer(),
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
        padding: EdgeInsets.all(isLarger ? 30 : 15), // Reduzido para igualar ao WinScreen
        side: BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 50 : 30, // Reduzido para igualar ao WinScreen
        color: Color(0xFFF5B51C),
      ),
    );
  }
}

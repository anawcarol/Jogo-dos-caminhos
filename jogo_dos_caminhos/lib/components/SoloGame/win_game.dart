import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../info_screen.dart';
import 'solo_game.dart'; // Certifique-se de importar a tela de seleção de localização

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
              padding: EdgeInsets.all(screenWidth * 0.04),
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
                  SizedBox(width: screenWidth * 0.05),
                  _buildCircularButton(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {
                      // Lógica para som
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            Text(
              'Vitória!!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.12,
                fontFamily: 'Aclonica',
                color: Color(0xFFF5B51C),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Image.asset(
              'assets/imagens/trofeu.png',
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              fit: BoxFit.contain,
            ),

            SizedBox(height: screenHeight * 0.02),

            // Linha para os botões Home e Location centralizados
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

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isLarger = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Color(0xFF3088BE),
        padding: EdgeInsets.all(isLarger ? 30 : 15), // Reduzido
        side: BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 50 : 30, // Reduzido
        color: Color(0xFFF5B51C),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../info_screen.dart';
import 'two_game.dart';

class WinScreen extends StatelessWidget {
  final bool player1Won;
  final bool player2Won;

  const WinScreen({
    Key? key,
    required this.player1Won,
    required this.player2Won,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determina o título com base nos vencedores
    String title = '';
    if (player1Won && player2Won) {
      title = 'Ambos Venceram!';
    } else if (player1Won) {
      title = 'Jogador 1 Venceu!';
    } else if (player2Won) {
      title = 'Jogador 2 Venceu!';
    }

    return Scaffold(
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Botões de Info e Volume
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircularButton(icon: Icons.info_outline, onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameInfoScreen()),
                    );
                  }),
                  SizedBox(width: screenWidth * 0.05),
                  _buildCircularButton(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            // Título dinâmico
            Text(
              title,
              textAlign: TextAlign.center, // Centraliza horizontalmente
              style: TextStyle(
                fontSize: screenWidth * 0.08, // Diminui o tamanho da fonte
                fontFamily: 'Aclonica',
                color: Color(0xFFF5B51C),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Imagem - pode ser dinâmica também se quiser
            Image.asset(
              'assets/imagens/trofeu.png',
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              fit: BoxFit.contain,
            ),

            SizedBox(height: screenHeight * 0.02),

            // Botões de ação
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
                SizedBox(width: screenWidth * 0.05),
                _buildCircularButton(
                  icon: Icons.refresh,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TwoGameScreen()),
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
        padding: EdgeInsets.all(isLarger ? 30 : 15),
        side: BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 50 : 30,
        color: Color(0xFFF5B51C),
      ),
    );
  }
}
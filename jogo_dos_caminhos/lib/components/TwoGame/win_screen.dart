import 'package:flutter/material.dart';
// Importa as telas necessárias
import '../home_screen.dart';
import '../info_screen.dart';
import 'two_game.dart';

class WinScreen extends StatelessWidget {
  // Declaração de variáveis para determinar o vencedor
  final bool player1Won;
  final bool player2Won;

  const WinScreen({
    Key? key,
    required this.player1Won,
    required this.player2Won,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtém as dimensões da tela para layout responsivo
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determina o título com base no vencedor
    String title = '';
    if (player1Won && player2Won) {
      title = 'Ambos Venceram!';
    } else if (player1Won) {
      title = 'Jogador 1 Venceu!';
    } else if (player2Won) {
      title = 'Jogador 2 Venceu!';
    }

    return Scaffold(
      // Tela com fundo gradiente
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Botões de Info e Volume no topo
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão de informações
                  _buildCircularButton(icon: Icons.info_outline, onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameInfoScreen()),
                    );
                  }),
                  SizedBox(width: screenWidth * 0.05),
                  // Botão de volume (sem funcionalidade implementada)
                  _buildCircularButton(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            // Exibe o título dinâmico com base no vencedor
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontFamily: 'Aclonica',
                color: Color(0xFFF5B51C),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            // Exibe uma imagem de troféu
            Image.asset(
              'assets/imagens/trofeu.png',
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              fit: BoxFit.contain,
            ),

            SizedBox(height: screenHeight * 0.02),

            // Botões de ação (Home e Reiniciar)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão para voltar à tela inicial
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
                // Botão para reiniciar o jogo
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

            Spacer(), // Adiciona espaço flexível no final
          ],
        ),
      ),
    );
  }

  // Método para criar bot��es circulares reutilizáveis
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
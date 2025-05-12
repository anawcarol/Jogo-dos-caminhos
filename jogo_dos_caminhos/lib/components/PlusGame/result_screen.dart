import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../info_screen.dart';
import 'two_game_plus.dart';

// Tela exibida ao final do jogo com o resultado para os jogadores
class GameResultScreen extends StatelessWidget {
  final bool player1Won;    // Indica se o jogador 1 venceu
  final bool player2Won;    // Indica se o jogador 2 venceu
  final bool isKillScreen;  // Indica se é uma tela de "derrota" (falha especial do jogador)

  const GameResultScreen({
    Key? key,
    this.player1Won = false,
    this.player2Won = false,
    this.isKillScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtém dimensões da tela para responsividade
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Define se houve empate (ninguém venceu e não foi tela de derrota)
    final isDraw = !player1Won && !player2Won && !isKillScreen;

    return Scaffold(
      body: GradientBackground( // Usa um fundo com gradiente
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Linha superior com botões de informações e volume
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão de informações do jogo
                  _buildCircularButton(
                    icon: Icons.info_outline,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameInfoScreen()),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  // Botão de som (ainda sem ação definida)
                  _buildCircularButton(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {}, // Lógica de som será adicionada depois
                  ),
                ],
              ),
            ),

            // Espaço entre os botões e o título
            SizedBox(height: screenHeight * 0.05),

            // Exibe o título com o resultado do jogo, de acordo com a situação
            Text(
              isKillScreen ? 'Tente Novamente!' :
              isDraw ? 'Empate!' : 
              player1Won && player2Won ? 'Ambos Venceram!' :
              player1Won ? 'Jogador 1 Venceu!' : 'Jogador 2 Venceu!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * (isKillScreen ? 0.09 : 0.08),
                fontFamily: 'Aclonica',
                color: const Color(0xFFF5B51C),
              ),
            ),

            // Espaço antes da imagem
            SizedBox(height: screenHeight * 0.02),

            // Exibe uma imagem relacionada ao resultado (troféu ou imagem padrão)
            Image.asset(
              isKillScreen ? 'assets/imagens/image.png' : 
              isDraw ? 'assets/imagens/image.png' : 'assets/imagens/trofeu.png',
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              fit: BoxFit.contain,
            ),

            // Espaço antes dos botões de ação
            SizedBox(height: screenHeight * 0.02),

            // Linha com botões de ação (início e reinício)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão para voltar à tela inicial (Home)
                _buildCircularButton(
                  icon: Icons.home,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                      (Route<dynamic> route) => false, // Remove todas as rotas anteriores
                    );
                  },
                  isLarger: true,
                ),
                SizedBox(width: screenWidth * 0.05),

                // Botão de reiniciar o jogo (apenas se não for uma tela de derrota)
                if (!isKillScreen)
                _buildCircularButton(
                  icon: Icons.refresh,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TwoGamePlusScreen()),
                    );
                  },
                  isLarger: true,
                ),
              ],
            ),

            Spacer(), // Preenche o espaço restante da tela
          ],
        ),
      ),
    );
  }

  // Cria um botão circular reutilizável com ícone central
  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isLarger = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(), // Formato redondo
        backgroundColor: const Color(0xFF3088BE), // Cor de fundo
        padding: EdgeInsets.all(isLarger ? 30 : 15), // Tamanho do botão
        side: const BorderSide(
          color: Color(0xFFF5B51C), // Cor da borda
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 50 : 30,
        color: const Color(0xFFF5B51C), // Cor do ícone
      ),
    );
  }
}

// Widget que aplica o fundo em gradiente azul para a tela
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF163F58), Color(0xFF3088BE)], // Cores do gradiente
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child, // Conteúdo da tela é inserido dentro do gradiente
    );
  }
}

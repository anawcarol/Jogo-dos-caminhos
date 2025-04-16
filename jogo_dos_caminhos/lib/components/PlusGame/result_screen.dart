import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../info_screen.dart';

class GameResultScreen extends StatelessWidget {
  final bool player1Won;
  final bool player2Won;

  const GameResultScreen({
    Key? key,
    required this.player1Won,
    required this.player2Won,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDraw = !player1Won && !player2Won;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF163F58), Color(0xFF3088BE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Botões superiores (Info e Volume)
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularButton(
                      icon: Icons.info_outline,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameInfoScreen()),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildCircularButton(
                      icon: Icons.volume_up_outlined,
                      onPressed: () {}, // Lógica para som
                    ),
                  ],
                ),
              ),

              // Espaço antes do título
              SizedBox(height: screenHeight * 0.05),

              // Título dinâmico
              Text(
                isDraw ? 'Tente novamente!' 
                     : player1Won ? 'Vitória Jogador 1!' 
                     : 'Vitória Jogador 2!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * (isDraw ? 0.10 : 0.12),
                  fontFamily: 'Aclonica',
                  color: const Color(0xFFF5B51C),
                ),
              ),

              // Espaço antes da imagem
              SizedBox(height: screenHeight * 0.02),

              // Imagem condicional
              Image.asset(
                isDraw ? 'assets/imagens/image.png' : 'assets/imagens/trofeu.png',
                width: screenWidth * (isDraw ? 0.7 : 0.8),
                height: screenHeight * (isDraw ? 0.35 : 0.5),
                fit: BoxFit.contain,
              ),

              // Espaço antes do botão
              SizedBox(height: screenHeight * 0.02),

              // Botão Home
              _buildCircularButton(
                icon: Icons.home,
                onPressed: () => Navigator.pop(context),
                isLarger: true,
              ),

              Spacer(),
            ],
          ),
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
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3088BE),
        padding: EdgeInsets.all(isLarger ? 40 : 20),
        side: const BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 60 : 35,
        color: const Color(0xFFF5B51C),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:jogo_dos_caminhos/components/two_game_plus.dart';
import 'choose_screen.dart'; // Tela para voltar
import 'two_game.dart';  // Tela do jogo

class HowToPlayPvPlusScreen extends StatefulWidget {
  @override
  _HowToPlayPvPlusScreenState createState() => _HowToPlayPvPlusScreenState();
}

class _HowToPlayPvPlusScreenState extends State<HowToPlayPvPlusScreen> {
  int _currentTextIndex = 0; // Controla o índice do texto (0 ou 1)

  // Lista de textos para exibir no container
  final List<List<String>> _instructions = [
    [
      '• O jogo é disputado em 2 rodadas.',
      '• 1ª rodada: Jogador 1 escolhe um destino (qualquer casa que não seja cinza). Jogador 2 traça o caminho até lá, movendo‑se casa a casa (adjacente).',
      '• Cada passo é contado. Quando o caminho alcançar o destino, a rodada acaba e o total de movimentos do Jogador 2 é registrado.',
    ],
    [
      '• 2ª rodada: os papéis se invertem — Jogador 2 escolhe o destino e Jogador 1 traça o caminho.',
      '• Ao traçar o caminho, o destino escolhido pelo adversário fica oculto até ser alcançado.',
      '• Vence quem atingir o destino do oponente com MENOS movimentos. Empate se ambos precisarem do mesmo número de passos.',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF163F58), Color(0xFF3088BE)],
            stops: [0.3, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Botões de navegação superior
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.03,
                horizontal: screenWidth * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNavigationButton(
                    icon: Icons.arrow_back_outlined,
                    onPressed: () {
                      if (_currentTextIndex > 0) {
                        setState(() {
                          _currentTextIndex--; // Voltar para o texto anterior
                        });
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameModeScreen(),
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  _buildNavigationButton(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {
                      // Lógica para som
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  _buildNavigationButton(
                    icon: Icons.arrow_forward_outlined,
                    onPressed: () {
                      if (_currentTextIndex < _instructions.length - 1) {
                        setState(() {
                          _currentTextIndex++; // Avançar para o próximo texto
                        });
                      } else {
                        // Navega diretamente para GameScreenDois
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TwoGamePlusScreen(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // Título "Como jogar!"
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              child: Text(
                'Como jogar!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontFamily: 'Aclonica',
                  color: Color(0xFFF5B51C),
                ),
              ),
            ),

            // Container com altura fixa e texto dinâmico centralizado
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.03,
                  horizontal: screenWidth * 0.05,
                ),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.08),
                  decoration: BoxDecoration(
                    color: Color(0xFF257F98),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFFF5B51C),
                      width: 3,
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: _instructions[_currentTextIndex].length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          _instructions[_currentTextIndex][index],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            color: Colors.white,
                            fontFamily: 'Philosopher',
                            height: 1.7,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // Ícones "Jogador vs Jogador"
            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.02),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 2,
                    child: Icon(
                      Icons.person_2_outlined,
                      size: screenWidth * 0.10,
                      color: Color(0xFF163F58),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Flexible(
                    flex: 3,
                    child: Image.asset(
                      'assets/imagens/image_vs.png',
                      width: screenWidth * 0.15,
                      height: screenHeight * 0.08,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Flexible(
                    flex: 2,
                    child: Icon(
                      Icons.person_2_outlined,
                      size: screenWidth * 0.10,
                      color: Color(0xFF163F58),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Color(0xFF3088BE),
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        shadowColor: Colors.transparent,
        side: BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: MediaQuery.of(context).size.width * 0.07,
        color: Color(0xFFF5B51C),
      ),
    );
  }
}
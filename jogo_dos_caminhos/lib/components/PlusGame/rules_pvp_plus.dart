import 'package:flutter/material.dart';
import 'package:jogo_dos_caminhos/components/PlusGame/two_game_plus.dart';
import '../choose_screen.dart'; // Tela para voltar
import '../TwoGame/two_game.dart';  // Tela do jogo

class HowToPlayPvPlusScreen extends StatefulWidget {
  @override
  _HowToPlayPvPlusScreenState createState() => _HowToPlayPvPlusScreenState();
}

class _HowToPlayPvPlusScreenState extends State<HowToPlayPvPlusScreen> {
  int _currentTextIndex = 0;

  final List<List<String>> _instructions = [
    [
      '• O jogo é disputado em 2 rodadas.',
      '• 1ª rodada: Jogador 1 escolhe um destino (qualquer casa que não seja cinza). Jogador 2 traça o caminho até lá.',
       '• 2ª rodada: o Jogador 2 traça um caminho conforme desejar.',
    ],
    [
      '• Sendo possível mover apenas para direita ou para cima',
      '• O jogador 1 vence o jogo caso o jogador 2 não consiga traçar o caminho pelo o seu ponto escolhido, caso o jogador 2 consiga, assim o jogador 2 vencerá o jogo.',
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
        decoration: const BoxDecoration(
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
                          _currentTextIndex--;
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
                      // Aqui você pode colocar a lógica para tocar um som se quiser
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  _buildNavigationButton(
                    icon: Icons.arrow_forward_outlined,
                    onPressed: () {
                      if (_currentTextIndex < _instructions.length - 1) {
                        setState(() {
                          _currentTextIndex++;
                        });
                      } else {
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

            // Título
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

            // Container sem scroll com instruções
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _instructions[_currentTextIndex]
                        .map(
                          (instruction) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              instruction,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                color: Colors.white,
                                fontFamily: 'Philosopher',
                                height: 1.7,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),

            // Ícones Jogador vs Jogador
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

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Color(0xFF3088BE),
        padding: EdgeInsets.all(screenWidth * 0.05),
        shadowColor: Colors.transparent,
        side: BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: screenWidth * 0.07,
        color: Color(0xFFF5B51C),
      ),
    );
  }
}

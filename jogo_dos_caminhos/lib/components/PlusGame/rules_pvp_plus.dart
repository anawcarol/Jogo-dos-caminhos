import 'package:flutter/material.dart';
import 'package:jogo_dos_caminhos/components/PlusGame/two_game_plus.dart';
import '../choose_screen.dart'; // Tela para voltar  

// Tela de instruções para o modo PvP Plus
class HowToPlayPvPlusScreen extends StatefulWidget {
  @override
  _HowToPlayPvPlusScreenState createState() => _HowToPlayPvPlusScreenState();
}

class _HowToPlayPvPlusScreenState extends State<HowToPlayPvPlusScreen> {
  int _currentTextIndex = 0; // Índice para controlar qual conjunto de instruções está sendo exibido

  // Lista de instruções dividida em páginas
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
    final screenHeight = MediaQuery.of(context).size.height; // Altura da tela
    final screenWidth = MediaQuery.of(context).size.width; // Largura da tela

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          // Gradiente de fundo
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
                  // Botão para voltar ou navegar para a página anterior
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
                  // Botão para ativar som (não implementado)
                  _buildNavigationButton(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {
                      // Aqui você pode colocar a lógica para tocar um som se quiser
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  // Botão para avançar ou ir para a próxima tela
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

            // Título da tela
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

            // Container com as instruções (sem scroll)
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.03,
                  horizontal: screenWidth * 0.05,
                ),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.08),
                  decoration: BoxDecoration(
                    color: Color(0xFF257F98), // Cor de fundo do container
                    borderRadius: BorderRadius.circular(20), // Bordas arredondadas
                    border: Border.all(
                      color: Color(0xFFF5B51C), // Cor da borda
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

            // Ícones representando o modo Jogador vs Jogador
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
                      'assets/imagens/image_vs.png', // Imagem "VS"
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

  // Método para construir os botões de navegação
  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(), // Botão circular
        backgroundColor: Color(0xFF3088BE), // Cor de fundo
        padding: EdgeInsets.all(screenWidth * 0.05), // Espaçamento interno
        shadowColor: Colors.transparent, // Sem sombra
        side: BorderSide(
          color: Color(0xFFF5B51C), // Cor da borda
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: screenWidth * 0.07, // Tamanho do ícone
        color: Color(0xFFF5B51C), // Cor do ícone
      ),
    );
  }
}

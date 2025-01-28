import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final List<bool> selectedLocations;

  GameScreen({required this.selectedLocations});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Lista de bolas (4 verdes e 4 vermelhas)
  List<Color> balls = [Colors.green, Colors.green, Colors.green, Colors.red, Colors.red, Colors.red];

  // Cor atual da bola sorteada
  Color ballColor = Colors.green;
  List<String> sortedBalls = [];

  // Posições das células no tabuleiro
  final Map<String, Offset> positions = {
    '1A': Offset(0.1, 0.1),
    '2A': Offset(0.3, 0.1),
    '3A': Offset(0.5, 0.1),
    '4A': Offset(0.7, 0.1),
    '1B': Offset(0.1, 0.3),
    '2B': Offset(0.3, 0.3),
    '3B': Offset(0.5, 0.3),
    '4B': Offset(0.7, 0.3),
    '1C': Offset(0.1, 0.5),
    '2C': Offset(0.3, 0.5),
    '3C': Offset(0.5, 0.5),
    '4C': Offset(0.7, 0.5),
    '1D': Offset(0.1, 0.7),
    '2D': Offset(0.3, 0.7),
    '3D': Offset(0.5, 0.7),
    '4D': Offset(0.7, 0.7),
  };

  // Função para sortear uma bola e desenhar a linha entre os pontos
  void _sortearBola() {
    setState(() {
      // Sorteia uma bola da lista e remove ela
      ballColor = balls.removeAt(Random().nextInt(balls.length));
      sortedBalls.add(ballColor == Colors.green ? "Green" : "Red");
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF163F58), Color(0xFF3088BE)],
            stops: [0.3, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top buttons (navigational buttons)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.03,
                  horizontal: screenWidth * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavigationButton(
                      context,
                      icon: Icons.info,
                      onPressed: () {
                        // Handle info action
                      },
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      context,
                      icon: Icons.volume_up,
                      onPressed: () {
                        // Handle sound toggle
                      },
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      context,
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Text(
                  'Jogo em andamento',
                  style: TextStyle(
                    color: const Color(0xFFF5B51C),
                    fontSize: screenWidth * 0.08,
                    fontFamily: 'Aclonica',
                  ),
                ),
              ),

              // Grid for the game
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: screenWidth * 0.02,
                    mainAxisSpacing: screenHeight * 0.02,
                  ),
                  itemCount: 16,
                  itemBuilder: (context, index) {
                    String cell = "${(index % 4) + 1}${String.fromCharCode(65 + (index ~/ 4))}";
                    return GestureDetector(
                      onTap: () {
                        // Game interaction
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: widget.selectedLocations[index]
                              ? Colors.green
                              : Colors.black,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFF5B51C), width: 3),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bola sorteada
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: Column(
                  children: [
                    Text(
                      'Bola Sorteada:',
                      style: TextStyle(
                        color: const Color(0xFFF5B51C),
                        fontSize: screenWidth * 0.07,
                        fontFamily: 'Aclonica',
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Exibe a bola sorteada
                    Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: ballColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Botão "Seguir" para realizar o sorteio
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                child: ElevatedButton(
                  onPressed: balls.isEmpty ? null : _sortearBola,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3088BE),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1, vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Seguir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.06,
                      fontFamily: 'Aclonica',
                    ),
                  ),
                ),
              ),
              
              // Desenha a linha entre os pontos no tabuleiro
              CustomPaint(
                size: Size(screenWidth, screenHeight),
                painter: LinePainter(sortedBalls, positions),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar os botões de navegação
  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3088BE),
        padding: EdgeInsets.all(screenWidth * 0.05),
        shadowColor: Colors.transparent,
        side: const BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: screenWidth * 0.07,
        color: const Color(0xFFF5B51C),
      ),
    );
  }
}

// CustomPainter para desenhar as linhas
class LinePainter extends CustomPainter {
  final List<String> sortedBalls;
  final Map<String, Offset> positions;

  LinePainter(this.sortedBalls, this.positions);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < sortedBalls.length; i++) {
      if (sortedBalls[i] == "Red") {
        // Desenha a linha vermelha (entre 1D e 2D, por exemplo)
        canvas.drawLine(
          positions['1D']!,
          positions['2D']!,
          paint..color = Colors.red,
        );
      } else {
        // Desenha a linha verde
        canvas.drawLine(
          positions['1D']!,
          positions['1C']!,
          paint..color = Colors.green,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

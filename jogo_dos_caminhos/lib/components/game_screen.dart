import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final List<bool> selectedLocations;

  GameScreen({required this.selectedLocations});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Color> balls = [Colors.green, Colors.green, Colors.green, Colors.red, Colors.red, Colors.red];
  Color ballColor = Colors.green;
  List<String> sortedBalls = [];
  List<List<bool>> matrix = List.generate(4, (_) => List.filled(4, false));
  List<List<bool>> yellowMatrix = List.generate(4, (_) => List.filled(4, false)); // Matriz para os locais amarelos
  List<Offset> path = [];
  int currentX = 0; // Linha inicial na matriz
  int currentY = 0; // Coluna inicial na matriz

  @override
  void initState() {
    super.initState();
    path.add(Offset(currentX.toDouble(), currentY.toDouble())); // Ponto inicial
    matrix[currentX][currentY] = true; // Marcar o ponto inicial como visitado
  }

  void _sortearBola() {
    setState(() {
      if (balls.isEmpty) return;

      ballColor = balls.removeAt(Random().nextInt(balls.length));
      String ballType = ballColor == Colors.green ? "Green" : "Red";
      sortedBalls.add(ballType);

      _calcularCaminho(ballColor);
    });
  }

  void _calcularCaminho(Color bola) {
    int nextX = currentX;
    int nextY = currentY;

    if (bola == Colors.green) {
      // Movimenta-se para a direita, se possível
      if (currentY + 1 < 4 && !matrix[currentX][currentY + 1]) {
        nextY = currentY + 1;
      }
    } else {
      // Movimenta-se para baixo, se possível
      if (currentX + 1 < 4 && !matrix[currentX + 1][currentY]) {
        nextX = currentX + 1;
      }
    }

    // Atualizar posição
    if (nextX != currentX || nextY != currentY) {
      currentX = nextX;
      currentY = nextY;
      matrix[currentX][currentY] = true;
      path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    }
  }

  void _selecionarLocal(int row, int col) {
    setState(() {
      yellowMatrix[row][col] = true; // Marca o local selecionado como amarelo
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
                      onPressed: () {},
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      context,
                      icon: Icons.volume_up,
                      onPressed: () {},
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
                    int row = index ~/ 4;
                    int col = index % 4;
                    return GestureDetector(
                      onTap: () {
                        _selecionarLocal(row, col); // Marca o local ao clicar
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: yellowMatrix[row][col]
                              ? Colors.yellow // Manter o local amarelo
                              : (matrix[row][col] ? Colors.green : Colors.black),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFF5B51C), width: 3),
                        ),
                      ),
                    );
                  },
                ),
              ),
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
              CustomPaint(
                size: Size(screenWidth, screenHeight),
                painter: LinePainter(path),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

class LinePainter extends CustomPainter {
  final List<Offset> path;

  LinePainter(this.path);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..color = Colors.yellow;

    for (int i = 0; i < path.length - 1; i++) {
      Offset start = Offset(path[i].dy * size.width / 4 + size.width / 8,
          path[i].dx * size.height / 4 + size.height / 8);
      Offset end = Offset(path[i + 1].dy * size.width / 4 + size.width / 8,
          path[i + 1].dx * size.height / 4 + size.height / 8);
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

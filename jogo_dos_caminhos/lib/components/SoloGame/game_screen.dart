import 'package:flutter/material.dart';
import 'dart:math';
import 'win_game.dart';
import 'kill_game.dart';

class GameScreen extends StatefulWidget {
  final List<bool> selectedLocations;

  GameScreen({required this.selectedLocations});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Color> balls = [
    Colors.green,
    Colors.green,
    Colors.green,
    Colors.red,
    Colors.red,
    Colors.red,
  ];
  Color? ballColor;
  List<String> sortedBalls = [];
  List<List<bool>> matrix = List.generate(4, (_) => List.filled(4, false));
  List<List<bool>> yellowMatrix = List.generate(4, (_) => List.filled(4, false));
  List<Offset> path = [];
  int currentX = 3;
  int currentY = 0;
  bool? victory;
  bool isBlinking = false;

  @override
  void initState() {
    super.initState();
    path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    matrix[currentX][currentY] = true;

    int selectedIndex = widget.selectedLocations.indexWhere((element) => element);
    if (selectedIndex != -1) {
      int row = selectedIndex ~/ 4;
      int col = selectedIndex % 4;
      yellowMatrix[row][col] = true;
    }
  }

  Future<void> _piscarPontoSelecionado(int row, int col) async {
    setState(() {
      isBlinking = true;
    });

    for (int i = 0; i < 2; i++) {
      setState(() {
        yellowMatrix[row][col] = false;
      });
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        yellowMatrix[row][col] = true;
      });
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        yellowMatrix[row][col] = true;
      });
      await Future.delayed(const Duration(milliseconds: 150));
    }

    setState(() {
      yellowMatrix[row][col] = false;
      isBlinking = false;
    });
  }

  void _sortearBola() {
    setState(() {
      if (balls.isEmpty) return;

      ballColor = balls.removeAt(Random().nextInt(balls.length));
      String ballType = ballColor == Colors.green ? "Green" : "Red";
      sortedBalls.add(ballType);

      _calcularCaminho(ballColor!);

      if (balls.isEmpty) {
        _checkVictory();
      }
    });
  }

  void _calcularCaminho(Color bola) async {
    int nextX = currentX;
    int nextY = currentY;

    if (bola == Colors.green) {
      if (currentY + 1 < 4 && !matrix[currentX][currentY + 1]) {
        nextY = currentY + 1;
      }
    } else {
      if (currentX - 1 >= 0 && !matrix[currentX - 1][currentY]) {
        nextX = currentX - 1;
      }
    }

    if (nextX != currentX || nextY != currentY) {
      currentX = nextX;
      currentY = nextY;
      matrix[currentX][currentY] = true;
      path.add(Offset(currentX.toDouble(), currentY.toDouble()));

      int selectedIndex = widget.selectedLocations.indexWhere((element) => element);
      if (selectedIndex != -1) {
        int selectedRow = selectedIndex ~/ 4;
        int selectedCol = selectedIndex % 4;

        if (currentX == selectedRow && currentY == selectedCol) {
          await _piscarPontoSelecionado(selectedRow, selectedCol);
        }
      }
    }
  }

  void _checkVictory() async {
    int selectedIndex = widget.selectedLocations.indexWhere((element) => element);
    if (selectedIndex != -1) {
      int row = selectedIndex ~/ 4;
      int col = selectedIndex % 4;

      bool win = path.any((offset) => offset.dx.toInt() == row && offset.dy.toInt() == col);
      victory = win;

      await Future.delayed(const Duration(seconds: 3));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => win ? WinScreen() : KillScreen(),
        ),
      );
    }
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required int index,
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

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavigationButton(
                      context,
                      icon: Icons.info,
                      onPressed: () {},
                      index: 0,
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      context,
                      icon: Icons.volume_up,
                      onPressed: () {},
                      index: 1,
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      context,
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      index: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Column(
                  children: [
                    Text(
                      'Jogo em andamento',
                      style: TextStyle(
                        color: const Color(0xFFF5B51C),
                        fontSize: screenWidth * 0.08,
                        fontFamily: 'Aclonica',
                      ),
                    ),
                    SizedBox(height: 25.0),
                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0, screenWidth * 0.05, 8.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: screenWidth * 0.02,
                      mainAxisSpacing: screenWidth * 0.02,
                      childAspectRatio: 1,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      int row = index ~/ 4;
                      int col = index % 4;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: yellowMatrix[row][col]
                              ? Colors.yellow
                              : (matrix[row][col]
                                  ? Colors.indigo[800]
                                  : const Color.fromARGB(255, 39, 126, 136)),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFF5B51C),
                            width: 3,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        ballColor != null ? 'Bola Sorteada:' : 'Clique em Seguir para começar',
                        style: TextStyle(
                          color: const Color(0xFFF5B51C),
                          fontSize: screenWidth * 0.05,
                          fontFamily: 'Aclonica',
                        ),
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Container(
                      width: screenWidth * 0.8,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: ballColor ?? Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: ballColor != null
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(5, 5),
                                ),
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    if (ballColor != null)
                      Text(
                        ballColor == Colors.green ? 'Para direita' : 'Para cima',
                        style: TextStyle(
                          color: const Color(0xFFF5B51C),
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'Aclonica',
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
                child: ElevatedButton(
                  onPressed: balls.isEmpty ? null : _sortearBola,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3088BE),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: 16.0,
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}

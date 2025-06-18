import 'package:flutter/material.dart';
import 'dart:math';
import 'win_screen.dart';
import 'kill_screen.dart';
import '../info_screen.dart';

class GameScreenDois extends StatefulWidget {
  final List<bool> selectedLocationsPlayer1;
  final List<bool> selectedLocationsPlayer2;
  final Function(bool, bool) onGameFinished;

  const GameScreenDois({
    Key? key,
    required this.selectedLocationsPlayer1,
    required this.selectedLocationsPlayer2,
    required this.onGameFinished,
  }) : super(key: key);

  @override
  _GameScreenDoisState createState() => _GameScreenDoisState();
}

class _GameScreenDoisState extends State<GameScreenDois> {
  List<Color> balls = [
    Colors.green,
    Colors.green,
    Colors.green,
    Colors.red,
    Colors.red,
    Colors.red,
  ];
  Color? ballColor;
  List<List<bool>> matrix = List.generate(4, (_) => List.filled(4, false));
  List<List<bool>> visitedPoints = List.generate(4, (_) => List.filled(4, false));
  List<Offset> path = [];
  int currentX = 3;
  int currentY = 0;
  bool gameFinished = false;
  bool isBlinking = false;
  int? blinkingRow;
  int? blinkingCol;
  bool showIndigo = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    path.clear();
    matrix = List.generate(4, (_) => List.filled(4, false));
    visitedPoints = List.generate(4, (_) => List.filled(4, false));
    currentX = 3;
    currentY = 0;
    path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    matrix[currentX][currentY] = true;
    gameFinished = false;
    isBlinking = false;
    blinkingRow = null;
    blinkingCol = null;
    showIndigo = false;
  }

  Future<void> _piscarPontoSelecionado(int row, int col) async {
    setState(() {
      isBlinking = true;
      blinkingRow = row;
      blinkingCol = col;
    });

    for (int i = 0; i < 3; i++) {
      setState(() {
        showIndigo = true;
      });
      await Future.delayed(const Duration(milliseconds: 150));
      
      setState(() {
        showIndigo = false;
      });
      await Future.delayed(const Duration(milliseconds: 150));
    }

    setState(() {
      visitedPoints[row][col] = true;
      isBlinking = false;
      blinkingRow = null;
      blinkingCol = null;
    });
  }

  void _sortearBola() {
    if (balls.isEmpty || gameFinished) return;

    setState(() {
      ballColor = balls.removeAt(Random().nextInt(balls.length));
      _calcularCaminho(ballColor!);
      
      if (balls.isEmpty || (currentX == 0 && currentY == 3)) {
        _finalizarJogo();
      }
    });
  }

  void _calcularCaminho(Color bola) async {
    int nextX = currentX;
    int nextY = currentY;

    if (bola == Colors.green) {
      if (currentY + 1 < 4 && !matrix[currentX][currentY + 1]) nextY++;
    } else {
      if (currentX - 1 >= 0 && !matrix[currentX - 1][currentY]) nextX--;
    }

    if (nextX != currentX || nextY != currentY) {
      setState(() {
        currentX = nextX;
        currentY = nextY;
        matrix[currentX][currentY] = true;
        path.add(Offset(currentX.toDouble(), currentY.toDouble()));
      });

      int indexP1 = widget.selectedLocationsPlayer1.indexWhere((e) => e);
      if (indexP1 != -1) {
        int rowP1 = indexP1 ~/ 4, colP1 = indexP1 % 4;
        if (currentX == rowP1 && currentY == colP1 && !visitedPoints[rowP1][colP1]) {
          await _piscarPontoSelecionado(rowP1, colP1);
        }
      }

      int indexP2 = widget.selectedLocationsPlayer2.indexWhere((e) => e);
      if (indexP2 != -1) {
        int rowP2 = indexP2 ~/ 4, colP2 = indexP2 % 4;
        if (currentX == rowP2 && currentY == colP2 && !visitedPoints[rowP2][colP2]) {
          await _piscarPontoSelecionado(rowP2, colP2);
        }
      }

      if (currentX == 0 && currentY == 3) {
        _finalizarJogo();
      }
    }
  }

  void _finalizarJogo() async {
    if (gameFinished) return;

    gameFinished = true;

    bool player1Wins = _checkPlayerWin(widget.selectedLocationsPlayer1);
    bool player2Wins = _checkPlayerWin(widget.selectedLocationsPlayer2);

    await Future.delayed(const Duration(seconds: 3));

    if (player1Wins || player2Wins) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => WinScreen(
            player1Won: player1Wins,
            player2Won: player2Wins,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => KillScreen()),
      );
    }
  }

  bool _checkPlayerWin(List<bool> playerLocations) {
    int index = playerLocations.indexWhere((e) => e);
    if (index != -1) {
      int row = index ~/ 4, col = index % 4;
      return path.any((o) => o.dx.toInt() == row && o.dy.toInt() == col);
    }
    return false;
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3088BE),
        padding: EdgeInsets.all(screenWidth * 0.04),
        shadowColor: Colors.transparent,
        side: const BorderSide(
          color: Color(0xFFF5B51C),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: screenWidth * 0.06,
        color: const Color(0xFFF5B51C),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 375;

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
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 12.0 : 16.0,
                  horizontal: isSmallScreen ? 12.0 : 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavigationButton(
                      icon: Icons.info,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameInfoScreen()),
                        );
                      },
                    ),
                    SizedBox(width: isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.05),
                    _buildNavigationButton(
                      icon: Icons.volume_up,
                      onPressed: () {},
                    ),
                    SizedBox(width: isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.05),
                    _buildNavigationButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 12.0 : 16.0),

              // Title
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 8.0 : 12.0),
                child: Center(
                  child: Text(
                    'Jogo em andamento',
                    style: TextStyle(
                      color: const Color(0xFFF5B51C),
                      fontSize: isSmallScreen ? screenWidth * 0.055 : screenWidth * 0.06,
                      fontFamily: 'Aclonica',
                    ),
                  ),
                ),
              ),

              SizedBox(height: isSmallScreen ? 12.0 : 16.0),

              // Game Grid - Tamanho reduzido
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? screenWidth * 0.03 : screenWidth * 0.05,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: isSmallScreen ? screenWidth * 0.8 : screenWidth * 0.7,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: isSmallScreen ? screenWidth * 0.015 : screenWidth * 0.02,
                          mainAxisSpacing: isSmallScreen ? screenWidth * 0.015 : screenWidth * 0.02,
                          childAspectRatio: 1,
                        ),
                        itemCount: 16,
                        itemBuilder: (context, index) {
                          int row = index ~/ 4, col = index % 4;
                          bool isSelectedP1 = widget.selectedLocationsPlayer1[index];
                          bool isSelectedP2 = widget.selectedLocationsPlayer2[index];
                          bool wasVisited = visitedPoints[row][col];
                          bool isBlinkingNow = isBlinking && blinkingRow == row && blinkingCol == col;

                          Color getCellColor() {
                            if (wasVisited) return Colors.indigo[800]!;
                            if (isBlinkingNow) return showIndigo ? Colors.indigo[800]! : 
                                (isSelectedP1 ? const Color(0xFFF5B51C) : const Color.fromARGB(255, 7, 62, 77));
                            if (isSelectedP1) return const Color(0xFFF5B51C);
                            if (isSelectedP2) return const Color.fromARGB(255, 7, 62, 77);
                            return matrix[row][col] ? Colors.indigo[800]! : const Color.fromARGB(255, 39, 126, 136);
                          }

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: getCellColor(),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFF5B51C),
                                width: isSmallScreen ? 2 : 2.5,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: isSmallScreen ? 12.0 : 16.0),

              // Controls
              Padding(
                padding: EdgeInsets.only(
                  bottom: isSmallScreen ? 12.0 : 16.0,
                  top: isSmallScreen ? 8.0 : 12.0,
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        ballColor != null ? 'Bola Sorteada:' : 'Clique em Seguir para começar',
                        style: TextStyle(
                          color: const Color(0xFFF5B51C),
                          fontSize: isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.045,
                          fontFamily: 'Aclonica',
                        ),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8.0 : 12.0),
                    Container(
                      width: isSmallScreen ? screenWidth * 0.15 : screenWidth * 0.2,
                      height: isSmallScreen ? screenWidth * 0.15 : screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: ballColor ?? Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: ballColor != null ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(4, 4),
                          ),
                        ] : [],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8.0 : 12.0),
                    if (ballColor != null)
                      Text(
                        ballColor == Colors.green ? 'Para direita' : 'Para cima',
                        style: TextStyle(
                          color: const Color(0xFFF5B51C),
                          fontSize: isSmallScreen ? screenWidth * 0.035 : screenWidth * 0.04,
                          fontFamily: 'Aclonica',
                        ),
                      ),
                    SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                    // Botão Seguir menor
                    ElevatedButton(
                      onPressed: gameFinished ? null : _sortearBola,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3088BE),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? screenWidth * 0.08 : screenWidth * 0.1,
                          vertical: isSmallScreen ? 10.0 : 12.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        gameFinished ? 'Jogo Finalizado' : 'Seguir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.045,
                          fontFamily: 'Aclonica',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
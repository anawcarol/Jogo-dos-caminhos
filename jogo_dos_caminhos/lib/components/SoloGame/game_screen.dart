import 'package:flutter/material.dart';
import 'dart:math';
import 'win_game.dart';
import 'kill_game.dart';

class GameScreen extends StatefulWidget {
  final List<bool> selectedLocations;

  const GameScreen({Key? key, required this.selectedLocations})
      : super(key: key);

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
  List<List<bool>> yellowMatrix =
      List.generate(4, (_) => List.filled(4, false));
  List<Offset> path = [];
  int currentX = 3;
  int currentY = 0;
  bool? victory;
  bool isBlinking = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    matrix[currentX][currentY] = true;

    final selectedIndex =
        widget.selectedLocations.indexWhere((element) => element);
    if (selectedIndex != -1) {
      final row = selectedIndex ~/ 4;
      final col = selectedIndex % 4;
      yellowMatrix[row][col] = true;
    }
  }

  Future<void> _piscarPontoSelecionado(int row, int col) async {
    setState(() => isBlinking = true);

    for (int i = 0; i < 2; i++) {
      setState(() => yellowMatrix[row][col] = false);
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() => yellowMatrix[row][col] = true);
      await Future.delayed(const Duration(milliseconds: 150));
    }

    setState(() {
      yellowMatrix[row][col] = false;
      isBlinking = false;
    });
  }

  void _sortearBola() {
    if (balls.isEmpty) return;

    setState(() {
      ballColor = balls.removeAt(Random().nextInt(balls.length));
      sortedBalls.add(ballColor == Colors.green ? "Green" : "Red");
      _calcularCaminho(ballColor!);

      if (balls.isEmpty) _checkVictory();
    });
  }

  Future<void> _calcularCaminho(Color bola) async {
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
      setState(() {
        currentX = nextX;
        currentY = nextY;
        matrix[currentX][currentY] = true;
        path.add(Offset(currentX.toDouble(), currentY.toDouble()));
      });

      final selectedIndex =
          widget.selectedLocations.indexWhere((element) => element);
      if (selectedIndex != -1) {
        final selectedRow = selectedIndex ~/ 4;
        final selectedCol = selectedIndex % 4;

        if (currentX == selectedRow && currentY == selectedCol) {
          await _piscarPontoSelecionado(selectedRow, selectedCol);
        }
      }
    }
  }

  Future<void> _checkVictory() async {
    final selectedIndex =
        widget.selectedLocations.indexWhere((element) => element);
    if (selectedIndex == -1) return;

    final row = selectedIndex ~/ 4;
    final col = selectedIndex % 4;
    final win = path
        .any((offset) => offset.dx.toInt() == row && offset.dy.toInt() == col);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => win ? WinScreen() : KillScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isVerySmallScreen = screenWidth < 350;

    // Calculate responsive sizes
    final safePadding = mediaQuery.padding.top + mediaQuery.padding.bottom;
    final availableHeight =
        screenHeight - safePadding - 200; // Account for other UI elements
    final cellSize = min(screenWidth * 0.18, availableHeight / 4.5);
    final spacing = cellSize * 0.1;

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
            children: [
              // Header with navigation buttons
              _buildHeader(context, isVerySmallScreen),

              // Game title
              Padding(
                padding: EdgeInsets.only(top: isVerySmallScreen ? 8.0 : 16.0),
                child: Text(
                  'Jogo em andamento',
                  style: TextStyle(
                    color: const Color(0xFFF5B51C),
                    fontSize: isVerySmallScreen ? 18 : 22,
                    fontFamily: 'Aclonica',
                  ),
                ),
              ),

              // Game board
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: cellSize * 4 + spacing * 3,
                    height: cellSize * 4 + spacing * 3,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                      ),
                      itemCount: 16,
                      itemBuilder: (context, index) {
                        final row = index ~/ 4;
                        final col = index % 4;
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
                              width: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Ball display area
              _buildBallDisplay(context, cellSize, isVerySmallScreen),

              // Action button
              Padding(
                padding: EdgeInsets.only(
                  bottom: isVerySmallScreen ? 16.0 : 24.0,
                  top: 8.0,
                ),
                child: ElevatedButton(
                  onPressed: balls.isEmpty ? null : _sortearBola,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3088BE),
                    padding: EdgeInsets.symmetric(
                      horizontal: isVerySmallScreen ? 40 : 50,
                      vertical: isVerySmallScreen ? 12 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Seguir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isVerySmallScreen ? 16 : 18,
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

  Widget _buildHeader(BuildContext context, bool isVerySmallScreen) {
  return Padding(
    padding: EdgeInsets.symmetric(
      vertical: isVerySmallScreen ? 8.0 : 12.0,
      horizontal: 16.0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botão Info
        _buildIconButton(
          Icons.info,
          isVerySmallScreen,
          onPressed: () {}, // Adicione a ação desejada
        ),
        SizedBox(width: isVerySmallScreen ? 12 : 16),
        // Botão Volume
        _buildIconButton(
          Icons.volume_up,
          isVerySmallScreen,
          onPressed: () {}, // Adicione a ação desejada
        ),
        SizedBox(width: isVerySmallScreen ? 12 : 16),
        // Botão Voltar
        _buildIconButton(
          Icons.arrow_back,
          isVerySmallScreen,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

Widget _buildIconButton(IconData icon, bool isVerySmallScreen, {VoidCallback? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      backgroundColor: const Color(0xFF3088BE),
      padding: EdgeInsets.all(isVerySmallScreen ? 10 : 12),
      side: const BorderSide(
        color: Color(0xFFF5B51C),
        width: 2,
      ),
    ),
    child: Icon(
      icon,
      size: isVerySmallScreen ? 20 : 24,
      color: const Color(0xFFF5B51C),
    ),
  );
}

  

  Widget _buildBallDisplay(
      BuildContext context, double cellSize, bool isVerySmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isVerySmallScreen ? 8.0 : 12.0,
        horizontal: 16.0,
      ),
      child: Column(
        children: [
          Text(
            ballColor != null
                ? 'Bola Sorteada:'
                : 'Clique em Seguir para começar',
            style: TextStyle(
              color: const Color(0xFFF5B51C),
              fontSize: isVerySmallScreen ? 14 : 16,
              fontFamily: 'Aclonica',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: cellSize * 0.8,
            height: cellSize * 0.8,
            decoration: BoxDecoration(
              color: ballColor ?? Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: ballColor != null
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ]
                  : [],
            ),
          ),
          if (ballColor != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                ballColor == Colors.green ? 'Para direita' : 'Para cima',
                style: TextStyle(
                  color: const Color(0xFFF5B51C),
                  fontSize: isVerySmallScreen ? 14 : 16,
                  fontFamily: 'Aclonica',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

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
  Color? ballColor; // Alterado para nullable
  List<List<bool>> matrix = List.generate(4, (_) => List.filled(4, false));
  List<Offset> path = [];
  int currentX = 3;
  int currentY = 0;
  bool gameFinished = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    path.clear();
    matrix = List.generate(4, (_) => List.filled(4, false));
    currentX = 3;
    currentY = 0;
    path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    matrix[currentX][currentY] = true;
    gameFinished = false;
  }

  void _sortearBola() {
    if (balls.isEmpty || gameFinished) return;

    setState(() {
      ballColor = balls.removeAt(Random().nextInt(balls.length));
      _calcularCaminho(ballColor!);
      
      // Verifica se o jogo terminou
      if (balls.isEmpty || (currentX == 0 && currentY == 3)) {
        _finalizarJogo();
      }
    });
  }

  void _calcularCaminho(Color bola) {
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
        
        if (currentX == 0 && currentY == 3) {
          _finalizarJogo();
        }
      });
    }
  }

  void _finalizarJogo() async {
    if (gameFinished) return;

    gameFinished = true;

    bool player1Wins = _checkPlayerWin(widget.selectedLocationsPlayer1);
    bool player2Wins = _checkPlayerWin(widget.selectedLocationsPlayer2);

    // Aguarda 3 segundos antes de redirecionar para a tela correspondente.
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
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
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      icon: Icons.volume_up,
                      onPressed: () {},
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30.0),

              // Title
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    'Jogo em andamento',
                    style: TextStyle(
                      color: const Color(0xFFF5B51C),
                      fontSize: screenWidth * 0.07,
                      fontFamily: 'Aclonica',
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30.0),

              // Game Grid
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: 2.0,
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: screenWidth * 0.02,
                      mainAxisSpacing: screenWidth * 0.02,
                      childAspectRatio: 1,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      int row = index ~/ 4, col = index % 4;
                      bool isSelectedP1 = widget.selectedLocationsPlayer1[index];
                      bool isSelectedP2 = widget.selectedLocationsPlayer2[index];

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelectedP1
                              ? const Color(0xFFF5B51C)
                              : isSelectedP2
                                  ? const Color.fromARGB(255, 7, 62, 77)
                                  : matrix[row][col]
                                      ? Colors.indigo[800]
                                      : const Color.fromARGB(255, 39, 126, 136),
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

              const SizedBox(height: 30.0),

              // Controls
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
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
                    const SizedBox(height: 8.0),
                    Container(
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: ballColor ?? Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: ballColor != null ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                        ] : [],
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
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: gameFinished ? null : _sortearBola,
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
                        gameFinished ? 'Jogo Finalizado' : 'Seguir',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.06,
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
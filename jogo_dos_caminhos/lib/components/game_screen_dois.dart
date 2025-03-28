import 'package:flutter/material.dart';
import 'dart:math';
import 'win_game.dart';
import 'kill_game.dart';
import 'info_screen.dart';

class GameScreenDois extends StatefulWidget {
  final List<bool> selectedLocationsPlayer1;
  final List<bool> selectedLocationsPlayer2;

  const GameScreenDois({
    Key? key,
    required this.selectedLocationsPlayer1,
    required this.selectedLocationsPlayer2,
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
  Color ballColor = Colors.green;
  List<String> sortedBalls = [];
  List<List<bool>> matrix = List.generate(4, (_) => List.filled(4, false));
  List<Offset> path = [];
  int currentX = 3;
  int currentY = 0;

  @override
  void initState() {
    super.initState();
    path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    matrix[currentX][currentY] = true;
  }

  void _sortearBola() {
    if (balls.isEmpty) return;

    setState(() {
      ballColor = balls.removeAt(Random().nextInt(balls.length));
      _calcularCaminho(ballColor);
      if (balls.isEmpty) _checkVictory();
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
      currentX = nextX;
      currentY = nextY;
      matrix[currentX][currentY] = true;
      path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    }
  }

  void _checkVictory() {
    int p1Index = widget.selectedLocationsPlayer1.indexWhere((e) => e);
    if (p1Index != -1) {
      int row = p1Index ~/ 4, col = p1Index % 4;
      if (path.any((o) => o.dx.toInt() == row && o.dy.toInt() == col)) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => WinScreen()));
        return;
      }
    }

    int p2Index = widget.selectedLocationsPlayer2.indexWhere((e) => e);
    if (p2Index != -1) {
      int row = p2Index ~/ 4, col = p2Index % 4;
      if (path.any((o) => o.dx.toInt() == row && o.dy.toInt() == col)) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => KillScreen()));
      }
    }
  }

  Widget _buildNavigationButton(
      {required IconData icon, required VoidCallback onPressed}) {
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              // Header (identical to TwoGameScreen)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavigationButton(
                        icon: Icons.info,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameInfoScreen()),
                          );
                        }),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                        icon: Icons.volume_up, onPressed: () {}),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.0),

              // Title
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    'Jogo em andamento',
                    style: TextStyle(
                      color: Color(0xFFF5B51C),
                      fontSize: screenWidth * 0.07,
                      fontFamily: 'Aclonica',
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.0),

              // Game Grid (identical structure)
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05, vertical: 2.0),
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
                      bool isSelectedP1 =
                          widget.selectedLocationsPlayer1[index];
                      bool isSelectedP2 =
                          widget.selectedLocationsPlayer2[index];

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelectedP1
                              ? Color(0xFFF5B51C)
                              : isSelectedP2
                                  ? Color.fromARGB(255, 7, 62, 77)
                                  : matrix[row][col]
                                      ? Colors.indigo[800]
                                      : Color.fromARGB(255, 39, 126, 136),
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(0xFFF5B51C), width: 3),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 30.0),

              // Controls
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: [
                    Text(
                      'Bola Sorteada:',
                      style: TextStyle(
                        color: Color(0xFFF5B51C),
                        fontSize: screenWidth * 0.06,
                        fontFamily: 'Aclonica',
                      ),
                    ),
                    SizedBox(height: 8.0),
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
                            offset: Offset(5, 5),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: balls.isEmpty ? null : _sortearBola,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF3088BE),
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

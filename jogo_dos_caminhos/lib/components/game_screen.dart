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
  Color ballColor = Colors.green;
  List<String> sortedBalls = [];
  // Matriz que marca as células visitadas (movimento do caminho).
  List<List<bool>> matrix = List.generate(4, (_) => List.filled(4, false));
  // Matriz para marcar a célula selecionada na tela anterior.
  List<List<bool>> yellowMatrix = List.generate(4, (_) => List.filled(4, false));
  List<Offset> path = [];
  int currentX = 3; // Linha inicial (de baixo)
  int currentY = 0; // Coluna inicial
  bool? victory; // true se vitória, false se derrota

  @override
  void initState() {
    super.initState();
    // Inicializa o ponto de partida.
    path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    matrix[currentX][currentY] = true;

    // Marca a célula selecionada na primeira tela.
    int selectedIndex = widget.selectedLocations.indexWhere((element) => element);
    if (selectedIndex != -1) {
      int row = selectedIndex ~/ 4;
      int col = selectedIndex % 4;
      yellowMatrix[row][col] = true;
    }
  }

  void _sortearBola() {
    setState(() {
      if (balls.isEmpty) return;

      ballColor = balls.removeAt(Random().nextInt(balls.length));
      String ballType = ballColor == Colors.green ? "Green" : "Red";
      sortedBalls.add(ballType);

      _calcularCaminho(ballColor);

      // Quando não houver mais bolas, verifica vitória.
      if (balls.isEmpty) {
        _checkVictory();
      }
    });
  }

  void _calcularCaminho(Color bola) {
    int nextX = currentX;
    int nextY = currentY;

    if (bola == Colors.green) {
      // Movimento para a direita, se possível.
      if (currentY + 1 < 4 && !matrix[currentX][currentY + 1]) {
        nextY = currentY + 1;
      }
    } else {
      // Movimento para cima, se possível.
      if (currentX - 1 >= 0 && !matrix[currentX - 1][currentY]) {
        nextX = currentX - 1;
      }
    }

    // Atualiza a posição se houver mudança.
    if (nextX != currentX || nextY != currentY) {
      currentX = nextX;
      currentY = nextY;
      matrix[currentX][currentY] = true;
      path.add(Offset(currentX.toDouble(), currentY.toDouble()));
    }
  }

  void _checkVictory() {
  int selectedIndex = widget.selectedLocations.indexWhere((element) => element);
  if (selectedIndex != -1) {
    int row = selectedIndex ~/ 4;
    int col = selectedIndex % 4;

    // Verifica se algum ponto do caminho corresponde à célula selecionada.
    bool win = path.any((offset) => offset.dx.toInt() == row && offset.dy.toInt() == col);
    victory = win;

    // Redireciona para a tela correspondente
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
    // Agora, todos os botões terão o mesmo background, seguindo o padrão da Location.
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
              // Linha de navegação superior.
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
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
              // Título.
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Text(
                  'Jogo em andamento',
                  style: TextStyle(
                    color: const Color(0xFFF5B51C),
                    fontSize: screenWidth * 0.08,
                    fontFamily: 'Aclonica',
                  ),
                ),
              ),
              // Área de jogo: grid de células.
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                        duration: const Duration(milliseconds: 300),
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
              // Informações da bola sorteada.
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                    SizedBox(height: 8.0),
                    Container(
                      width: screenWidth * 0.8,
                      height: screenWidth * 0.2,
                      decoration: BoxDecoration(
                        color: ballColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Botão para sortear bola.
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
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

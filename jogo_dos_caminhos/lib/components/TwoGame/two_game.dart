import 'package:flutter/material.dart';
import 'game_screen_dois.dart';
import '../info_screen.dart';
import 'win_screen.dart';
import 'kill_screen.dart';

class TwoGameScreen extends StatefulWidget {
  const TwoGameScreen({Key? key}) : super(key: key);

  @override
  State<TwoGameScreen> createState() => _TwoGameScreenState();
}

class _TwoGameScreenState extends State<TwoGameScreen> {
  List<bool> selectedLocationsPlayer1 = List.filled(16, false);
  List<bool> selectedLocationsPlayer2 = List.filled(16, false);
  bool isPlayer1Selection = true;
  final List<int> restrictedIndices = [3, 12];

  void _handleLocationSelection(int index) {
    if (restrictedIndices.contains(index)) return;

    setState(() {
      if (isPlayer1Selection) {
        selectedLocationsPlayer1 = List.filled(16, false);
        selectedLocationsPlayer1[index] = true;
      } else {
        selectedLocationsPlayer2 = List.filled(16, false);
        selectedLocationsPlayer2[index] = true;
      }
    });
  }

  void _confirmSelection() {
    if ((isPlayer1Selection && selectedLocationsPlayer1.every((e) => !e)) ||
        (!isPlayer1Selection && selectedLocationsPlayer2.every((e) => !e))) {
      return;
    }

    setState(() {
      if (isPlayer1Selection) {
        isPlayer1Selection = false;
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => GameScreenDois(
              selectedLocationsPlayer1: selectedLocationsPlayer1,
              selectedLocationsPlayer2: selectedLocationsPlayer2,
              onGameFinished: (bool player1Won, bool player2Won) {
                if (player1Won || player2Won) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WinScreen(
                        player1Won: player1Won,
                        player2Won: player2Won,
                      ),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => KillScreen()),
                  );
                }
              },
            ),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
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
    final isVerySmallScreen = screenWidth < 350;
    final isSmallScreen = screenWidth < 375;

    // Tamanho dos círculos mantido como na versão anterior
    double circleSize;
    if (isVerySmallScreen) {
      circleSize = screenWidth * 0.18;
    } else if (isSmallScreen) {
      circleSize = screenWidth * 0.20;
    } else {
      circleSize = screenWidth * 0.22;
    }

    // Espaçamento entre círculos reduzido
    double gridSpacing = isSmallScreen ? screenWidth * 0.02 : screenWidth * 0.025;

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
              // Header compacto
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 8.0 : 12.0,
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
                    SizedBox(width: isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.06),
                    _buildNavigationButton(
                      icon: Icons.volume_up,
                      onPressed: () {},
                    ),
                    SizedBox(width: isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.06),
                    _buildNavigationButton(
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isSmallScreen ? 8.0 : 12.0),

              // Título reduzido
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 4.0 : 8.0),
                child: Center(
                  child: Text(
                    isPlayer1Selection ? 'Jogador 1: Escolha sua posição' : 'Jogador 2: Escolha sua posição',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF5B51C),
                      fontSize: isVerySmallScreen ? screenWidth * 0.05 : 
                               isSmallScreen ? screenWidth * 0.055 : screenWidth * 0.06,
                      fontFamily: 'Aclonica',
                    ),
                  ),
                ),
              ),

              SizedBox(height: isSmallScreen ? 12.0 : 16.0),

              // Tabuleiro com espaçamento reduzido
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? screenWidth * 0.03 : screenWidth * 0.05,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: circleSize * 4 + gridSpacing * 3,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: gridSpacing,
                          mainAxisSpacing: gridSpacing,
                          childAspectRatio: 1,
                        ),
                        itemCount: 16,
                        itemBuilder: (context, index) {
                          bool isSelectedP1 = selectedLocationsPlayer1[index];
                          bool isSelectedP2 = selectedLocationsPlayer2[index];
                          bool isRestricted = restrictedIndices.contains(index);

                          return GestureDetector(
                            onTap: isRestricted ? null : () => _handleLocationSelection(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: isRestricted
                                    ? Colors.grey
                                    : isSelectedP1
                                        ? const Color(0xFFF5B51C)
                                        : isSelectedP2
                                            ? const Color.fromARGB(255, 7, 62, 77)
                                            : const Color.fromARGB(255, 39, 126, 136),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF5B51C),
                                  width: isSmallScreen ? 2 : 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: isSmallScreen ? 4 : 6,
                                    offset: Offset(isSmallScreen ? 2 : 3, isSmallScreen ? 2 : 3),
                                  ),
                                ],
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

              // Rodapé
              Padding(
                padding: EdgeInsets.only(
                  bottom: isSmallScreen ? 12.0 : 16.0,
                  top: isSmallScreen ? 4.0 : 8.0,
                ),
                child: Column(
                  children: [
                    Text(
                      '(Exceto o local de partida e chegada)',
                      style: TextStyle(
                        color: const Color(0xFFF5B51C),
                        fontSize: isVerySmallScreen ? screenWidth * 0.035 : 
                                 isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.045,
                        fontFamily: 'Philosopher',
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12.0 : 16.0),
                    ElevatedButton(
                      onPressed: _confirmSelection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3088BE),
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? screenWidth * 0.1 : screenWidth * 0.12,
                          vertical: isSmallScreen ? 10.0 : 14.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        isPlayer1Selection ? 'Confirmar (Jogador 1)' : 'Iniciar Jogo (Jogador 2)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isVerySmallScreen ? screenWidth * 0.04 : 
                                   isSmallScreen ? screenWidth * 0.045 : screenWidth * 0.05,
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
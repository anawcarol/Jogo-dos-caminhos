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
                    isPlayer1Selection ? 'Jogador 1: Escolha sua posição' : 'Jogador 2: Escolha sua posição',
                    textAlign: TextAlign.center,
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
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: Offset(5, 5),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30.0),

              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
                      child: Text(
                        '(Exceto o local de partida e chegada)',
                        style: TextStyle(
                          color: const Color(0xFFF5B51C),
                          fontSize: screenWidth * 0.045,
                          fontFamily: 'Philosopher',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _confirmSelection,
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
                        isPlayer1Selection ? 'Confirmar (Jogador 1)' : 'Iniciar Jogo (Jogador 2)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05,
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
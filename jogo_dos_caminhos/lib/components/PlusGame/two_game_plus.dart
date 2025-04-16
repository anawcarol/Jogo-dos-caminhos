import 'package:flutter/material.dart';
import '../info_screen.dart';
import 'game_controller_plus.dart';

class TwoGamePlusScreen extends StatefulWidget {
  const TwoGamePlusScreen({Key? key}) : super(key: key);

  @override
  _TwoGamePlusScreenState createState() => _TwoGamePlusScreenState();
}

class _TwoGamePlusScreenState extends State<TwoGamePlusScreen> {
  late final GameControllerPlus _controller;
  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _controller = GameControllerPlus();

    _listener = () {
      if (_controller.phase == Phase.finished) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameResultScreen(
              result: _controller.resultMessage,
              player1Won: _controller.player1Won,
              player2Won: _controller.player2Won,
            ),
          ),
        ).then((_) {
          // Reset game when returning from results screen
          _controller.initRound();
          _controller.phase = Phase.selectDestP1;
          _controller.passedThroughDest = false;
          _controller.player1Won = false;
          _controller.player2Won = false;
          _controller.notifyListeners();
        });
      }
    };
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    _controller.dispose();
    super.dispose();
  }

  Widget _buildNavigationButton({required IconData icon, required VoidCallback onPressed}) {
    final w = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3088BE),
        padding: EdgeInsets.all(w * 0.05),
        shadowColor: Colors.transparent,
        side: const BorderSide(color: Color(0xFFF5B51C), width: 3),
      ),
      child: Icon(icon, size: w * 0.07, color: const Color(0xFFF5B51C)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Container(
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
                  // Header with navigation buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildNavigationButton(
                          icon: Icons.info,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => GameInfoScreen()),
                          ),
                        ),
                        SizedBox(width: w * 0.05),
                        _buildNavigationButton(icon: Icons.volume_up, onPressed: () {}),
                        SizedBox(width: w * 0.05),
                        _buildNavigationButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Game title
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _controller.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFFF5B51C),
                        fontSize: w * 0.07,
                        fontFamily: 'Aclonica',
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Game grid
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: 2),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: w * 0.02,
                          mainAxisSpacing: w * 0.02,
                          childAspectRatio: 1,
                        ),
                        itemCount: 16,
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => _controller.onCellTap(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _controller.cellColor(i),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFF5B51C), width: 3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Confirm button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Column(
                      children: [
                        if (_controller.showConfirm)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: ElevatedButton(
                              onPressed: _controller.confirmSelection,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3088BE),
                                padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                'Confirmar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.05,
                                  fontFamily: 'Aclonica',
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Temporary result screen - replace with your own implementation
class GameResultScreen extends StatelessWidget {
  final String result;
  final bool player1Won;
  final bool player2Won;

  const GameResultScreen({
    Key? key,
    required this.result,
    required this.player1Won,
    required this.player2Won,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF163F58),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result,
              style: const TextStyle(
                color: Color(0xFFF5B51C),
                fontSize: 32,
                fontFamily: 'Aclonica',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              player1Won 
                  ? 'O caminho passou pelo destino escolhido!'
                  : 'O caminho não passou pelo destino!',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3088BE),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text(
                'Voltar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../info_screen.dart';
import 'game_controller_plus.dart';
import 'result_screen.dart'; // Importe a tela de resultados unificada

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
      
      // Mostrar popup se houver mensagem
      if (_controller.popupMsg != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_controller.popupMsg!),
              duration: const Duration(seconds: 2),
            ),
          );
          _controller.clearPopup();
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

  Widget _buildNavigationButton({
    required IconData icon, 
    required VoidCallback onPressed,
    bool isLarger = false,
  }) {
    final w = MediaQuery.of(context).size.width;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3088BE),
        padding: EdgeInsets.all(isLarger ? 30 : w * 0.05),
        side: const BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 50 : w * 0.07,
        color: const Color(0xFFF5B51C),
      ),
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
                    padding: EdgeInsets.symmetric(
                      vertical: 20, 
                      horizontal: w * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildNavigationButton(
                          icon: Icons.info_outline,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GameInfoScreen(),
                            ),
                          ),
                        ),
                        SizedBox(width: w * 0.05),
                        _buildNavigationButton(
                          icon: Icons.volume_up_outlined, 
                          onPressed: () {},
                        ),
                        SizedBox(width: w * 0.05),
                        _buildNavigationButton(
                          icon: Icons.arrow_back,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: w * 0.05),

                  // Game title
                  Padding(
                    padding: EdgeInsets.only(top: w * 0.02),
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

                  SizedBox(height: w * 0.1),

                  // Game grid
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05, 
                        vertical: 2,
                      ),
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
                              border: Border.all(
                                color: const Color(0xFFF5B51C), 
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: w * 0.05),

                  // Confirm button
                  Padding(
                    padding: EdgeInsets.only(bottom: w * 0.1),
                    child: Column(
                      children: [
                        if (_controller.showConfirm)
                          Padding(
                            padding: EdgeInsets.only(top: w * 0.02),
                            child: ElevatedButton(
                              onPressed: _controller.confirmSelection,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3088BE),
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.1, 
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
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
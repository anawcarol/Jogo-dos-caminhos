import 'package:flutter/material.dart';
import 'info_screen.dart';
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
      // Popup entre rodadas
      if (_controller.popupMsg != null) {
        final msg = _controller.popupMsg!;
        _controller.clearPopup();
        Future.microtask(() => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF163F58),
                title: const Text('Fim da 1ª rodada', style: TextStyle(color: Color(0xFFF5B51C))),
                content: Text(msg, style: const TextStyle(color: Colors.white)),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK', style: TextStyle(color: Color(0xFFF5B51C))))
                ],
              ),
            ));
      }

      // Tela de resultado final
      if (_controller.phase == Phase.finished) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => _ResultScreen(
              movesP1: _controller.movesP1,
              movesP2: _controller.movesP2,
            ),
          ),
        );
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
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                        _buildNavigationButton(icon: Icons.arrow_back, onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Title
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

                  const SizedBox(height: 30),

                  // Grid
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

                  const SizedBox(height: 30),

                  // Footer
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        if (_controller.showStepCounter)
                          Text('Passos: ${_controller.currentMoves}',
                              style: TextStyle(color: const Color(0xFFF5B51C), fontSize: w * 0.05, fontFamily: 'Philosopher')),
                        if (_controller.firstRoundMoves != null &&
                            (_controller.phase == Phase.selectDestP2 || _controller.phase == Phase.buildPathP1))
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Jogador 2 precisou de ${_controller.firstRoundMoves} movimentos',
                              style: TextStyle(color: Colors.white, fontSize: w * 0.045),
                            ),
                          ),
                        if (_controller.showConfirm)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: ElevatedButton(
                              onPressed: _controller.confirmSelection,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3088BE),
                                padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text('Confirmar',
                                  style: TextStyle(color: Colors.white, fontSize: w * 0.05, fontFamily: 'Aclonica')),
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

// ------------------------------------------------
// Resultado
// ------------------------------------------------
class _ResultScreen extends StatelessWidget {
  final int movesP1;
  final int movesP2;
  const _ResultScreen({required this.movesP1, required this.movesP2});

  @override
  Widget build(BuildContext context) {
    String msg;
    if (movesP1 < movesP2) {
      msg = 'Jogador 1 venceu!';
    } else if (movesP2 < movesP1) {
      msg = 'Jogador 2 venceu!';
    } else {
      msg = 'Empate!';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF163F58),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(msg, style: const TextStyle(color: Color(0xFFF5B51C), fontSize: 32, fontFamily: 'Aclonica')),
            const SizedBox(height: 16),
            Text('Movimentos J1: $movesP1  |  Movimentos J2: $movesP2',
                style: const TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Voltar')),
          ],
        ),
      ),
    );
  }
}
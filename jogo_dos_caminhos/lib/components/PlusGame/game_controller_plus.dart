import 'package:flutter/material.dart';

enum Phase { selectDestP1, buildPathP2, finished }

class GameControllerPlus extends ChangeNotifier {
  Phase phase = Phase.selectDestP1;
  final List<int> _restricted = [12]; // liberado canto superior direito

  List<bool> destP1 = List.filled(16, false);
  List<List<bool>> visited = List.generate(4, (_) => List.filled(4, false));
  int curX = 3, curY = 0;
  bool passedThroughDest = false; // Nova variável para rastrear se passou pelo destino
  bool player1Won = false;
  bool player2Won = false;
  String resultMessage = '';

  String? popupMsg;

  GameControllerPlus() {
    initRound();
  }

  // ---------- Helpers ----------
  bool _showDestP1() => phase == Phase.selectDestP1;

  // ---------- Getters ----------
  String get title {
    switch (phase) {
      case Phase.selectDestP1:
        return 'Jogador 1: escolha o destino';
      case Phase.buildPathP2:
        return 'Jogador 2: trace o caminho (apenas ↑ e →)';
      default:
        return 'Fim de jogo';
    }
  }

  bool get showConfirm => phase == Phase.selectDestP1;

  Color cellColor(int index) {
    int row = index ~/ 4, col = index % 4;

    if (_showDestP1() && destP1[index]) return const Color(0xFFF5B51C);
    if (visited[row][col]) return Colors.indigo[800]!;
    return const Color.fromARGB(255, 39, 126, 136);
  }

  // ---------- Interactions ----------
  void onCellTap(int index) async {
    if (_restricted.contains(index) || phase == Phase.finished) return;

    int row = index ~/ 4, col = index % 4;

    switch (phase) {
      case Phase.selectDestP1:
        destP1 = List.filled(16, false);
        destP1[index] = true;
        break;
      case Phase.buildPathP2:
        if (_isAdjacent(row, col) && !visited[row][col]) {
          curX = row;
          curY = col;
          visited[row][col] = true;

          if (destP1[index]) {
            passedThroughDest = true;
          }

          if (curX == 0 && curY == 3) {
            phase = Phase.finished;

            // Aguarda 3 segundos antes de definir o resultado.
            await Future.delayed(const Duration(seconds: 3));

            if (passedThroughDest) {
              player1Won = true;
              resultMessage = 'Jogador 1 venceu!';
            } else {
              player2Won = true;
              resultMessage = 'Jogador 2 venceu!';
            }
          }
        }
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void confirmSelection() {
    if (!showConfirm) return;
    if (phase == Phase.selectDestP1 && !destP1.contains(true)) return;
    phase = Phase.buildPathP2;
    initRound();
    notifyListeners();
  }

  // ---------- Internals ----------
  bool _isAdjacent(int r, int c) {
    // Só permite mover para cima (r < curX) ou para a direita (c > curY)
    return (r == curX && c == curY + 1) ||  // Direita
           (r == curX - 1 && c == curY);    // Cima
  }

void initRound() {  // Removi o underscore para tornar público
  visited = List.generate(4, (_) => List.filled(4, false));
  curX = 3;
  curY = 0;
  visited[curX][curY] = true;
  passedThroughDest = false;
}

  // ---------- Popup control ----------
  void clearPopup() {
    popupMsg = null;
    notifyListeners();
  }
}
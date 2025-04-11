import 'package:flutter/material.dart';

enum Phase { selectDestP1, buildPathP2, selectDestP2, buildPathP1, finished }

class GameControllerPlus extends ChangeNotifier {
  Phase phase = Phase.selectDestP1;
  final List<int> _restricted = [12]; // liberado canto superior direito

  List<bool> destP1 = List.filled(16, false);
  List<bool> destP2 = List.filled(16, false);

  List<List<bool>> visited = List.generate(4, (_) => List.filled(4, false));
  int curX = 3, curY = 0;

  int movesP1 = 0;
  int movesP2 = 0;
  int? firstRoundMoves;

  String? popupMsg;

  GameControllerPlus() {
    _initRound();
  }

  // ---------- Helpers ----------
  bool _showDestP1() => phase == Phase.selectDestP1; // só na seleção
  bool _showDestP2() => phase == Phase.selectDestP2;

  // ---------- Getters ----------
  String get title {
    switch (phase) {
      case Phase.selectDestP1:
        return 'Jogador 1: escolha o destino';
      case Phase.buildPathP2:
        return 'Jogador 2: trace o caminho';
      case Phase.selectDestP2:
        return 'Jogador 2: escolha o destino';
      case Phase.buildPathP1:
        return 'Jogador 1: trace o caminho';
      default:
        return '';
    }
  }

  bool get showConfirm => phase == Phase.selectDestP1 || phase == Phase.selectDestP2;
  bool get showStepCounter => phase == Phase.buildPathP1 || phase == Phase.buildPathP2;
  int get currentMoves => phase == Phase.buildPathP2 ? movesP2 : movesP1;

  Color cellColor(int index) {
    int row = index ~/ 4, col = index % 4;

    if (_showDestP1() && destP1[index]) return const Color(0xFFF5B51C);
    if (_showDestP2() && destP2[index]) return const Color.fromARGB(255, 7, 62, 77);
    if (visited[row][col]) return Colors.indigo[800]!;
    return const Color.fromARGB(255, 39, 126, 136);
  }

  // ---------- Interactions ----------
  void onCellTap(int index) {
    if (_restricted.contains(index) || phase == Phase.finished) return;

    int row = index ~/ 4, col = index % 4;

    switch (phase) {
      case Phase.selectDestP1:
        destP1 = List.filled(16, false);
        destP1[index] = true;
        break;
      case Phase.selectDestP2:
        destP2 = List.filled(16, false);
        destP2[index] = true;
        break;
      case Phase.buildPathP2:
      case Phase.buildPathP1:
        if (_isAdjacent(row, col) && !visited[row][col]) {
          curX = row;
          curY = col;
          visited[row][col] = true;
          if (phase == Phase.buildPathP2) {
            movesP2++;
            if (destP1[index]) _advancePhase();
          } else {
            movesP1++;
            if (destP2[index]) _advancePhase();
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
    if (phase == Phase.selectDestP2 && !destP2.contains(true)) return;
    _advancePhase();
    notifyListeners();
  }

  // ---------- Internals ----------
  bool _isAdjacent(int r, int c) =>
      (r == curX && (c - curY).abs() == 1) || (c == curY && (r - curX).abs() == 1);

  void _advancePhase() {
    switch (phase) {
      case Phase.selectDestP1:
        phase = Phase.buildPathP2;
        _initRound();
        break;
      case Phase.buildPathP2:
        firstRoundMoves = movesP2;
        popupMsg = 'Você encontrou a bola adversária em $movesP2 movimentos! Segundo round.';
        phase = Phase.selectDestP2;
        break;
      case Phase.selectDestP2:
        phase = Phase.buildPathP1;
        _initRound();
        break;
      case Phase.buildPathP1:
        phase = Phase.finished;
        break;
      default:
        break;
    }
  }

  void _initRound() {
    visited = List.generate(4, (_) => List.filled(4, false));
    curX = 3;
    curY = 0;
    visited[curX][curY] = true;
    movesP1 = phase == Phase.buildPathP1 ? 0 : movesP1;
    movesP2 = phase == Phase.buildPathP2 ? 0 : movesP2;
  }

  // ---------- Popup control ----------
  void clearPopup() {
    popupMsg = null;
    notifyListeners();
  }
}

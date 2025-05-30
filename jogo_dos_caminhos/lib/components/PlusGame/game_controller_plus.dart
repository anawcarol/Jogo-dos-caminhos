import 'package:flutter/material.dart';

// Define as fases do jogo:
// - selectDestP1: Jogador 1 escolhe o destino
// - buildPathP2: Jogador 2 traça o caminho
// - finished: Fim do jogo
enum Phase { selectDestP1, buildPathP2, finished }

class GameControllerPlus extends ChangeNotifier {
  // Estado inicial do jogo: Jogador 1 escolhe o destino
  Phase phase = Phase.selectDestP1;

  final int startIndex = 12; // Índice correspondente ao ponto de partida (linha 3, coluna 0)
  final int endIndex = 3;    // Índice correspondente ao ponto final obrigatório (linha 0, coluna 3)

  List<bool> destP1 = List.filled(16, false); // Indica qual célula foi escolhida como destino pelo Jogador 1
  List<List<bool>> visited = List.generate(4, (_) => List.filled(4, false)); // Matriz que controla os pontos já visitados pelo Jogador 2
  int curX = 3, curY = 0; // Posição atual do Jogador 2 no tabuleiro (começa em (3,0))
  bool passedThroughDest = false; // Indica se o jogador 2 passou pelo destino definido pelo jogador 1
  bool player1Won = false; // Indica se o jogador 1 venceu
  bool player2Won = false; // Indica se o jogador 2 venceu
  String resultMessage = ''; // Mensagem final de resultado
  String? popupMsg; // Mensagem temporária de erro ou aviso (exibida em pop-up)
  bool showChosenDest = false;

  GameControllerPlus() {
    initRound(); // Inicializa a primeira rodada
  }

  // ---------- Funções auxiliares ----------

  // Retorna verdadeiro se for a vez do Jogador 1 escolher o destino
  bool _showDestP1() => phase == Phase.selectDestP1;

  // Determina se uma célula está bloqueada para seleção durante a escolha do destino
  bool _isRestrictedDuringSelection(int index) => 
      _showDestP1() && (index == startIndex || index == endIndex);

  // ---------- Getters ----------

  // Define o título mostrado no topo da interface baseado na fase atual
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

  // Define se o botão "Confirmar" deve ser exibido
  bool get showConfirm => phase == Phase.selectDestP1;

  // Retorna o índice do destino escolhido pelo Jogador 1
  int get chosenDestIndex => destP1.indexWhere((e) => e);

  // Define a cor de uma célula com base no seu estado
  Color cellColor(int index) {
  int row = index ~/ 4, col = index % 4;

  if (_isRestrictedDuringSelection(index)) return Colors.grey;
  
  // Destaca o destino escolhido pelo jogador 1 no final
  if (showChosenDest && destP1[index]) {
    return Colors.orange; // Cor mais vibrante para destaque
  }
  
  if (_showDestP1() && destP1[index]) return const Color(0xFFF5B51C);
  if (visited[row][col]) return Colors.indigo[800]!;
  return const Color.fromARGB(255, 39, 126, 136);
}

  // ---------- Interações do usuário ----------

  // Ação ao clicar em uma célula do tabuleiro
 void onCellTap(int index) async {
  if (_isRestrictedDuringSelection(index)) {
    popupMsg = 'Esta posição não pode ser selecionada como destino';
    notifyListeners();
    return;
  }

  if (phase == Phase.finished) return;

  int row = index ~/ 4, col = index % 4;

  switch (phase) {
    case Phase.selectDestP1:
      destP1 = List.filled(16, false);
      destP1[index] = true;
      break;
    case Phase.buildPathP2:
      if (_isValidMove(row, col)) {
        visited[row][col] = true;
        curX = row;
        curY = col;

        if (destP1[index]) {
          passedThroughDest = true;
        }

        if (curX == 0 && curY == 3) {
          visited[curX][curY] = true;
          notifyListeners();
          
          // Mostra o destino escolhido pelo jogador 1
          showChosenDest = true;
          notifyListeners();
          
          await Future.delayed(const Duration(seconds: 2)); // Tempo para visualização
          
          phase = Phase.finished;
          showChosenDest = false;
          notifyListeners();
          
          await Future.delayed(const Duration(milliseconds: 300));
          
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

  // Confirma a escolha do Jogador 1 e passa para a próxima fase
  void confirmSelection() {
    // Garante que o botão só funcione se for o momento correto
    if (!showConfirm) return;

    // Impede continuar sem escolher destino
    if (phase == Phase.selectDestP1 && !destP1.contains(true)) {
      popupMsg = 'Selecione um destino antes de confirmar';
      notifyListeners();
      return;
    }

    // Avança para a fase do Jogador 2
    phase = Phase.buildPathP2;
    initRound(); // Reinicia variáveis do jogador 2
    notifyListeners();
  }

  // ---------- Funções internas ----------

  // Verifica se o movimento feito é válido (apenas para cima ou para a direita e não visitado)
  bool _isValidMove(int r, int c) {
    bool isAdjacent = (r == curX && c == curY + 1) ||  // Movimento para a direita
                      (r == curX - 1 && c == curY);    // Movimento para cima

    return isAdjacent && !visited[r][c];
  }

  // Reinicia as variáveis relacionadas ao percurso do jogador 2
  void initRound() {
    visited = List.generate(4, (_) => List.filled(4, false)); // Limpa histórico de visitas
    curX = 3;
    curY = 0;
    visited[curX][curY] = true; // Marca o ponto inicial como visitado
    passedThroughDest = false; // Reseta flag de passagem pelo destino
  }

  // Limpa a mensagem de pop-up da tela
  void clearPopup() {
    popupMsg = null;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'game_screen.dart'; // Importa a tela do jogo para navegação.

class LocationSelectionScreen extends StatefulWidget {
  // Declaração de uma tela com estado mutável (StatefulWidget).
  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState(); // Cria o estado associado ao widget.
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  // Define o estado da tela.

  // Lista de locais selecionados. Inicialmente, todos estão desmarcados (false).
  List<bool> selectedLocations = List.generate(16, (index) => false);

  // Índices de locais restritos (não interativos), representando "1D" e "4A".
  final List<int> restrictedIndices = [3, 12];

  @override
  Widget build(BuildContext context) {
    // Recupera a altura e a largura da tela para calcular dimensões responsivas.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Scaffold fornece a estrutura básica para a tela, como fundo e layout.
      body: Container(
        // Container principal com um gradiente de fundo.
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF163F58), Color(0xFF3088BE)], // Cores do gradiente.
            stops: [0.3, 1.0], // Posição das cores no gradiente.
            begin: Alignment.topLeft, // Início do gradiente.
            end: Alignment.bottomRight, // Final do gradiente.
          ),
        ),
        child: SafeArea(
          // Garante que o conteúdo não seja exibido sob áreas seguras, como o notch.
          child: Column(
            // Disposição vertical dos widgets.
            children: [
              // Botões superiores de navegação.
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.06, // Espaçamento vertical.
                  horizontal: screenWidth * 0.02, // Espaçamento horizontal.
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Centraliza os botões.
                  children: [
                    _buildNavigationButton(
                      // Botão de informações.
                      icon: Icons.info,
                      onPressed: () {
                        // Função a ser executada ao pressionar (a ser implementada).
                      },
                    ),
                    SizedBox(width: screenWidth * 0.05), // Espaçamento horizontal.
                    _buildNavigationButton(
                      // Botão de som.
                      icon: Icons.volume_up,
                      onPressed: () {
                        // Função para alternar som (a ser implementada).
                      },
                    ),
                    SizedBox(width: screenWidth * 0.05), // Espaçamento horizontal.
                    _buildNavigationButton(
                      // Botão de avançar.
                      icon: Icons.arrow_forward,
                      onPressed: selectedLocations.any((selected) => selected)
                          // Só avança se algum local estiver selecionado.
                          ? () {
                              // Navega para a tela de jogo, passando os locais selecionados.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(
                                    selectedLocations: selectedLocations,
                                  ),
                                ),
                              );
                            }
                          : () {}, // Faz nada se nenhum local estiver selecionado.
                    ),
                  ],
                ),
              ),

              // Título da página.
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Text(
                  'Escolha um local!', // Texto do título.
                  style: TextStyle(
                    color: const Color(0xFFF5B51C), // Cor do texto.
                    fontSize: screenWidth * 0.08, // Tamanho do texto.
                    fontFamily: 'Aclonica', // Fonte personalizada.
                  ),
                ),
              ),

              // Grade de locais (16 no total).
              Expanded(
                // O grid ocupa o restante do espaço vertical disponível.
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: GridView.builder(
                    // Constrói a grade dinamicamente.
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 colunas.
                      crossAxisSpacing: screenWidth * 0.02, // Espaçamento horizontal.
                      mainAxisSpacing: screenHeight * 0.02, // Espaçamento vertical.
                    ),
                    itemCount: 16, // Total de locais.
                    itemBuilder: (context, index) {
                      bool isRestricted =
                          restrictedIndices.contains(index); // Verifica se é restrito.

                      return GestureDetector(
                        // Detecta interações do usuário.
                        onTap: isRestricted
                            ? null // Se for restrito, não faz nada.
                            : () {
                                setState(() {
                                  // Atualiza o estado para marcar apenas o local atual.
                                  for (int i = 0;
                                      i < selectedLocations.length;
                                      i++) {
                                    selectedLocations[i] = i == index;
                                  }
                                });
                              },
                        child: AnimatedContainer(
                          // Container animado para mudanças visuais suaves.
                          duration: const Duration(milliseconds: 300), // Duração da animação.
                          decoration: BoxDecoration(
                            // Aparência do local.
                            color: selectedLocations[index]
                                ? Colors.green // Verde se selecionado.
                                : (isRestricted
                                    ? Colors.grey // Cinza se restrito.
                                    : Colors.black), // Preto por padrão.
                            shape: BoxShape.circle, // Forma circular.
                            border: Border.all(
                                color: const Color(0xFFF5B51C), width: 3), // Borda dourada.
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(
      {required IconData icon, required VoidCallback onPressed}) {
    // Constrói um botão circular de navegação.
    final screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed, // Função ao pressionar.
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), // Forma circular.
        backgroundColor: const Color(0xFF3088BE), // Cor de fundo.
        padding: EdgeInsets.all(screenWidth * 0.05), // Espaçamento interno.
        shadowColor: Colors.transparent, // Sem sombra.
        side: const BorderSide(
          // Borda dourada.
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon, // Ícone do botão.
        size: screenWidth * 0.07, // Tamanho do ícone.
        color: const Color(0xFFF5B51C), // Cor do ícone.
      ),
    );
  }
}

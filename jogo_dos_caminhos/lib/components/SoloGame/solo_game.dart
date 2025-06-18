import 'package:flutter/material.dart';
import 'game_screen.dart'; // Importa a tela do jogo para navegação.
import 'package:jogo_dos_caminhos/components/info_screen.dart';

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  // Lista que armazena quais células estão selecionadas (apenas uma pode ser selecionada por vez).
  List<bool> selectedLocations = List.generate(16, (index) => false);

  // Índices das células que são restritas (não podem ser selecionadas).
  final List<int> restrictedIndices = [3, 12];

  @override
  Widget build(BuildContext context) {
    // Obtém as dimensões da tela para calcular tamanhos responsivos.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        // Fundo com gradiente.
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
              // Botões de navegação superiores.
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.03, // Reduzido de 0.06 para 0.03.
                  horizontal: screenWidth * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botão para abrir a tela de informações.
                    _buildNavigationButton(
                      icon: Icons.info,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GameInfoScreen()),
                        );
                      },
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    // Botão para controle de volume (ainda não implementado).
                    _buildNavigationButton(
                      icon: Icons.volume_up,
                      onPressed: () {},
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    // Botão para avançar para a próxima tela (habilitado apenas se uma célula for selecionada).
                    _buildNavigationButton(
                      icon: Icons.arrow_forward,
                      onPressed: selectedLocations.any((selected) => selected)
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GameScreen(
                                    selectedLocations: selectedLocations,
                                  ),
                                ),
                              );
                            }
                          : () {
                              // Exibe uma mensagem se nenhuma célula for selecionada.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Selecione um local antes de prosseguir!")),
                              );
                            },
                    ),
                  ],
                ),
              ),
              // Título da tela.
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.002),
                child: Text(
                  'Escolha um local!',
                  style: TextStyle(
                    color: const Color(0xFFF5B51C),
                    fontSize: screenWidth * 0.08,
                    fontFamily: 'Aclonica',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              // Grade de seleção de locais.
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Número de colunas na grade.
                      crossAxisSpacing: screenWidth * 0.02, // Espaçamento horizontal.
                      mainAxisSpacing: screenHeight * 0.02, // Espaçamento vertical.
                    ),
                    itemCount: 16, // Total de células na grade.
                    itemBuilder: (context, index) {
                      // Verifica se o índice atual é restrito.
                      bool isRestricted = restrictedIndices.contains(index);
                      return GestureDetector(
                        onTap: isRestricted
                            ? null // Células restritas não podem ser tocadas.
                            : () {
                                setState(() {
                                  // Atualiza a seleção para que apenas uma célula seja selecionada.
                                  for (int i = 0; i < selectedLocations.length; i++) {
                                    selectedLocations[i] = i == index;
                                  }
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300), // Animação suave ao selecionar.
                          decoration: BoxDecoration(
                            color: selectedLocations[index]
                                ? Colors.yellow // Célula selecionada fica amarela.
                                : (isRestricted
                                    ? Colors.grey // Células restritas ficam cinzas.
                                    : const Color.fromARGB(255, 39, 126, 136)), // Células normais.
                            shape: BoxShape.circle, // Formato circular das células.
                            border: Border.all(
                              color: const Color(0xFFF5B51C), // Cor da borda.
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Texto explicativo abaixo da grade.
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Text(
                  '(Exceto o local de partida e chegada)',
                  style: TextStyle(
                    color: const Color(0xFFF5B51C),
                    fontSize: screenWidth * 0.04,
                    fontFamily: 'Aclonica',
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Ícones na parte inferior da tela.
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícone do jogador.
                    Flexible(
                      flex: 2,
                      child: Icon(
                        Icons.person,
                        size: screenWidth * 0.10,
                        color: const Color(0xFF163F58),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    // Imagem central.
                    Flexible(
                      flex: 3,
                      child: Image.asset(
                        'assets/imagens/image_vs.png',
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.08,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    // Ícone do oponente.
                    Flexible(
                      flex: 2,
                      child: Icon(
                        Icons.smart_toy,
                        size: screenWidth * 0.10,
                        color: const Color(0xFF163F58),
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

  // Método auxiliar para criar botões de navegação circulares.
  Widget _buildNavigationButton({required IconData icon, required VoidCallback onPressed}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(), // Formato circular.
        backgroundColor: const Color(0xFF3088BE), // Cor de fundo.
        padding: EdgeInsets.all(screenWidth * 0.07), // Espaçamento interno.
        shadowColor: Colors.transparent, // Sem sombra.
        side: const BorderSide(
          color: Color(0xFFF5B51C), // Cor da borda.
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: screenWidth * 0.07, // Tamanho do ícone.
        color: const Color(0xFFF5B51C), // Cor do ícone.
      ),
    );
  }
}

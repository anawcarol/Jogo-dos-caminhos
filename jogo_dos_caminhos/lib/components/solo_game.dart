import 'package:flutter/material.dart';
import 'game_screen.dart'; // Importa a tela do jogo para navegação.
import 'package:jogo_dos_caminhos/components/info_screen.dart';

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  // Guarda qual célula foi selecionada (única seleção).
  List<bool> selectedLocations = List.generate(16, (index) => false);
  final List<int> restrictedIndices = [3, 12];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
              // Botões de navegação superiores.
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.06,
                  horizontal: screenWidth * 0.02,
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
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      icon: Icons.volume_up,
                      onPressed: () {},
                    ),
                    SizedBox(width: screenWidth * 0.05),
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
                              // Se nenhum local for selecionado, mostra um feedback.
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Selecione um local antes de prosseguir!")),
                              );
                            },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: screenWidth * 0.02,
                      mainAxisSpacing: screenHeight * 0.02,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                      bool isRestricted = restrictedIndices.contains(index);
                      return GestureDetector(
                        onTap: isRestricted
                            ? null
                            : () {
                                setState(() {
                                  // Seleciona apenas o índice tocado.
                                  for (int i = 0; i < selectedLocations.length; i++) {
                                    selectedLocations[i] = i == index;
                                  }
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: selectedLocations[index]
                                ? Colors.yellow // Seleção fica em amarelo.
                                : (isRestricted
                                    ? Colors.grey
                                    : const Color.fromARGB(255, 39, 126, 136)),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFF5B51C),
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
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
                    Flexible(
                      flex: 2,
                      child: Icon(
                        Icons.person,
                        size: screenWidth * 0.10,
                        color: const Color(0xFF163F58),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
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

  Widget _buildNavigationButton({required IconData icon, required VoidCallback onPressed}) {
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
}

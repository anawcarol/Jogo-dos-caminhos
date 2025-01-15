import 'package:flutter/material.dart';
import 'game_screen.dart'; // Importa a tela de jogo

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() =>
      _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  // Placeholder for selected locations (initially all false)
  List<bool> selectedLocations = List.generate(16, (index) => false);

  // Indices para "1D" e "4A"
  final List<int> restrictedIndices = [3, 12]; // 1D = 3, 4A = 12

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
              // Top buttons
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.03,
                  horizontal: screenWidth * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildNavigationButton(
                      icon: Icons.info,
                      onPressed: () {
                        // Handle info action
                      },
                    ),
                    SizedBox(width: screenWidth * 0.05),
                    _buildNavigationButton(
                      icon: Icons.volume_up,
                      onPressed: () {
                        // Handle sound toggle
                      },
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
                          : () {}, // Função vazia no caso de nenhuma seleção
                    ),
                  ],
                ),
              ),

              // Title
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

              // Grid of locations
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: screenWidth * 0.02,
                      mainAxisSpacing: screenHeight * 0.02,
                    ),
                    itemCount: 16, // Number of locations
                    itemBuilder: (context, index) {
                      bool isRestricted = restrictedIndices.contains(index);

                      return GestureDetector(
                        onTap: isRestricted
                            ? null // Disable interaction for restricted locations
                            : () {
                                setState(() {
                                  // Ensure only one location is selected
                                  for (int i = 0;
                                      i < selectedLocations.length;
                                      i++) {
                                    selectedLocations[i] = i == index;
                                  }
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: selectedLocations[index]
                                ? Colors.green
                                : (isRestricted ? Colors.grey : Colors.black),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFF5B51C), width: 3),
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

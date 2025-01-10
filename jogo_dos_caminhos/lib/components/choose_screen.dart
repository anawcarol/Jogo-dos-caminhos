import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'rules_bot.dart';
import 'rules_pvp.dart';

class GameModeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            // Conteúdo principal
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Botão de voltar no topo
                Padding(
                  padding:
                      EdgeInsets.all(screenWidth * 0.04), // 4% da largura da tela
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Color(0xFF3088BE),
                        padding:
                            EdgeInsets.all(screenWidth * 0.05), // 5% da largura
                        shadowColor: Colors.transparent,
                        side: BorderSide(
                          color: Color(0xFFF5B51C),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_outlined,
                        size: screenWidth * 0.07, // Ícone proporcional
                        color: Color(0xFFF5B51C),
                      ),
                    ),
                  ),
                ),

                // Texto centralizado
                Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                  child: Text(
                    'Escolha o modo de jogar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08, // 8% da largura da tela
                      fontFamily: 'Aclonica',
                      color: Color(0xFFF5B51C),
                    ),
                  ),
                ),

                // Botão Jogador vs Jogador
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HowToPlayPvPScreen()),
                      ); // Lógica para iniciar o modo jogador vs jogador
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5B51C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person,
                            size: screenWidth * 0.15, color: Color(0xFF257F98)),
                        SizedBox(
                            width: screenWidth * 0.02), // Espaçamento entre os ícones
                        Image.asset('assets/imagens/image_vs.png'),
                        SizedBox(width: screenWidth * 0.02),
                        Icon(Icons.person,
                            size: screenWidth * 0.15, color: Color(0xFF257F98)),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                    height: screenHeight * 0.02), // Espaçamento entre os botões

                // Botão Jogador vs Máquina
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HowToPlayScreen()),
                      ); // Lógica para iniciar o modo jogador vs máquina
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF5B51C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person,
                            size: screenWidth * 0.15, color: Color(0xFF257F98)),
                        SizedBox(width: screenWidth * 0.02),
                        Image.asset('assets/imagens/image_vs.png'),
                        SizedBox(width: screenWidth * 0.02),
                        Icon(Icons.smart_toy,
                            size: screenWidth * 0.15, color: Color(0xFF257F98)),
                      ],
                    ),
                  ),
                ),

                Spacer(), // Adiciona espaço no final para centralizar melhor
              ],
            ),

            // Botão de volume no canto superior direito
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: ElevatedButton(
                  onPressed: () {
                    // Lógica para som
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Color(0xFF3088BE),
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    shadowColor: Colors.transparent,
                    side: BorderSide(
                      color: Color(0xFFF5B51C),
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.volume_up_outlined,
                    size: screenWidth * 0.07,
                    color: Color(0xFFF5B51C),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

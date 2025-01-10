import 'package:flutter/material.dart';
import 'choose_screen.dart'; // Importando a tela GameModeScreen

class HowToPlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: double.infinity, // Garantir que o container ocupe toda a altura
        width: double.infinity, // Garantir que o container ocupe toda a largura
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF163F58),
              Color(0xFF3088BE),
            ],
            stops: [0.3, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botões de navegação superior
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.04), // Ajustando as margens
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Alinha no centro
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navegar para a tela GameModeScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameModeScreen(),
                          ),
                        );
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
                        Icons.arrow_back_outlined,
                        size: screenWidth * 0.07,
                        color: Color(0xFFF5B51C),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.05), // Espaço entre os botões
                    ElevatedButton(
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
                    SizedBox(width: screenWidth * 0.05), // Espaço entre o botão de som e a seta
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para ir para a próxima tela
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
                        Icons.arrow_forward_outlined, // Seta para a direita
                        size: screenWidth * 0.07,
                        color: Color(0xFFF5B51C),
                      ),
                    ),
                  ],
                ),
              ),

              // Título "How to play!"
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03), // Margem uniforme
                child: Text(
                  'Como jogar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontFamily: 'Aclonica',
                    color: Color(0xFFF5B51C),
                  ),
                ),
              ),

              // Conteúdo das instruções
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.05), // Margem uniforme
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Color(0xFF257F98),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFFF5B51C),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '• O caminho partirá da casa para a faculdade',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        '• O jogador escolherá um local (exceto a casa e a faculdade)',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        '• O jogo possui 4 bolas verdes e 4 bolas vermelhas. A cada rodada será sorteado, uma única vez, uma bola diferente, sendo:',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• Bola verde: Seguirá o caminho para cima',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              '• Bola vermelha: Seguirá o caminho para a direita',
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ícones "Jogador vs Máquina"
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03), // Margem uniforme
                child: Align(
                  alignment: Alignment.topCenter, // Ajusta a posição para cima
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: screenWidth * 0.12, // Ícone menor
                        color: Color(0xFF163F58),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Image.asset(
                        'assets/imagens/image_vs.png',
                        width: screenWidth * 0.2, // Imagem maior
                        height: screenWidth * 0.2, // Imagem maior
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Icon(
                        Icons.smart_toy,
                        size: screenWidth * 0.12, // Ícone menor
                        color: Color(0xFF163F58),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

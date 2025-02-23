import 'package:flutter/material.dart';
import 'package:jogo_dos_caminhos/components/home_screen.dart';

class GameInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtém as dimensões da tela para um layout responsivo.
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF163F58),
              Color(0xFF3088BE)
            ], // Cores do gradiente.
            stops: [0.3, 1.0], // Posição das cores no gradiente.
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Botões superiores (Home e Som).
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.05,  // Mesmo padding vertical
                  horizontal: screenWidth * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildCircularButton(
                      icon: Icons.home,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeScreen()));
                        // lógica para botão
                      },
                    ),
                    SizedBox(width: screenWidth * 0.06),
                    _buildCircularButton(
                      icon: Icons.volume_up,
                      onPressed: () {
                        // Alternar som (implementar).
                      },
                    ),
                  ],
                ),
              ),

              // Caixa de informações.
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                padding: EdgeInsets.all(screenWidth * 0.08),
                decoration: BoxDecoration(
                  color: const Color(0xFF22577A), // Cor do fundo da caixa.
                  borderRadius:
                      BorderRadius.circular(12), // Cantos arredondados.
                  border: Border.all(
                    color: const Color(0xFFF5B51C), // Cor da borda.
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informações do jogo:', // Título da seção.
                      style: TextStyle(
                        color: const Color(0xFFF5B51C),
                        fontSize: screenWidth * 0.08,
                        fontFamily: 'Aclonica',
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Lista de informações.
                    _buildInfoItem('Professor orientador'),
                    _buildInfoItem(
                        'Onde acessar a tese que explique matematicamente a primícia do jogo'),
                    _buildInfoItem('Desenvolvedores do projeto'),
                    _buildInfoItem('Acesso ao repositório do GitHub'),
                  ],
                ),
              ),

              // Espaçamento maior antes do botão inferior
              SizedBox(height: screenHeight * 0.1),

              // Botão inferior (Voltar) com maior tamanho.
              _buildCircularButton(
                icon: Icons.arrow_back,
                onPressed: () {
                  Navigator.pop(context);// Volta para a tela anterior.
                },
                isLarger: true,  // Passando um parâmetro para tornar o botão maior.
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Constrói um botão circular.
  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isLarger = false,  // Parâmetro para controlar o tamanho.
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3088BE),
        padding: EdgeInsets.all(isLarger ? 30 : 20), // Ajusta o tamanho do padding
        side: const BorderSide(
          color: Color(0xFFF5B51C), // Borda dourada.
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 45 : 35,  // Ajusta o tamanho do ícone.
        color: const Color(0xFFF5B51C),
      ),
    );
  }

  // Constrói um item de informação.
  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            size: 10,
            color: Color(0xFFF5B51C), // Ícone dourado para bullets.
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

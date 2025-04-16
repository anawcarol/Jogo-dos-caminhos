import 'package:flutter/material.dart';
import '../home_screen.dart';
import '../info_screen.dart';
import 'two_game.dart';

class KillScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCircularButton(
                    icon: Icons.info_outline,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GameInfoScreen()),
                      );
                    },
                  ),
                  SizedBox(width: screenWidth * 0.05),
                  _buildCircularButton(
                    icon: Icons.volume_up_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.05),

            Text(
              'Tente Novamente!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.09, // Reduced font size
                fontFamily: 'Aclonica',
                color: Color(0xFFF5B51C),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Image.asset(
              'assets/imagens/image.png',
              width: screenWidth * 0.8,
              height: screenHeight * 0.5,
              fit: BoxFit.contain,
            ),

            SizedBox(height: screenHeight * 0.02),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularButton(
                  icon: Icons.home,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  isLarger: true,
                ),
                SizedBox(width: screenWidth * 0.05),
                _buildCircularButton(
                  icon: Icons.refresh,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TwoGameScreen()),
                    );
                  },
                  isLarger: true,
                ),
              ],
            ),

            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isLarger = false,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape: CircleBorder(),
        backgroundColor: Color(0xFF3088BE),
        padding: EdgeInsets.all(isLarger ? 30 : 15),
        side: BorderSide(
          color: Color(0xFFF5B51C),
          width: 3,
        ),
      ),
      child: Icon(
        icon,
        size: isLarger ? 50 : 30,
        color: Color(0xFFF5B51C),
      ),
    );
  }
}
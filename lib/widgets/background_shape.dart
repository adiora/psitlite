import 'package:flutter/material.dart';

class BackgroundShape extends StatelessWidget {
  const BackgroundShape({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final circleColor1 = isDark
        ? Colors.blueGrey.shade900
        : Colors.blue.shade100;
    final circleColor2 = isDark
        ? Colors.blueGrey.shade800
        : Colors.blue.shade50;
    final squareColor = isDark ? Colors.blueGrey.shade700 : Colors.blue.shade50;
    final triangleColor = isDark
        ? Colors.blueGrey.shade800
        : Colors.blue.shade50;

    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -100,
          child: CircleAvatar(radius: 150, backgroundColor: circleColor1),
        ),
        Positioned(
          bottom: -80,
          right: -80,
          child: CircleAvatar(radius: 135, backgroundColor: circleColor2),
        ),
        Positioned(
          top: 120,
          right: -30,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: squareColor,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        Positioned(
          top: 300,
          left: -25,
          child: Container(
            transform: Matrix4.rotationZ(0.9),
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: triangleColor,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ],
    );
  }
}

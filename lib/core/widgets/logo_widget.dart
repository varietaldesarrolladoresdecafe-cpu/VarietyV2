import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final double circleBorderWidth;

  const LogoWidget({
    super.key,
    this.size = 80,
    this.circleBorderWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size - (circleBorderWidth * 2),
          height: size - (circleBorderWidth * 2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo2.png',
              width: size * 0.75,
              height: size * 0.75,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.coffee,
                  size: size * 0.6,
                  color: Colors.white,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}




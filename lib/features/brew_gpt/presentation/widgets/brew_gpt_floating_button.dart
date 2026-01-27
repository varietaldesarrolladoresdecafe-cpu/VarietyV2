import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BrewGPTFloatingButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const BrewGPTFloatingButton({
    super.key,
    this.onPressed,
  });

  @override
  State<BrewGPTFloatingButton> createState() => _BrewGPTFloatingButtonState();
}

class _BrewGPTFloatingButtonState extends State<BrewGPTFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Auto-play animation on load
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: widget.onPressed,
        backgroundColor: AppColors.secondary,
        elevation: 6,
        label: const Text(
          'BrewGPT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        icon: const Icon(
          Icons.smart_toy,
          color: Colors.white,
        ),
      ),
    );
  }
}

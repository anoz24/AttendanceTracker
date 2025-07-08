import 'package:flutter/material.dart';
import '../../utils/report_helper_methods.dart';

class ReportAnimatedValue extends StatelessWidget {
  const ReportAnimatedValue({
    super.key,
    required this.currentValue,
    required this.currentNumericValue,
    required this.previousNumericValue,
    required this.style,
    required this.animation,
    this.baseColor,
  });

  final String currentValue;
  final num currentNumericValue;
  final num previousNumericValue;
  final TextStyle? style;
  final Animation<double> animation;
  final Color? baseColor;

  @override
  Widget build(BuildContext context) {
    final isIncreasing = ReportHelper.isValueIncreasing(currentNumericValue, previousNumericValue);
    final isDecreasing = ReportHelper.isValueDecreasing(currentNumericValue, previousNumericValue);
    
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Always use the base color as the primary color
        Color textColor = baseColor ?? style?.color ?? Theme.of(context).colorScheme.onSurface;
        
        // Apply very subtle animation effects without changing the main color
        double opacity = 1.0;
        if (isIncreasing || isDecreasing) {
          opacity = (0.7 + (animation.value * 0.3)).clamp(0.0, 1.0); // Ensure valid range
        }

        return Transform.scale(
          scale: 1.0 + (animation.value * 0.03), // Very subtle scale effect
          child: Opacity(
            opacity: opacity,
            child: Text(
              currentValue,
              style: style?.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
} 
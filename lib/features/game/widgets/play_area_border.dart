import 'package:flutter/material.dart';
import 'package:snake/core/theme.dart';

class PlayAreaBorder extends StatelessWidget {
  final int lowerBoundX;
  final int lowerBoundY;
  final int upperBoundX;
  final int upperBoundY;
  final int step;

  const PlayAreaBorder({
    Key? key, 
    required this.lowerBoundY, 
    required this.lowerBoundX, 
    required this.upperBoundX, 
    required this.upperBoundY, 
    required this.step}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: lowerBoundY.toDouble(),
      left: lowerBoundX.toDouble(),
      child: Container(
        width: (upperBoundX - lowerBoundX + step).toDouble(),
        height: (upperBoundY - lowerBoundY + step).toDouble(),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.white.withOpacity(AppOpacities.fieldBorder),
            style: BorderStyle.solid,
            width: AppSizes.fieldBorder,
          ),
        ),
      ),
    );
  }
}
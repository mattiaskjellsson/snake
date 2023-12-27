import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:snake/core/theme.dart';

class Score extends StatelessWidget {
  final int score;
  const Score({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSizes.scoreTopOffset,
      right: AppSizes.scoreRightOffset,
      child: Text(
        AppLocalizations.of(context)!.score(score),
        style: TextStyle(
          fontSize: AppSizes.scoreText,
          color: AppColors.white.withOpacity(AppOpacities.semi),
        ),
      ),
    );
  }
}
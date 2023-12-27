import 'package:flutter/material.dart';
import 'package:snake/core/theme.dart';
import 'package:snake/features/game/game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: AppSizes.mainMenuTopOffset),
            Image.asset(
              'assets/snake_icon.png',
              width: AppSizes.menuImageWidth,
              height: AppSizes.menuImageHeight,
              fit: BoxFit.contain,
            ),
            Text(
              AppLocalizations.of(context)!.game_title, 
              style: TextStyle(
                color: AppColors.snake,
                fontSize: AppSizes.gameTitle,
                shadows: [Shadow(color: AppColors.shadow, offset: Offset(2, 2))],
                letterSpacing: AppSizes.gameTitleSpacing,
                decoration: TextDecoration.combine([TextDecoration.underline, TextDecoration.overline]),
                decorationColor: AppColors.snake,
              )
            ),
            Expanded(child: Container(),),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GamePage())
                );
              }, 
              child: Text(
                AppLocalizations.of(context)!.new_game,
                style: TextStyle(
                  color: AppColors.white,
                ),
              )
            ),
            Expanded(child: Container(),),
          ]
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:snake/core/theme.dart';
import 'package:snake/features/game/game.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: AppSizes.mainMenuTopOffset),
            Text(AppLocalizations.of(context)!.game_title),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => GamePage())
                );
              }, 
              child: Text(AppLocalizations.of(context)!.new_game)
            ),
          ]
        ),
      ),
    );
  }
}

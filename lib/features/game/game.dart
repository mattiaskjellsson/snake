import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:snake/core/direction.dart';
import 'package:snake/core/direction_type.dart';
import 'package:snake/core/theme.dart';
import 'package:snake/features/game/widgets/control_panel.dart';
import 'package:snake/features/game/widgets/piece.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<Offset> positions = [];
  int length = AppConstants.initialLength;
  int step = AppConstants.step;
  Direction direction = Direction.right;

  Piece? food;
  Offset? foodPosition;

  double? screenWidth;
  double? screenHeight;
  int? lowerBoundX, upperBoundX, lowerBoundY, upperBoundY;

  Timer? timer;
  double speed = AppConstants.initialSpeed;

  int score = 0;

  void draw() async {
    if (positions.length == 0) {
      positions.add(getRandomPositionWithinRange());
    }

    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }

    for (int i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }

    positions[0] = await getNextPosition(positions[0]);
  }

  Direction getRandomDirection([DirectionType? type]) {
    if (type == DirectionType.horizontal) {
      return Random().nextBool() ? Direction.right: Direction.left;
    } else if (type == DirectionType.vertical) {
      return Random().nextBool() ? Direction.up: Direction.down;
    } else {
      return Direction.values[Random().nextInt(4)];
    }
  }

  Offset getRandomPositionWithinRange() {
    int posX = Random().nextInt(upperBoundX!) + lowerBoundX!;
    int posY = Random().nextInt(upperBoundY!) + lowerBoundY!;
    return Offset(roundToNearestTens(posX).toDouble(), roundToNearestTens(posY).toDouble());
  }

  bool detectCollision(Offset position) {
    if (position.dx >= upperBoundX! && direction == Direction.right) {
      return true;
    } else if (position.dx <= lowerBoundX! && direction == Direction.left) {
      return true;
    } else if (position.dy >= upperBoundY! && direction == Direction.down) {
      return true;
    } else if (position.dy <= lowerBoundY! && direction == Direction.up) {
      return true;
    }

    return false;
  }

  void showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.gameOverBackground,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: AppColors.gameOverBorder,
                width: AppSizes.gameOverBorder,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            AppLocalizations.of(context)!.game_over_title,
            style: TextStyle(color: AppColors.gameOverTitle),
          ),
          content: Text(
            AppLocalizations.of(context)!.game_over_crumbs(score),
            style: TextStyle(color: AppColors.gameOverText),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.main_menu,
                style: TextStyle(color: AppColors.gameOverMainMenu, fontWeight: FontWeight.bold),
              )
            ),
            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                restart();
              },
              child: Text(
                AppLocalizations.of(context)!.restart,
                style: TextStyle(color: AppColors.gameOverRestart, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Offset> getNextPosition(Offset position) async {
    if (detectCollision(position) == true) {
      if (timer != null && timer!.isActive) { 
        timer!.cancel();
      }

      await Future.delayed(Duration(milliseconds: AppDurations.gameOverDelay), () => showGameOverDialog());
      return position;
    }

    switch (direction) {
      case Direction.right:
        return Offset(position.dx + step, position.dy);
      case Direction.left:
        return Offset(position.dx - step, position.dy);
      case Direction.up:
        return Offset(position.dx, position.dy - step);
      case Direction.down:
        return Offset(position.dx, position.dy + step);
    }
  }

  void drawFood() {
    if (foodPosition == null) {
      foodPosition = getRandomPositionWithinRange();
    }

    if (foodPosition == positions[0]) {
      length++;
      speed += AppConstants.speedIncrement;
      score += AppConstants.scoreIncrement;

      changeSpeed();

      foodPosition = getRandomPositionWithinRange();
    }

    food = Piece(
      posX: foodPosition!.dx.toInt(),
      posY: foodPosition!.dy.toInt(),
      size: step,
      color: AppColors.food,
      isAnimated: true,
    );
  }

  List<Piece> getPieces() {
    List<Piece> pieces = [];
    draw();
    drawFood();

    for (int i = 0; i < length; ++i) {
      if (i >= positions.length) {
        continue;
      }

      pieces.add(
        Piece(
          posX: positions[i].dx.toInt(),
          posY: positions[i].dy.toInt(),
          size: step,
          color: AppColors.snake,
        ),
      );
    }

    return pieces;
  }

  Widget getControls() {
    return ControlPanel(
      onTapped: (Direction newDirection) {
        direction = newDirection;
      },
    );
  }

  int roundToNearestTens(int num) {
    int divisor = step;
    int output = (num ~/ divisor) * divisor;

    if (output == 0) {
      output += step;
    }
    return output;
  }

  void changeSpeed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }

    timer = Timer.periodic(Duration(milliseconds: AppDurations.gameTick ~/ speed), (timer) {
      setState(() {});
    });
  }

  Widget getScore() {
    return Positioned(
      top: AppSizes.scoreTopOffset,
      right: AppSizes.scoreRightOffset,
      child: Text(
        AppLocalizations.of(context)!.score(score),
        style: TextStyle(fontSize: AppSizes.scoreText),
      ),
    );
  }

  void restart() {
    score = 0;
    length = AppConstants.initialLength;
    positions = [];
    direction = getRandomDirection();
    speed = AppConstants.initialSpeed;
    changeSpeed();
  }

  Widget getPlayAreaBorder() {
    return Positioned(
      top: lowerBoundY!.toDouble(),
      left: lowerBoundX!.toDouble(),
      child: Container(
        width: (upperBoundX! - lowerBoundX! + step).toDouble(),
        height: (upperBoundY! - lowerBoundY! + step).toDouble(),
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

  @override
  void initState() {
    super.initState();

    restart();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    lowerBoundX = step;
    lowerBoundY = step;
    upperBoundX = roundToNearestTens(screenWidth!.toInt() - step);
    upperBoundY = roundToNearestTens(screenHeight!.toInt() - step);

    return Scaffold(
      // key: Key(Uuid().v1().toString()),
      body: Container(
        color: AppColors.dark,
        child: Stack(
          children: [
            getPlayAreaBorder(),
            Container(
              child: Stack(
                children: getPieces(),
              ),
            ),
            food!,
            getControls(),
            getScore(),
          ],
        ),
      ),
    );
  }
}

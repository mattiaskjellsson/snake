import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:snake/core/direction.dart';
import 'package:snake/core/direction_type.dart';
import 'package:snake/core/theme.dart';
import 'package:snake/features/game/widgets/control_panel.dart';
import 'package:snake/features/game/widgets/piece.dart';

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
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.black,
                width: 3.0,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Game Over",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            "Your game is over but you played well. Your score is " + score.toString() + ".",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                restart();
              },
              child: Text(
                "Restart",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      color: Color(0XFF8EA604),
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
          color: Colors.red,
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

    // if you want timer to tick at fixed duration.
    timer = Timer.periodic(Duration(milliseconds: AppDurations.gameTick ~/ speed), (timer) {
      setState(() {});
    });
  }

  Widget getScore() {
    return Positioned(
      top: AppSizes.scoreTopOffset,
      right: AppSizes.scoreRightOffset,
      child: Text(
        "Score: " + score.toString(),
        style: TextStyle(fontSize: 24.0),
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
            color: Colors.black.withOpacity(0.2),
            style: BorderStyle.solid,
            width: 1.0,
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
      body: Container(
        color: Color(0XFFF5BB00),
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

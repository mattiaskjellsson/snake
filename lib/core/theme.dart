import 'package:flutter/material.dart';

class AppConstants {
  static const initialLength = 4;
  static const step = 20;
  static const initialSpeed = 1.0;
  static const speedIncrement = 0.25;
  static const scoreIncrement = 5;
}

class AppSizes {
  static const zero = 0.0;
  static const menuImageWidth = 200.0;
  static const menuImageHeight = 200.0;
  static const fieldBorder = 1.0;
  static const gameTitle = 24.0;
  static const gameTitleSpacing = 10.0;
  static const gameOverBorder = 3.0;
  static const mainMenuTopOffset = 50.0;
  static const controlButtonHeight = 80.0;
  static const controlButtonWidth = 80.0;
  static const controlPanelLeftOffset = 0.0;
  static const controlPanelRightOffset = 0.0;
  static const controlPanelBottomOffset = 50.0;
  static const controlPanelHeightOffset = 75.0;
  static const scoreTopOffset = 50.0;
  static const scoreRightOffset = 40.0;
  static const scoreText = 24.0;
}

class AppColors {
  static const gameOverBackground = Colors.red;
  static const gameOverBorder = Colors.black;
  static const gameOverTitle = Colors.white;
  static const gameOverText = Colors.white;
  static const gameOverRestart = Colors.white;
  static const gameOverMainMenu = Colors.white;
  static const food = Colors.red;
  static const snake = Color.fromARGB(255, 207,184,114);
  static const dark = Color.fromARGB(255, 29, 29, 29);
  static const white = Colors.white;
  static const shadow = Colors.black;
}

class AppDurations {
  static const animationLowerBound = 0.25;
  static const animationUpperBound = 1.0;
  static const pieceAnimation = 1000;
  static const gameOverDelay = 500;
  static const gameTick = 200;
}

class AppOpacities {
  static const fieldBorder = 0.2;
  static const semi = 0.5;
}
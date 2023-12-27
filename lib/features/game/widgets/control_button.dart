import 'package:flutter/material.dart';
import 'package:snake/core/theme.dart';

class ControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;

  const ControlButton({Key? key, required this.onPressed, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: AppOpacities.semi,
      child: Container(
        width: AppSizes.controlButtonWidth,
        height: AppSizes.controlButtonHeight,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            elevation: AppSizes.zero,
            child: this.icon,
            onPressed: this.onPressed,
          ),
        ),
      ),
    );
  }
}

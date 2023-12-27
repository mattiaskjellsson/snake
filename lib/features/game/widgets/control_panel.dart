import 'package:flutter/material.dart';

import 'package:snake/core/direction.dart';
import 'package:snake/core/theme.dart';
import 'control_button.dart';

class ControlPanel extends StatelessWidget {
  final void Function(Direction direction) onTapped;

  const ControlPanel({Key? key, required this.onTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppSizes.controlPanelLeftOffset,
      right: AppSizes.controlPanelRightOffset,
      bottom: AppSizes.controlPanelBottomOffset,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                ControlButton(
                  icon: Icon(Icons.arrow_left),
                  onPressed: () {
                    onTapped(Direction.left);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ControlButton(
                  icon: Icon(Icons.arrow_drop_up_sharp),
                  onPressed: () {
                    onTapped(Direction.up);
                  },
                ),
                SizedBox(
                  height: AppSizes.controlPanelHeightOffset,
                ),
                ControlButton(
                  icon: Icon(Icons.arrow_drop_down_sharp),
                  onPressed: () {
                    onTapped(Direction.down);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                ControlButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: () {
                    onTapped(Direction.right);
                  },
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

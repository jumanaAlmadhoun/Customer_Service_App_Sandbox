import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? icon;
  const ActionButton({Key? key, required this.icon, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 9.0,
        child: SizedBox(
          height: 80,
          width: 80,
          child: IconButton(
            onPressed: onPressed,
            icon: ImageIcon(
              AssetImage(icon!),
            ),
            iconSize: 70,
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/buttons/abstract/app_button.dart';

class IconButton extends AppButton {
  final Widget icon;
  final Color? color;

  const IconButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    required this.icon,
    this.color,
    double? width,
    double height = 50,
  }) : super(
            key: key,
            text: text,
            onPressed: onPressed,
            width: width,
            height: height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(
          text,
          style: TextStyle(color: context.color.buttonContent),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? context.color.buttonBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/buttons/abstract/app_button.dart';

class TextOnlyButton extends AppButton with ButtonActions {
  final Color? textColor;

  const TextOnlyButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    this.textColor,
    (String, Function(dynamic data))? submitForm,
    double? width,
    double height = 50,
  }) : super(
            key: key,
            text: text,
            submitForm: submitForm,
            onPressed: onPressed,
            width: width,
            height: height);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      child: buildButtonChild(
        context,
        textColor: textColor ?? context.color.content,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

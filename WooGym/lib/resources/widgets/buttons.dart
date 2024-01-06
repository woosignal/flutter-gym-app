//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2024, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '/bootstrap/helpers.dart';
import '/resources/widgets/app_loader_widget.dart';

class PrimaryButton extends WooSignalButton {
  @override
  final String style = "primary";

  PrimaryButton(
      {super.key,
      super.title,
      super.action,
      super.isLoading = false,
      super.isDisabled,
      super.backgroundColor = Colors.transparent})
      : super(setTextStyle: (TextTheme textTheme) {
          return textTheme.bodyMedium!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold);
        });
}

class SecondaryButton extends WooSignalButton {
  @override
  final String style = "secondary";

  SecondaryButton(
      {super.key,
      super.title,
      super.action,
      super.isLoading = false,
      super.isDisabled,
      super.backgroundColor = const Color(0xFFF6F6F9)})
      : super();
}

class AccentButton extends WooSignalButton {
  @override
  final String style = "accent";

  AccentButton(
      {super.key,
      super.title,
      super.action,
      super.isLoading = false,
      super.isDisabled,
      super.backgroundColor = const Color(0xFFF6F6F9)})
      : super();
}

class LinkButton extends WooSignalButton {
  @override
  final String style = "link";

  LinkButton(
      {super.key,
      super.title,
      super.action,
      super.isLoading = false,
      super.isDisabled,
      super.backgroundColor = const Color(0xFFF6F6F9)})
      : super();
}

class WooSignalButton extends StatelessWidget {
  WooSignalButton(
      {super.key,
      this.title,
      this.action,
      this.textStyle,
      this.isLoading = false,
      this.isDisabled,
      this.backgroundColor,
      this.disabledColor,
      this.activeColor,
      this.setTextStyle,
      this.style});

  final String? style;
  final String? title;
  final Function? action;
  final TextStyle? textStyle;
  late final Color? backgroundColor;
  final bool isLoading;
  final bool Function()? isDisabled;
  final TextStyle Function(TextTheme textTheme)? setTextStyle;
  final Color? disabledColor;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    TextStyle? textStyle = this.textStyle;
    if (setTextStyle != null) {
      textStyle = setTextStyle!(Theme.of(context).textTheme);
    }

    bool disabled = false;
    if (isDisabled != null) {
      disabled = isDisabled!();
    }

    Color? color = backgroundColor;
    switch (style) {
      case "primary":
        color = ThemeColor.get(context).buttonPrimaryBackground;
        break;
      case "secondary":
        color = ThemeColor.get(context).buttonSecondaryBackground;
        break;
      case "accent":
        color = ThemeColor.get(context).primaryAccent;
        textStyle = Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold);
        break;
      case "link":
        return InkWell(
          key: key,
          child: Container(
            height: (screenWidth >= 385 ? 55 : 49),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Center(
                child: Text(
              title!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            )),
          ),
          onTap: action == null ? null : () async => await action!(),
        );
      default:
        backgroundColor = Colors.white;
    }

    if (color != null && isDisabled != null) {
      if (isDisabled!()) {
        color = color.withOpacity(0.6);
      }
    }

    return MaterialButton(
      minWidth: double.infinity,
      onPressed: (disabled == true || action == null || isLoading == true)
          ? null
          : () async => await action!(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: Colors.white, width: 1.5),
      ),
      child: isLoading
          ? AppLoaderWidget()
          : AutoSizeText(
              title!,
              style: textStyle,
              maxLines: (screenWidth >= 385 ? 2 : 1),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
      disabledColor: disabledColor,
      height: (screenWidth >= 385 ? 55 : 49),
      elevation: 0,
      color: color,
    );
  }
}

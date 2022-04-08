/*
 * @Author       : Linloir
 * @Date         : 2022-04-08 16:52:46
 * @LastEditTime : 2022-04-08 23:44:10
 * @Description  : Flat Button Class
 */

import 'package:flutter/material.dart';

class LuiFlatButton extends StatelessWidget{
  const LuiFlatButton({
    Key? key,
    this.enabled,
    required this.text,
    this.textStyle,
    this.backgroudColorEnabled,
    this.textColorEnabled,
    this.backgroundColorDisabled,
    this.textColorDisabled,
    this.splashColor,
    this.borderRadius,
    this.contentPadding,
    required this.onPressed,
    this.onLongPressed,
    this.onHover
  }) : super(key: key);

  final bool? enabled;
  final String text;
  final TextStyle? textStyle;
  final Color? backgroudColorEnabled;
  final Color? textColorEnabled;
  final Color? backgroundColorDisabled;
  final Color? textColorDisabled;
  final Color? splashColor;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final void Function() onPressed;
  final void Function()? onLongPressed;
  final void Function(bool)? onHover;

  Color _backGroundColor() {
    if(enabled == true) {
      return backgroudColorEnabled ?? Colors.blue;
    }
    else {
      return backgroundColorDisabled ?? Colors.grey[300]!;
    }
  }

  Color _textColor() {
    if(enabled == true) {
      return textColorEnabled ?? Colors.blue[800]!;
    }
    else {
      return textColorDisabled ?? Colors.grey[500]!;
    }
  }

  Color _splashColor() {
    return splashColor ?? _backGroundColor().withOpacity(0.15);
  }

  OutlinedBorder _shape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 0.0));
  }

  EdgeInsets _contentPadding() {
    return contentPadding ?? const EdgeInsets.all(8.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 125),
      data: Theme.of(context).copyWith(
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color?>(_backGroundColor()),
            foregroundColor: MaterialStateProperty.all<Color?>(_textColor()),
            overlayColor: MaterialStateProperty.all<Color?>(_splashColor()),
            shape: MaterialStateProperty.all<OutlinedBorder?>(_shape()),
            padding: MaterialStateProperty.all<EdgeInsets?>(_contentPadding()),
          ),
        ),
      ),
      child: TextButton(
        onPressed: enabled == true ? onPressed : null,
        onLongPress: onLongPressed,
        onHover: onHover,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized,
          child: Text(
            text,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}

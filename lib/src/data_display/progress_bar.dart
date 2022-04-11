/*
 * @Author       : Linloir
 * @Date         : 2022-04-11 14:14:34
 * @LastEditTime : 2022-04-11 14:14:35
 * @Description  : 
 */

import 'package:flutter/material.dart';

class LuiLinearProgressBar extends StatefulWidget {
  const LuiLinearProgressBar({Key? key, required this.progress, this.backgroundColor, this.borderColor, this.highlightColor, this.borderWidth}) : super(key: key);

  final double progress;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? highlightColor;
  final double? borderWidth;

  @override
  State<LuiLinearProgressBar> createState() => _LuiLinearProgressBar();
}

class _LuiLinearProgressBar extends State<LuiLinearProgressBar> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.grey[100]!,
              borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
              border: Border.all(color: widget.borderColor ?? Colors.grey[100]!, width: widget.borderWidth ?? 2.0)
            ),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 750),
              curve: Curves.easeInOutExpo,
              width: constraints.maxWidth * widget.progress,
              decoration: BoxDecoration(
                color: widget.highlightColor ?? Colors.teal[300]!,
                borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
              ),
            ),
          ),
        );
      }
    );
  }
}
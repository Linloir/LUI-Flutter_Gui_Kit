/*
 * @Author       : Linloir
 * @Date         : 2022-04-10 15:50:55
 * @LastEditTime : 2022-05-12 15:18:47
 * @Description  : Badge
 */

import 'package:flutter/material.dart';

class LuiFlatBadge extends StatelessWidget {
  const LuiFlatBadge({
    required this.backgroundColor,
    required this.content,
    this.contentPadding,
    this.borderRadius,
    Key? key,
  }): super(key: key);

  final Color backgroundColor;
  final Widget content;
  final EdgeInsets? contentPadding;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? double.infinity),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? double.infinity),
          color: backgroundColor,
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubicEmphasized,
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            switchInCurve: Curves.easeInOutCubicEmphasized,
            duration: const Duration(milliseconds: 750),
            reverseDuration: const Duration(milliseconds: 75),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1), 
                  end: const Offset(0, 0)
                ).animate(animation
                //   CurvedAnimation(
                //   parent: animation, 
                //   curve: Curves.elasticOut
                // )
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: content,
          ),
        ),
      ),
    );
  }
}

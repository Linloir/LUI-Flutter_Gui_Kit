/*
 * @Author       : Linloir
 * @Date         : 2022-04-09 10:21:49
 * @LastEditTime : 2022-04-10 17:53:26
 * @Description  : Check Box
 */

import 'dart:math';

import 'package:flutter/material.dart';

class LuiCheckBox extends StatefulWidget {
  const LuiCheckBox({
    Key? key,
    required this.value,
    this.enabled,
    this.accentColorEnabled,
    this.fillColorEnabled,
    this.fallOnColorEnabled,
    this.backgroundColorEnabled,
    this.splashColor,
    this.hoverColor,
    this.fillColorDisabled,
    this.backgroundColorDisabled,
    this.borderRadius,
    this.borderWidth,
    this.contentPadding,
    this.duration,
    this.onChanged,
  }) : super(key: key);

  final bool value;
  final bool? enabled;
  final Color? accentColorEnabled;
  final Color? fillColorEnabled;
  final Color? fallOnColorEnabled;
  final Color? backgroundColorEnabled;
  final Color? splashColor;
  final Color? hoverColor;
  final Color? fillColorDisabled;
  final Color? backgroundColorDisabled;
  final double? borderRadius;
  final double? borderWidth;
  final EdgeInsets? contentPadding;
  final Duration? duration;
  final void Function(bool value)? onChanged;

  @override
  State<LuiCheckBox> createState() => _LuiCheckBoxState();
}

class _LuiCheckBoxState extends State<LuiCheckBox> with TickerProviderStateMixin{
  late bool _enabled;
  late Color _accentColorEnabled;
  late Color _fillColorEnabled;
  late Color _fallOnColorEnabled;
  late Color _backgroundColorEnabled;
  late Color _fillColorDisabled;
  late Color _backgroundColorDisabled;
  late double _borderWidth;
  late EdgeInsets _contentPadding;
  late Duration _duration;

  late final AnimationController _controller;
  late Color _fillColor;

  void _initParameters() {
    _enabled = widget.enabled ?? true;
    _fillColorEnabled = widget.fillColorEnabled ?? Colors.grey;
    _accentColorEnabled = widget.accentColorEnabled ?? Colors.blue;
    _fallOnColorEnabled = widget.fallOnColorEnabled ?? _accentColorEnabled;
    _backgroundColorEnabled = widget.backgroundColorEnabled ?? Colors.white.withOpacity(0);
    _fillColorDisabled = widget.fillColorDisabled ?? Colors.grey[300]!;
    _backgroundColorDisabled = widget.backgroundColorDisabled ?? Colors.white.withOpacity(0);
    _borderWidth = widget.borderWidth ?? 2.0;
    _contentPadding = widget.contentPadding ?? const EdgeInsets.all(8.0);
    _duration = widget.duration ?? const Duration(milliseconds: 750);
  }

  @override
  void initState() {
    super.initState();
    _initParameters();
    _controller = AnimationController(vsync: this, duration: _duration);
    _controller.value = widget.value ? 1 : 0;
    _fillColor = _enabled ? widget.value ? _fallOnColorEnabled : _fillColorEnabled : _fillColorDisabled; 
  }

  @override
  void didUpdateWidget(LuiCheckBox oldWidget) {
    _initParameters();
    if(widget.value == oldWidget.value && widget.enabled == oldWidget.enabled) {
      super.didUpdateWidget(oldWidget);
      return;
    }
    if(!widget.value) {
      if(mounted){
        setState(() {
          _fillColor = _enabled ? _fillColorEnabled : _fillColorDisabled;
        });}
      _controller.reverse();
    }
    else {
      if(mounted) {
        setState(() {
          _fillColor = _enabled ? _accentColorEnabled : _fillColorDisabled;
        });
      }
      _controller.forward().then((value) => Future.delayed(const Duration(milliseconds: 375))).then((value) {
        if(mounted && widget.value) {
          setState(() {
            _fillColor = _enabled ? _fallOnColorEnabled : _fillColorDisabled;
          });
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _scaleAnimation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutExpo,
    ));
    return Container(
      height: 48,
      width: 48,
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            if(_backgroundColorEnabled.opacity != 0 || _backgroundColorDisabled.opacity != 0)
              Positioned.fill(
                child: Padding(
                  padding: _contentPadding,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return AnimatedBuilder(
                        animation: _controller, 
                        builder: (context, child) {
                          return ClipPath(
                            clipBehavior: Clip.antiAlias,
                            clipper: _BackgoundClipper(
                              borderRadius: widget.borderRadius ?? constraints.maxWidth / 2,
                              holeSize: _scaleAnimation.value,
                              borderWidth: _borderWidth
                            ),
                            child: child,
                          );
                        },
                        child: AnimatedContainer(
                          width: double.infinity,
                          height: double.infinity,
                          duration: _duration,
                          color: _enabled ? _backgroundColorEnabled : _backgroundColorDisabled,
                        ),
                      );
                    },
                  ),
                ),
              ),
            Positioned.fill(
              child: Padding(
                padding: _contentPadding,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedBuilder(
                      animation: _controller, 
                      builder: (context, child) {
                        return ClipPath(
                          clipBehavior: Clip.antiAlias,
                          clipper: _HoleClipper(
                            borderRadius: widget.borderRadius ?? constraints.maxWidth / 2,
                            holeSize: _scaleAnimation.value,
                            borderWidth: _borderWidth
                          ),
                          child: child,
                        );
                      },
                      child: AnimatedContainer(
                        width: double.infinity,
                        height: double.infinity,
                        duration: _duration,
                        color: _fillColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: _contentPadding,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.scale(
                          alignment: Alignment.center,
                          scale: 1 - _scaleAnimation.value,
                          child: child,
                        );
                      },
                      child: Icon(Icons.check, color: Colors.white, size: constraints.maxHeight * 0.8,),
                    // Icon(Icons.check, color: Colors.white, size: 24.0,),
                    );
                  }
                ),
              ),
            ),
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: widget.splashColor,
                      hoverColor: widget.hoverColor,
                      highlightColor: widget.splashColor,
                      customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? constraints.maxWidth)),
                      onTap: !_enabled ? null : (){
                        if(widget.onChanged != null) {
                          widget.onChanged!(!widget.value);
                        }
                      },
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HoleClipper extends CustomClipper<Path> {
  const _HoleClipper({
    required this.borderRadius,
    required this.borderWidth,
    required this.holeSize,
  });
  final double borderRadius;
  final double borderWidth;
  final double holeSize;

  RRect _outerRect(Size size) {
    return RRect.fromRectAndRadius(
      Rect.fromLTRB(0, 0, size.width, size.height),
      Radius.circular(borderRadius)
    );
  }

  RRect _innerRect(Size size) {
    double holeWidth = (size.width - 2 * borderWidth) * holeSize;
    double holeHeight = (size.height - 2 * borderWidth) * holeSize;
    double ratio = (sqrt(pow(holeWidth, 2) + pow(holeHeight, 2)) / sqrt(pow(size.width, 2) + pow(size.height, 2)));
    double radius = borderWidth < borderRadius ? (borderRadius - borderWidth) * holeSize : borderRadius * ratio;
    return RRect.fromRectAndRadius(
      Alignment.center.inscribe(Size(holeWidth, holeHeight), Rect.fromLTRB(0, 0, size.width, size.height)),
      Radius.circular(radius),
    );
  }

  @override
  Path getClip(Size size) {
    return Path() ..fillType = PathFillType.evenOdd
                  ..addRRect(_outerRect(size))
                  ..addRRect(_innerRect(size));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _BackgoundClipper extends CustomClipper<Path> {
  const _BackgoundClipper({
    required this.borderRadius,
    required this.borderWidth,
    required this.holeSize,
  });
  final double borderRadius;
  final double borderWidth;
  final double holeSize;

  RRect _innerRect(Size size) {
    double holeWidth = (size.width - 2 * borderWidth) * holeSize;
    double holeHeight = (size.height - 2 * borderWidth) * holeSize;
    double left = (size.width - holeWidth) / 2;
    double top = (size.height - holeHeight) / 2;
    double ratio = (sqrt(pow(holeWidth, 2) + pow(holeHeight, 2)) / sqrt(pow(size.width, 2) + pow(size.height, 2)));
    double radius = borderWidth < borderRadius ? (borderRadius - borderWidth) * holeSize : borderRadius * ratio;
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, holeWidth, holeHeight),
      Radius.circular(radius),
    );
  }

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRRect(_innerRect(size));
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
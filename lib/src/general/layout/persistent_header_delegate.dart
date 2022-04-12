/*
 * @Author       : Linloir
 * @Date         : 2022-04-12 23:11:04
 * @LastEditTime : 2022-04-12 23:38:10
 * @Description  : Common Persistent Header
 */

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef LuiPersistentHeaderChildBuilder = Widget Function(BuildContext context, double shrinkRatio, double overshootRatio, double overshootAmount);

class LuiPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  LuiPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.topPadding,
    this.stretch = true,
    required this.childBuilder,
  });

  final double minHeight;
  final double maxHeight;
  final double topPadding;
  final bool stretch;
  final LuiPersistentHeaderChildBuilder childBuilder;

  @override
  double get minExtent => minHeight + topPadding;

  @override
  double get maxExtent => maxHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => stretch ? OverScrollHeaderStretchConfiguration() : null;

  double _getShrinkRatio(double shrinkOffset) {
    return (shrinkOffset / (maxExtent - minExtent)).clamp(0, 1);
  }

  double _getOvershootRatio(double curHeight) {
    return ((curHeight - maxExtent) / maxExtent).clamp(0, double.infinity);
  }

  double _getOvershootAmount(double curHeight) {
    return (curHeight - maxExtent).clamp(0, double.infinity);
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      constraints: const BoxConstraints.expand(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return childBuilder(context, _getShrinkRatio(shrinkOffset), _getOvershootRatio(constraints.maxHeight), _getOvershootAmount(constraints.maxHeight));
        },
      ),
    );
  }
}

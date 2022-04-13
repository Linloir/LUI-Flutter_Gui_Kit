/*
 * @Author       : Linloir
 * @Date         : 2022-04-13 16:12:42
 * @LastEditTime : 2022-04-13 16:44:49
 * @Description  : Multiple Page Skeleton with Slivers inside
 */

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lui_gui_kit/src/general/layout/persistent_header_delegate.dart';

typedef LuiHeaderBuilder = Widget Function(BuildContext context, double shrinkRatio, double overshootAmount, double curPage);

class _PageSkeleton extends StatefulWidget {
  const _PageSkeleton({
    required this.controller,
    required this.slivers,
    required this.minHeight,
    required this.maxHeight,
    required this.topPadding,
    required this.headStretch,
    Key? key,
  }): super(key: key);

  final double minHeight;
  final double maxHeight;
  final double topPadding;
  final bool headStretch;

  final ScrollController controller;
  final List<Widget> slivers;

  @override
  State<_PageSkeleton> createState() => _PageSkeletonState();
}

class _PageSkeletonState extends State<_PageSkeleton> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: widget.controller,
      slivers: [
        //Build a transparent fake header
        SliverPersistentHeader(
          pinned: false,
          delegate: LuiPersistentHeaderDelegate(
            minHeight: widget.minHeight,
            maxHeight: widget.maxHeight,
            topPadding: widget.topPadding,
            stretch: widget.headStretch,
            childBuilder: (context, shrinkRatio, overshootRatio, overshootAmount) {
              return Container(
                color: Colors.transparent,
                constraints: const BoxConstraints.expand(),
              );
            },
          ),
        ),
        ...widget.slivers,
      ],
    );
  }
}

class LuiMultiSliverPageSkeleton extends StatefulWidget {
  const LuiMultiSliverPageSkeleton({
    required this.minHeight,
    required this.maxHeight,
    required this.topPadding,
    this.headStretch = true,
    required this.headerBuilder,
    required this.contents,
    required this.controller,
    Key? key,
  }): super(key: key);

  final double minHeight;
  final double maxHeight;
  final double topPadding;
  final bool headStretch;

  final LuiHeaderBuilder headerBuilder;
  final List<List<Widget>> contents;
  final PageController controller;

  @override
  State<LuiMultiSliverPageSkeleton> createState() => _LuiMultiSliverPageSkeletonState();
}

class _LuiMultiSliverPageSkeletonState extends State<LuiMultiSliverPageSkeleton> {
  final List<double> _shrinkRatios = [];
  final List<ScrollController> _scrollControllers = [];
  double _overshootAmount = 0;
  int _curPageAt = 0;
  int _curPageTo = 0;
  double _curPage = 0;

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < widget.contents.length; i++) {
      _shrinkRatios.add(0);
      var newController = ScrollController();
      newController.addListener(() {
        setState(() {
          _shrinkRatios[i] = (newController.offset / (widget.maxHeight - widget.minHeight)).clamp(0, 1);
          _overshootAmount = newController.offset.clamp(double.negativeInfinity, 0) * -1;
        });
      });
      _scrollControllers.add(newController);
    }
    widget.controller.addListener(() {setState(() {
      _curPage = widget.controller.page!;
      _curPageAt = widget.controller.page!.floor();
      _curPageTo = widget.controller.page!.ceil();
    });});
  }

  double _getShrinkRatio() {
    var curRatio = _curPage - _curPageAt;
    var ratio = lerpDouble(_shrinkRatios[_curPageAt], _shrinkRatios[_curPageTo], curRatio) ?? 0;
    return ratio;
  }

  double _getMaxHeight(double shrinkRatio, double overshootAmount) {
    var minExtent = widget.minHeight + widget.topPadding;
    var maxExtent = widget.maxHeight;
    var dif = maxExtent - minExtent;
    return maxExtent - dif * shrinkRatio + overshootAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          //Build page
          PageView(
            physics: const BouncingScrollPhysics(),
            controller: widget.controller,
            children: [
              for(int i = 0; i < widget.contents.length; i++)
                _PageSkeleton(
                  controller: _scrollControllers[i], 
                  slivers: widget.contents[i], 
                  minHeight: widget.minHeight, 
                  maxHeight: widget.maxHeight, 
                  topPadding: widget.topPadding, 
                  headStretch: widget.headStretch
                )
            ],
          ),
          //Build real headers with transition
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: _getMaxHeight(_getShrinkRatio(), _overshootAmount),
              ),
              child: widget.headerBuilder(
                context,
                _getShrinkRatio(),
                _overshootAmount,
                _curPage,
              ),
            ),
          )
        ],
      ),
    );
  }
}

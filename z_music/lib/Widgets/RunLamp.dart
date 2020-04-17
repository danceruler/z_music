import 'dart:async';

import 'package:flutter/cupertino.dart';

class RunLamp extends StatefulWidget {
  Widget child; //轮播内容
  Duration duration; //轮播时间
  double stepOffset; //偏移量
  double paddingLeft; //内容之间的间距
  double fatherWidth;
  double childwidth;

  RunLamp(this.child, this.duration, this.stepOffset, this.paddingLeft,
      this.fatherWidth, this.childwidth);

  @override
  State<StatefulWidget> createState() => _RunLamp();
}

class _RunLamp extends State<RunLamp> {
  ScrollController _controller; //执行动画的控制器
  Timer _timer; //定时器
  double _offset = 0.0; //执行动画的偏移量

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(initialScrollOffset: _offset);

      _timer = Timer.periodic(widget.duration, (timer) {
        double newOffset = _controller.offset + widget.stepOffset;
        if (newOffset != _offset) {
          _offset = newOffset;
          _controller.animateTo(_offset,
              duration: widget.duration, curve: Curves.linear);
        }
      });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Widget _child() {
    return new Row(
      children: _children(),
    );
  }

  // 子视图
  List<Widget> _children() {
    List<Widget> items = [];
    for (var i = 0; i <= 2; i++) {
      Container item = new Container(
        margin: new EdgeInsets.only(right: i != 0 ? 0.0 : widget.paddingLeft),
        child: i != 0 ? null : widget.child,
      );
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.childwidth > widget.fatherWidth) {
      return ListView.builder(
        scrollDirection: Axis.horizontal, // 横向滚动
        controller: _controller, // 滚动的controller
        itemBuilder: (context, index) {
          return _child();
        },
      );
    } else {
      return widget.child;
    }
  }
}

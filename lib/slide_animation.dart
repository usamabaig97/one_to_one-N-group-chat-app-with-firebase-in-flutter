import 'package:flutter/material.dart';

enum SlidDirection { fromTop, fromLeft, fromRight, fromBottom }

class SlideAnimation extends StatefulWidget {
  const SlideAnimation(
      {Key? key,
      required this.child,
      required this.position,
      required this.itemCount,
      required this.slideDirection,
      required this.animationController})
      : super(key: key);

  final Widget child;
  final int position;
  final int itemCount;
  final SlidDirection slideDirection;
  final AnimationController animationController;

  @override
  _SlideAnimationState createState() => _SlideAnimationState();
}

class _SlideAnimationState extends State<SlideAnimation> {
  @override
  Widget build(BuildContext context) {

    var xTransition = 0.0, yTransition = 0.0;
    var _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval((1 / widget.itemCount) * widget.position, 1.0,
            curve: Curves.fastOutSlowIn)));

    widget.animationController.forward();

    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (context, child) {

          if(widget.slideDirection == SlidDirection.fromTop){
            yTransition = -50 * (1.0 - _animation.value);
          } else if(widget.slideDirection == SlidDirection.fromBottom){
            yTransition = 50 * (1.0 - _animation.value);
          } else if(widget.slideDirection == SlidDirection.fromRight){
            xTransition = 400 * (1.0 - _animation.value);
          } else{
            xTransition = -400 * (1.0 - _animation.value);
          }

          return FadeTransition(
            opacity: _animation,
            child: Transform(
              child: widget.child,
              transform:
                  Matrix4.translationValues(xTransition, yTransition, 0.0),
            ),
          );
        });
  }
}

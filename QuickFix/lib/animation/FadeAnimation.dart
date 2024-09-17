import 'package:QuickFix/animation/simple_animations/lib/animation_builder/play_animation_builder.dart';
import 'package:QuickFix/animation/simple_animations/lib/movie_tween/movie_tween.dart';
import 'package:flutter/material.dart';


class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween("opacity" as MovieTweenPropertyType, Tween(begin: 0.0, end: 1.0), duration: Duration(milliseconds: 500))
      ..tween("translateY" as MovieTweenPropertyType, Tween(begin: -30.0, end: 0.0), duration: Duration(milliseconds: 500), curve: Curves.easeOut);

    return PlayAnimationBuilder<Movie>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value.get("opacity" as MovieTweenPropertyType),
        child: Transform.translate(
          offset: Offset(0, value.get("translateY" as MovieTweenPropertyType)),
          child: child,
        ),
      ),
    );
  }
}

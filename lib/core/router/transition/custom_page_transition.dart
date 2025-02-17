import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomPageTransition {
  // 페이드 인/아웃 트랜지션
  static CustomTransitionPage<void> fadeTransition({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // 슬라이드 트랜지션
  static CustomTransitionPage<void> slideTransition({
    required LocalKey key,
    required Widget child,
    SlideDirection direction = SlideDirection.right,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (direction) {
          case SlideDirection.right:
            begin = const Offset(1.0, 0.0);
            break;
          case SlideDirection.left:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
        }

        return SlideTransition(
          position: Tween(
            begin: begin,
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  // 노 트랜지션
  static NoTransitionPage<void> noTransition({
    required LocalKey key,
    required Widget child,
  }) {
    return NoTransitionPage(
      key: key,
      child: child,
    );
  }
}

enum SlideDirection {
  right,
  left,
  up,
  down,
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/layout/main_layout.dart';
import 'package:url_check/features/home/view/home_screen.dart';
import 'package:url_check/features/system/view/system_screen.dart';
import 'package:url_check/features/setting/view/setting_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(
            currentIndex: _getCurrentIndex(state.uri.toString()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/system',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SystemScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SettingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurveTween(curve: Curves.easeInOut).animate(animation)),
              child: child,
            );
          },
        ),
      ),
    ],
  );
});
int _getCurrentIndex(String location) {
  switch (location) {
    case '/':
      return 0;
    case '/system':
      return 1;
    default:
      return 0;
  }
}

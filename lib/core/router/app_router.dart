import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/layout/main_layout.dart';
import 'package:url_check/features/home/view/home_screen.dart';
import 'package:url_check/features/system/model/system_model.dart';
import 'package:url_check/features/system/view/tab/view/monitoring_detail_screen.dart';
import 'package:url_check/features/system/view/system_screen.dart';
import 'package:url_check/features/setting/view/setting_screen.dart';
import 'package:url_check/core/router/transition/custom_page_transition.dart';
import 'package:url_check/features/system/view/tab/view/system_list_detail_screen.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          if (!state.uri.toString().contains("detail")) {
            return MainLayout(
              currentIndex: _getCurrentIndex(state.uri.toString()),
              child: child,
            );
          }
          return child;
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => CustomPageTransition.noTransition(
              key: state.pageKey,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/system',
            pageBuilder: (context, state) => CustomPageTransition.noTransition(
              key: state.pageKey,
              child: const SystemScreen(),
            ),
            routes: [
              GoRoute(
                path: 'systemList/detail',
                pageBuilder: (context, state) => CustomPageTransition.slideTransition(
                  key: state.pageKey,
                  child: SystemListDetailScreen(system: state.extra as SystemModel),
                ),
              ),
              GoRoute(
                path: 'monitoring/detail',
                pageBuilder: (context, state) => CustomPageTransition.slideTransition(
                  key: state.pageKey,
                  child: const SystemDetailScreen(
                    systemName: '기관홈페이지 (WWW)',
                    systemUrl: 'https://www.kins.re.kr',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomPageTransition.slideTransition(
          key: state.pageKey,
          child: const SettingScreen(),
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

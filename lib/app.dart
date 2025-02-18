import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/core/router/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class UrlCheckerApp extends ConsumerWidget {
  const UrlCheckerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'URL Checker',
      theme: themeState.themeData,
      routerConfig: router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
    );
  }
}

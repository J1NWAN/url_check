import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

class HomeViewState {
  final PageController pageController;
  final int currentPage;

  HomeViewState({
    required this.pageController,
    required this.currentPage,
  });

  HomeViewState copyWith({
    PageController? pageController,
    int? currentPage,
  }) {
    return HomeViewState(
      pageController: pageController ?? this.pageController,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeViewState build() => HomeViewState(
        pageController: PageController(),
        currentPage: 0,
      );

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page);
  }
}

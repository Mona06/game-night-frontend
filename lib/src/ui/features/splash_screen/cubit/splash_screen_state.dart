import 'package:equatable/equatable.dart';

class SplashScreenState extends Equatable {
  const SplashScreenState({
    required this.state,
    this.showLoader = false,
  });

  final SplashAction state;
  final bool showLoader;

  SplashScreenState copyWith({
    SplashAction? state,
    double? opacity,
    double? scale,
    bool? showLoader,
  }) {
    return SplashScreenState(
      state: state ?? this.state,
      showLoader: showLoader ?? this.showLoader,
    );
  }

  @override
  List<Object?> get props => [state, showLoader];
}

enum SplashAction {
  splash,
  introduction,
  unauthenticated,
  onboarding,
  authenticated
}

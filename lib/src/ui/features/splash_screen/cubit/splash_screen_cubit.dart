import 'package:bloc/bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/models/user_profile.dart';
import '../../../../core/services/user_service.dart';
import 'splash_screen_state.dart';

class SplashScreenCubit extends Cubit<SplashScreenState> {
  final UserService _userService;

  SplashScreenCubit({
    UserService? userService,
  })  : _userService = userService ?? Ioc.container.get<UserService>(),
        super(SplashScreenState(state: SplashAction.splash));

  Future<void> splash() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    // resetIntroduction(instance);

    final bool needsIntroduction =
        instance.getBool('needsIntroduction') ?? true;

    if (needsIntroduction) {
      instance.setBool('needsIntroduction', false);
      emit(SplashScreenState(state: SplashAction.introduction));
      return;
    }

    await _userService.loadToken();
    final String? token = _userService.token;

    if (token == null) {
      emit(SplashScreenState(state: SplashAction.unauthenticated));
      return;
    }

    // If the token is valid, we can also load in the user that is in the storage.
    await _userService.loadUser();

    try {
      // Attempt to get current user to verify token validity
      final ProfileRead userProfile = await _userService.getCurrentProfile();

      if (isProfileIncomplete(userProfile)) {
        emit(SplashScreenState(state: SplashAction.onboarding));
        return;
      }

      emit(SplashScreenState(state: SplashAction.authenticated));
    } catch (e) {
      // Token is invalid or there's a network issue
      await _userService.removeToken();
      emit(SplashScreenState(state: SplashAction.unauthenticated));
    }
  }

  bool isProfileIncomplete(ProfileRead profile) {
    return profile.birthday == null || profile.country == null || false;
  }
}

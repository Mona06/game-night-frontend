import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:party_planner/src/ui/widgets/snackbar.dart';
import 'package:party_planner/src/ui/widgets/typography/app_theme.dart';

import '../core/services/event_service.dart';
import '../core/services/preference_service.dart';
import '../core/services/user_service.dart';
import 'features/connections/view/connections.dart';
import 'features/event_form/view/create_event_view.dart';
import 'features/events/cubit/event_status_cubit.dart';
import 'features/events/view/my_events_view.dart';
import 'features/home/view/home_view.dart';
import 'features/introduction/introduction_view.dart';
import 'features/login_form/cubit/login_cubit.dart';
import 'features/login_form/view/login_view.dart';
import 'features/notifications/view/notifications_tab.dart';
import 'features/onboarding/cubit/onboarding_cubit.dart';
import 'features/onboarding/view/onboarding_view.dart';
import 'features/register_form/cubit/register_cubit.dart';
import 'features/register_form/view/register_view.dart';
import 'features/splash_screen/view/splash_screen_view.dart';
import 'features/user_profile/cubit/settings/account_settings_cubit.dart';
import 'features/user_profile/view/profile_view.dart';
import 'features/user_profile/view/settings/account_settings_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialTheme theme = MaterialTheme();
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventStatusCubit>(
          create: (context) => EventStatusCubit(
            Ioc.container.get<EventsService>(),
            Ioc.container.get<UserService>(),
          )..loadTentativeEvents(),
        ),
        BlocProvider<OnboardingCubit>(
          create: (context) => OnboardingCubit(
            userService: Ioc.container.get<UserService>(),
            preferencesService: Ioc.container.get<PreferencesService>(),
          ),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(Ioc.container.get<UserService>()),
        ),
        BlocProvider<RegisterCubit>(
          create: (context) => RegisterCubit(Ioc.container.get<UserService>()),
        ),
        BlocProvider<AccountSettingsCubit>(
          create: (context) => AccountSettingsCubit(
            Ioc.container.get<UserService>(),
            Ioc.container.get<PreferencesService>(),
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            scaffoldMessengerKey: AppSnackBar.scaffoldMessengerKey,
            theme: theme.light(),
            home: const HomeView(),
            initialRoute: '/splash-screen',
            routes: {
              '/login': (context) => LoginView(),
              '/register': (context) => RegisterView(),
              '/connections': (context) => ConnectionsView(),
              '/home': (context) => const HomeView(),
              '/events': (context) => const MyEventsView(),
              // '/calendar-view': (context) => CalendarView(),
              '/notifications': (context) => NotificationsView(),
              '/profile': (context) => ProfileView(),
              '/add-event': (context) => CreateEventView(),
              '/onboarding': (context) => OnboardingPage(),
              '/splash-screen': (context) => SplashScreen(),
              '/introduction': (context) => IntroductionPage(),
              '/account-settings': (context) => AccountSettingsView(),
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:party_planner/src/core/services/calendar_service.dart';
import 'package:party_planner/src/core/services/event_service.dart';
import 'package:party_planner/src/core/services/preference_service.dart';
import 'package:party_planner/src/core/services/ttrpg_service.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/data/clients/event_client.dart';
import 'package:party_planner/src/data/clients/preference_client.dart';
import 'package:party_planner/src/data/clients/ttrpg_client.dart';

import '../data/clients/user_client.dart';

Future<void> bootstrap() async {
  final IocContainer ioc = IocContainer.container;

  ioc
    ..registerLazySingleton<UserService>(
      () => UserService(
        ioc.get<UserApiClient>(),
      ),
    )
    ..registerFactory<EventsService>(
      () => EventsService(
        apiClient: ioc.get<EventsApiClient>(),
        userService: ioc.get<UserService>(),
      ),
    )
    ..registerFactory<PreferencesService>(
      () => PreferencesService(
        apiClient: ioc.get<PreferencesApiClient>(),
        userService: ioc.get<UserService>(),
      ),
    )
    ..registerFactory<TTRPGService>(
      () => TTRPGService(
        apiClient: ioc.get<TTRPGApiClient>(),
        userService: ioc.get<UserService>(),
      ),
    )
    ..registerFactory<CalendarService>(
      () => CalendarService(),
    );
}

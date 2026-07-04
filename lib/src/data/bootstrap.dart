import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:party_planner/src/core/config/application_settings.dart';
import 'package:party_planner/src/data/clients/event_client.dart';
import 'package:party_planner/src/data/clients/preference_client.dart';
import 'package:party_planner/src/data/clients/ttrpg_client.dart';

import 'clients/user_client.dart';

Future<void> bootstrap() async {
  String baseUrl = ApplicationSettings.baseUrl;
  final IocContainer ioc = IocContainer.container;

  ioc
    ..registerFactory<UserApiClient>(
      () => UserApiClient(baseUrl),
    )
    ..registerFactory<EventsApiClient>(
      () => EventsApiClient(baseUrl),
    )
    ..registerFactory<PreferencesApiClient>(
      () => PreferencesApiClient(baseUrl),
    )
    ..registerFactory<TTRPGApiClient>(
      () => TTRPGApiClient(baseUrl),
    );
}

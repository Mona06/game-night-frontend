import 'package:flutter/material.dart';
import 'package:flutter_ioc_get_it/flutter_ioc_get_it.dart';
import 'package:party_planner/src/data/bootstrap.dart' as data;
import 'package:party_planner/src/core/bootstrap.dart' as core;
import 'package:party_planner/src/ui/bootstrap.dart' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GetItIocContainer.register();

  await data.bootstrap();
  await core.bootstrap();
  await ui.bootstrap();
}

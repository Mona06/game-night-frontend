import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import '../../../../core/services/event_service.dart';
import '../home_tab/cubit/home_tab_cubit.dart';
import '../home_tab/home_tab_view.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeTabCubit(
        eventService: Ioc.container.get<EventsService>(),
      )..loadMatchingEvents(),
      child: const HomeTabView(),
    );
  }
}

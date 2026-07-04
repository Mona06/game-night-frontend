import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../connections/view/connections.dart';
import '../../events/view/my_events_view.dart';
import 'home_tab.dart';
import '../../../../ui/widgets/bottom_nav_tab.dart';
import '../../../widgets/nav_bar.dart';
import '../../../widgets/typography/btn.dart';
import '../../event_form/view/create_event_view.dart';
import '../../user_profile/view/profile_view.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  List<Widget> _initializeTabScreens() => [
        HomeTab(),
        ConnectionsView(),
        const MyEventsView(),
        ProfileView(),
      ];

  @override
  Widget build(BuildContext context) {
    final tabScreens = _initializeTabScreens();

    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              floatingActionButton: FloatingBtn(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEventView(),
                    ),
                  );
                },
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterDocked,
              appBar: const TopNavigationBar(),
              body: tabScreens[state.selectedTabIndex],
              bottomNavigationBar: CustomBottomNavigationBar(
                selectedIndex: state.selectedTabIndex,
                onTabSelected: (index) {
                  context.read<HomeCubit>().updateSelectedTab(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

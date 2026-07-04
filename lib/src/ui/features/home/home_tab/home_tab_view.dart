import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:party_planner/src/ui/widgets/typography/btn.dart';

import '../../../widgets/event_card.dart';
import '../../../widgets/shimmer_effect.dart';
import 'cubit/home_tab_cubit.dart';
import 'cubit/home_tab_state.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<HomeTabCubit, HomeTabState>(
          builder: (context, state) {
            return ListView(
              children: [
                _buildContent(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeTabState state) {
    switch (state.status) {
      case HomeTabStatus.loading:
        return Column(
          children: List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: ShimmerEffect(width: 454, height: 200),
            ),
          ),
        );

      case HomeTabStatus.failure:
        return Center(
          child: SolidPrimaryBtn(
            onPressed: () {
              context.read<HomeTabCubit>().loadMatchingEvents();
            },
            text: const Text('Try Again'),
          ),
        );

      case HomeTabStatus.success:
        if (state.events.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Text(
                'No sessions available at this moment.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
              ),
            ),
          );
        }
        return Center(
          child: Column(
            children: [
              Text(
                'Open Games',
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  return EventCard(event: state.events[index]);
                },
              ),
            ],
          ),
        );

      case HomeTabStatus.initial:
        return const SizedBox.shrink();
    }
  }
}

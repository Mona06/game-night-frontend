import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'package:party_planner/src/ui/features/events/cubit/event_details_state.dart';
import '../../../../core/services/event_service.dart';
import '../../../widgets/event_card.dart';
import '../cubit/event_details_cubit.dart';
import '../cubit/event_status_cubit.dart';
import '../cubit/event_status_state.dart';

class MyEventsView extends StatefulWidget {
  const MyEventsView({super.key});

  @override
  State<MyEventsView> createState() => _MyEventsViewState();
}

class _MyEventsViewState extends State<MyEventsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventDetailCubit>(
          create: (context) => EventDetailCubit(
            Ioc.container.get<EventsService>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'My games',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Tentative'),
              Tab(text: 'Confirmed'),
              Tab(text: 'Hosted'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            EventListTab(tabIndex: 0),
            EventListTab(tabIndex: 1),
            EventListTab(tabIndex: 2),
          ],
        ),
      ),
    );
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      final eventStatusCubit = context.read<EventStatusCubit>();

      switch (_tabController.index) {
        case 0:
          eventStatusCubit.loadTentativeEvents();
          break;
        case 1:
          eventStatusCubit.loadConfirmedEvents();
          break;
        case 2:
          eventStatusCubit.loadHostedEvents();
          break;
      }
    }
  }
}

class EventListTab extends StatefulWidget {
  final int tabIndex;

  const EventListTab({
    super.key,
    required this.tabIndex,
  });

  @override
  State<EventListTab> createState() => _EventListTabState();
}

class _EventListTabState extends State<EventListTab> {
  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    if (!mounted) return;

    final eventStatusCubit = context.read<EventStatusCubit>();

    switch (widget.tabIndex) {
      case 0:
        eventStatusCubit.loadTentativeEvents();
        break;
      case 1:
        eventStatusCubit.loadConfirmedEvents();
        break;
      case 2:
        eventStatusCubit.loadHostedEvents();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailCubit, EventDetailState>(
      builder: (context, eventDetailState) {
        return BlocBuilder<EventStatusCubit, EventStatusState>(
          builder: (context, eventStatusState) {
            final events = eventStatusState.events;

            if (eventStatusState is EventStatusLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (eventStatusState is EventStatusError) {
              return Center(
                child: Text('Error: ${eventStatusState.message}'),
              );
            }

            if (events.isEmpty) {
              return const Center(
                child: Text('No events found'),
              );
            }

            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  event: event,
                );
              },
            );
          },
        );
      },
    );
  }
}

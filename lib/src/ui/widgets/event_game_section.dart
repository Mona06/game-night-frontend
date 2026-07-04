import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';

import '../../core/models/ttrpg.dart';
import '../../core/services/ttrpg_service.dart';
import '../features/event_form/cubit/create_event_cubit.dart';
import '../features/event_form/cubit/create_event_state.dart';
import 'typography/styled_dropdown.dart';

class EventGameSection extends StatelessWidget {
  const EventGameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventCubit, CreateEventState>(
      builder: (context, state) {
        return _GameSelectionContent(
          selectedGame: state.selectedGame,
          onGameUpdated: (game) {
            context.read<CreateEventCubit>().updateSelectedGame(game);
          },
        );
      },
    );
  }
}

class _GameSelectionContent extends StatefulWidget {
  final String? selectedGame;
  final Function(String?) onGameUpdated;

  const _GameSelectionContent({
    required this.selectedGame,
    required this.onGameUpdated,
  });

  @override
  _GameSelectionContentState createState() => _GameSelectionContentState();
}

class _GameSelectionContentState extends State<_GameSelectionContent> {
  final TTRPGService _ttrpgService = Ioc.container.get<TTRPGService>();
  List<String> _availableGames = [];

  @override
  void initState() {
    super.initState();
    _retrieveTTRPGs();
  }

  Future<void> _retrieveTTRPGs() async {
    final List<TTRPGRead> allGames = await _ttrpgService.getAllTTRPGs();
    setState(() {
      _availableGames = allGames.map((ttrpg) => ttrpg.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select a game for the session',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 12),
        StyledDropdown<String>(
          icon: Icon(
            Icons.sports_esports_outlined,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          items: _availableGames,
          value: widget.selectedGame,
          hint: 'Select ttrpg',
          labelText: 'TTRPG',
          onChanged: (String? value) {
            if (value != null) {
              context.read<CreateEventCubit>().updateSelectedGame(value);
            }
          },
          itemBuilder: (item) => Text(item),
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ],
    );
  }
}

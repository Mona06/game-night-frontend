import 'package:flutter/material.dart';
import 'package:flutter_ioc/flutter_ioc.dart';

import '../../core/models/ttrpg.dart';
import '../../core/services/ttrpg_service.dart';
import '../features/event_form/widgets/custom_chip.dart';
import 'typography/styled_dropdown.dart';

class GamesSection extends StatefulWidget {
  final List<String> selectedGames;
  final Function(List<String>) onGamesUpdated;
  final Widget? selectedCountWidget;

  const GamesSection({
    super.key,
    required this.selectedGames,
    required this.onGamesUpdated,
    this.selectedCountWidget,
  });

  @override
  GamesSectionState createState() => GamesSectionState();
}

class GamesSectionState extends State<GamesSection> {
  final TTRPGService _ttrpgService = Ioc.container.get<TTRPGService>();
  List<String> ttrpgs = [];

  @override
  void initState() {
    super.initState();
    _retrieveTTRPGs();
  }

  Future<void> _retrieveTTRPGs() async {
    final List<TTRPGRead> allGames = await _ttrpgService.getAllTTRPGs();
    setState(() {
      ttrpgs = allGames.map((ttrpg) => ttrpg.name).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Select ttrpgs you enjoy playing',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            if (widget.selectedCountWidget != null &&
                widget.selectedGames.isNotEmpty)
              widget.selectedCountWidget!,
          ],
        ),
        const SizedBox(height: 12),
        StyledDropdown<String>(
          icon: Icon(
            Icons.sports_esports_outlined,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          items: ttrpgs,
          value: null,
          hint: widget.selectedGames.isEmpty
              ? 'Select your favorite games'
              : 'Add more games',
          labelText: 'TTRPGs',
          onChanged: (String? value) {
            if (value != null && !widget.selectedGames.contains(value)) {
              final updatedGames = List<String>.from(widget.selectedGames)
                ..add(value);
              widget.onGamesUpdated(updatedGames);
            }
          },
          itemBuilder: (item) => Text(item),
          fillColor: Theme.of(context).colorScheme.surface,
        ),
        if (widget.selectedGames.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: widget.selectedGames.map((game) {
              return PrimaryBadge(
                label: game,
                onDelete: () {
                  final updatedGames =
                      widget.selectedGames.where((g) => g != game).toList();
                  widget.onGamesUpdated(updatedGames);
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

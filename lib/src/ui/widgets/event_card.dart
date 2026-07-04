import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ioc/flutter_ioc.dart';
import 'dart:convert';
import '../../core/models/event.dart';
import '../../core/services/event_service.dart';
import '../features/events/cubit/event_details_cubit.dart';
import '../features/events/view/event_details_view.dart';

class EventCard extends StatelessWidget {
  final EventRead event;

  const EventCard({super.key, required this.event});

  Uint8List? _getImageData() {
    if (event.coverImage == null) return null;
    try {
      return base64Decode(event.coverImage!);
    } catch (e) {
      debugPrint('Error decoding image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final imageData = _getImageData();

    return SizedBox(
      width: 454,
      // height: 200,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: colorScheme.outlineVariant, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: colorScheme.surface,
        child: InkWell(
          onTap: () => _navigateToEventDetail(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: imageData != null
                    ? Image.memory(
                        imageData,
                        height: 118,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 118,
                        width: double.infinity,
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event.title != null)
                      Text(
                        event.title!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        if (event.city != null)
                          Expanded(
                            child: Text(
                              event.city!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text('${event.maxParticipants} spots left'),
                          backgroundColor: colorScheme.secondaryContainer,
                          labelStyle: TextStyle(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToEventDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) => EventDetailCubit(
            Ioc.container.get<EventsService>(),
          ),
          child: EventDetailView(event: event),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:party_planner/src/core/helpers/format.dart';
import 'package:party_planner/src/ui/widgets/typography/app_theme.dart';

class Dialogs {
  static Future<bool?> showProfileDeletionDialog(BuildContext context) {
    final theme = MaterialTheme.lightScheme();

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Profile',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        content: Text(
          'Are you sure you want to delete your profile?\n'
          'This action cannot be undone.',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        backgroundColor: theme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: theme.onErrorContainer,
              backgroundColor: theme.errorContainer,
            ),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              foregroundColor: theme.onPrimary,
              backgroundColor: theme.primary,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class DialogConfig {
  final String title;
  final String content;
  final List<DialogAction> actions;

  const DialogConfig({
    required this.title,
    required this.content,
    required this.actions,
  });
}

class DialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const DialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });
}

class SessionDetails {
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String address;

  const SessionDetails({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.address,
  });

  String get formattedTime => '$startTime - $endTime';

  String get formattedDate => date.getFormattedDate();
}

class LocationDetails {
  final String address;

  const LocationDetails({required this.address});
}

class ConfirmationDialogFactory {
  static DialogConfig createSessionConfirmation({
    required SessionDetails session,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return DialogConfig(
      title: 'Scheduled Game Session',
      content: _buildSessionContent(session),
      actions: _createDefaultActions(onConfirm, onCancel),
    );
  }

  static DialogConfig createLocationConfirmation({
    required LocationDetails location,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return DialogConfig(
      title: 'Confirm Location',
      content: _buildLocationContent(location),
      actions: _createDefaultActions(onConfirm, onCancel),
    );
  }

  static DialogConfig createProfileDeleteConfirmation({
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    return DialogConfig(
      title: 'Delete Profile',
      content: _buildProfileDeleteContent(),
      actions: _createDefaultActions(onConfirm, onCancel),
    );
  }

  static String _buildSessionContent(SessionDetails session) {
    return '''
Date: ${session.formattedDate}
Time: ${session.formattedTime}
Location: ${session.address}
''';
  }

  static String _buildLocationContent(LocationDetails location) {
    return 'Found location: ${location.address}';
  }

  static String _buildProfileDeleteContent() {
    return 'Are you sure you want to delete your profile?\n'
        'This action cannot be undone.';
  }

  static List<DialogAction> _createDefaultActions(
    VoidCallback onConfirm,
    VoidCallback onCancel,
  ) {
    return [
      DialogAction(
        label: 'Cancel',
        onPressed: onCancel,
      ),
      DialogAction(
        label: 'Confirm',
        onPressed: onConfirm,
        isPrimary: true,
      ),
    ];
  }
}

class ConfirmationDialog extends StatelessWidget {
  final DialogConfig config;

  const ConfirmationDialog({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final theme = MaterialTheme.lightScheme();

    return AlertDialog(
      title: Text(
        config.title,
        style: Theme.of(context).textTheme.displaySmall,
      ),
      content: Text(
        config.content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      backgroundColor: theme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      actions: config.actions.map((action) {
        final style = action.isPrimary
            ? ElevatedButton.styleFrom(
                foregroundColor: theme.onPrimary,
                backgroundColor: theme.primary,
              )
            : TextButton.styleFrom(
                foregroundColor: theme.onSecondaryContainer,
                backgroundColor: theme.secondaryContainer,
              );

        return action.isPrimary
            ? ElevatedButton(
                onPressed: () {
                  action.onPressed();
                  Navigator.of(context).pop();
                },
                style: style,
                child: Text(action.label),
              )
            : TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: style,
                child: Text(action.label),
              );
      }).toList(),
    );
  }
}

class DialogService {
  static Future<void> showConfirmationDialog(
    BuildContext context,
    DialogConfig config,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => ConfirmationDialog(config: config),
    );
  }
}

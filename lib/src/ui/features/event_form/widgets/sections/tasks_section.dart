import 'package:flutter/material.dart';

import '../../../../../ui/widgets/snackbar.dart';
import '../../../../widgets/typography/btn.dart';
import '../../../../widgets/typography/text_field.dart';
import '../../../../../core/helpers/validator.dart';
import '../custom_chip.dart';

class EventTasksSection extends StatefulWidget {
  final List<String>? tasks;
  final void Function(String task) addTask;
  final void Function(String task) deleteTask;
  final int hostId;

  EventTasksSection({
    super.key,
    required this.tasks,
    required this.deleteTask,
    required this.addTask,
    required this.hostId,
  });

  @override
  State<EventTasksSection> createState() => _EventTasksSectionState();
}

class _EventTasksSectionState extends State<EventTasksSection> {
  final taskTitleFieldController = TextEditingController();
  final taskDescrFieldController = TextEditingController();
  bool? isUserHost;

  @override
  void initState() {
    super.initState();
    _checkHostStatus();
  }

  Future<void> _checkHostStatus() async {
    final hostStatus = await isHost(widget.hostId);
    setState(() {
      isUserHost = hostStatus;
    });
  }

  @override
  void dispose() {
    taskTitleFieldController.dispose();
    taskDescrFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tasks',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            if (isUserHost == true) _buildManageTasksBtn(context),
          ],
        ),
        const SizedBox(height: 8),
        _buildTaskList(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildManageTasksBtn(BuildContext context) {
    return TertiaryBtn(
      icon: Icon(Icons.edit_outlined, color: Theme.of(context).primaryColor),
      text: Text(
        'Edit',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      onPressed: () => _displayTaskDialog(context),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.tasks?.map((task) {
            return SecondaryBadge(
              label: task,
              onDelete:
                  isUserHost == true ? () => widget.deleteTask(task) : null,
            );
          }).toList() ??
          [],
    );
  }

  Future<void> _displayTaskDialog(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext dialogContext) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add a new task'),
              leading: IconButton(
                icon: const Icon(
                  Icons.close_outlined,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  GradientTextField(
                    controller: taskTitleFieldController,
                    labelText: 'Title',
                    hint: 'Enter task title',
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 16),
                  GradientTextField(
                    labelText: 'Description',
                    hint: 'Enter task description',
                    controller: taskDescrFieldController,
                    maxLines: 3,
                    onChanged: (_) {},
                  ),
                  const SizedBox(height: 16),
                  const Spacer(),
                  SolidPrimaryBtn(
                    text: Text(
                      'Done',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    onPressed: () {
                      if (taskTitleFieldController.text.isNotEmpty) {
                        widget.addTask(taskTitleFieldController.text);
                        AppSnackBar.show(
                          message:
                              '${taskTitleFieldController.text} added to tasks',
                          type: SnackBarType.success,
                        );
                        taskTitleFieldController.clear();
                        taskDescrFieldController.clear();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

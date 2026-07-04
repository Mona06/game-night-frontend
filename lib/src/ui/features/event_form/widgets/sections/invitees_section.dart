import 'package:flutter/material.dart';
import 'package:flutter_ioc/flutter_ioc.dart';

import '../../../../widgets/typography/btn.dart';
import '../../../../widgets/typography/text_field.dart';
import '../../../../../core/helpers/validator.dart';
import '../../../../../core/models/user.dart';
import '../../../../../core/services/user_service.dart';
import '../custom_chip.dart';

class InviteesSection extends StatefulWidget {
  final UserService _userService = Ioc.container.get<UserService>();
  final List<UserPublic> invitees;
  final int hostId;
  final Function(UserPublic) onDeleteUser;
  final Function(UserPublic) onAddUser;
  final String? title;

  InviteesSection({
    super.key,
    required this.invitees,
    required this.hostId,
    required this.onDeleteUser,
    required this.onAddUser,
    this.title = 'Invitees',
  });

  @override
  State<InviteesSection> createState() => _InviteesSectionState();
}

class _InviteesSectionState extends State<InviteesSection> {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title!,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            const SizedBox(height: 8),
            if (isUserHost == true) _buildManageInviteesBtn(context),
          ],
        ),
        const SizedBox(height: 8),
        _buildSelectedInvitees(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildManageInviteesBtn(BuildContext context) {
    return TertiaryBtn(
      icon: Icon(Icons.edit_outlined, color: Theme.of(context).primaryColor),
      text: Text(
        'Edit',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      onPressed: () => _displayInviteeDialog(context),
    );
  }

  Widget _buildSelectedInvitees(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.invitees.map((user) {
        return SecondaryBadge(
          label: user.displayName!,
          onDelete: isUserHost == true ? () => widget.onDeleteUser(user) : null,
        );
      }).toList(),
    );
  }

  Future<void> _displayInviteeDialog(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (BuildContext dialogContext) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Add users'),
              leading: IconButton(
                icon: Icon(
                  Icons.close_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: _SearchInviteesSheet(
              userService: widget._userService,
              currentInvitees: widget.invitees,
              onAddUser: widget.onAddUser,
              onDeleteUser: widget.onDeleteUser,
            ),
          );
        },
      ),
    );
  }
}

class _SearchInviteesSheet extends StatefulWidget {
  final UserService userService;
  final List<UserPublic> currentInvitees;
  final Function(UserPublic) onAddUser;
  final Function(UserPublic) onDeleteUser;

  const _SearchInviteesSheet({
    required this.userService,
    required this.currentInvitees,
    required this.onAddUser,
    required this.onDeleteUser,
  });

  @override
  State<_SearchInviteesSheet> createState() => _SearchInviteesSheetState();
}

class _SearchInviteesSheetState extends State<_SearchInviteesSheet> {
  List<UserPublic> searchResults = [];
  String currentQuery = '';

  @override
  void initState() {
    super.initState();
    currentQuery = "";
    _performSearch(currentQuery);
  }

  void _performSearch(String query) async {
    try {
      final List<UserPublic> allUsers = await widget.userService.getUsers();
      final List<UserPublic> results = allUsers
          .where(
            (user) =>
                user.displayName!.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      setState(() {
        searchResults = results;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching users: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          GradientTextField(
            hint: 'Search users...',
            icon: const Icon(
              Icons.search_outlined,
            ),
            onChanged: (newQuery) {
              setState(() {
                currentQuery = newQuery;
                _performSearch(newQuery);
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final user = searchResults[index];
                var isSelected = widget.currentInvitees.contains(user);
                return ListTile(
                  title: Text(user.displayName!),
                  trailing: IconButton(
                    icon: Icon(
                      isSelected ? Icons.check_outlined : Icons.add_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isSelected) {
                          widget.onDeleteUser(user);
                          isSelected = false;
                        } else {
                          widget.onAddUser(user);
                          isSelected = true;
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SolidPrimaryBtn(
            text: Text(
              'Done',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

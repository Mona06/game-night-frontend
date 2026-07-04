import 'package:flutter/material.dart';

import '../../user_profile/view/profile_view.dart';

class UserCard extends StatelessWidget {
  final int userId;
  final String username;
  final String? displayName;

  const UserCard({
    super.key,
    required this.userId,
    required this.username,
    this.displayName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: () => navigateToUserProfile(context, userId),
        leading: CircleAvatar(
          child: Text(username[0].toUpperCase()),
        ),
        title: Text(
          displayName ?? username,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '@$username',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.add_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            // TODO: Implement add friend/connect functionality
          },
        ),
      ),
    );
  }

  void navigateToUserProfile(BuildContext context, int userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileView(userId: userId),
      ),
    );
  }
}

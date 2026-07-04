import 'package:flutter/material.dart';

class NotificationsView extends StatefulWidget {
  @override
  NotificationsViewState createState() => NotificationsViewState();
}

class NotificationsViewState extends State<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    List<String> notifications = [
      'Notification 1: Lorem ipsum dolor sit amet.',
      'Notification 2: Consectetur adipiscing elit.',
      'Notification 3: Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 250,
                      child: Stack(
                        children: [
                          // Your existing notification icon stack
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        color: Color(0xFF121212),
                        fontSize: 24,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'When you have notifications from your activity, they’ll appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFA4A4A4),
                        fontSize: 14,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        notifications[index],
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

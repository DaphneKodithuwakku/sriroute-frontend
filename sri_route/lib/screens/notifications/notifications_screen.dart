import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notification_model.dart';
import '../../services/notification_service.dart';


// StatefulWidget to handle notifications screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}
class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Mark all notifications as read when opening the screen
    NotificationService.markAllAsRead();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar for the notifications screen
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          // Popup menu to clear all notifications
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'clear_all') {
                await _showDeleteConfirmationDialog();
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'clear_all',
                child: Text('Clear all'),
              ),
            ],
          ),
        ],
         // StreamBuilder listens to the notifications stream and rebuilds the UI when new data arrives
      ),body: StreamBuilder<List<EventNotification>>(
        stream: NotificationService.getNotifications(),
        builder: (context, snapshot) {
          // Show a loading indicator if the connection state is waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // Show error message if there's an error
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
           // Get the list of notifications from the snapshot
          final notifications = snapshot.data ?? [];
          

          // If there are no notifications, display a "No notifications" message
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }
          // If there are notifications, display them in a ListView
          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return _buildNotificationItem(notification);
            },
          );
        },
      ),
    );
    // Build each notification item in the list
  }Widget _buildNotificationItem(EventNotification notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      // Direction in which the swipe to dismiss is allowed
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Delete the notification from Firestore
        NotificationService.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            // Show a snackbar to confirm deletion
            content: Text('Notification deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      },
           // Notification card displaying the details
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: notification.isRead ? Colors.blue.shade100 : Colors.blue,
            child: const Icon(
              Icons.event,
              color: Colors.white,
            ),
          ),
          // Title of the notification
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          // Subtitle displaying body and event date
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.body),
              const SizedBox(height: 4),
              Text(
                'Event date: ${DateFormat('MMM dd, yyyy').format(notification.eventDate)}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          isThreeLine: true,// Allow for three lines in the notification item
          trailing: Text(
            _formatNotificationDate(notification.createdAt),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          // On tap, mark notification as read and navigate to event details (if applicable)
          onTap: () {
            // Mark as read if not already
            if (!notification.isRead) {
              NotificationService.markAsRead(notification.id);
            }
            
            // Navigate to event detail if needed
            
          },
        ),
      ),
    );
  }
  

  // Helper function to format notification creation date
  String _formatNotificationDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    // Return relative time (e.g., "2d ago", "1h ago")
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
  
  // Confirmation dialog to clear all notifications
  Future<void> _showDeleteConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all notifications?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('CLEAR ALL'),
          ),
        ],
      ),
    );
     // If confirmed, clear all notifications
    if (result == true) {
      await NotificationService.deleteAllNotifications();
    }
  }
}
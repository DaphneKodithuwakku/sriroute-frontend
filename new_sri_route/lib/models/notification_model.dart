import 'package:cloud_firestore/cloud_firestore.dart';

class EventNotification {
  final String id;
  final String title;
  final String body;
  final DateTime eventDate;
  final String eventId;
  final DateTime createdAt;
  final DateTime? scheduledFor; // Add scheduled time field
  bool isRead;

  EventNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.eventDate,
    required this.eventId,
    required this.createdAt,
    this.scheduledFor,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'eventDate': eventDate,
      'eventId': eventId,
      'createdAt': createdAt,
      'scheduledFor': scheduledFor, // Include scheduled time in map
      'isRead': isRead,
    };
  }

  factory EventNotification.fromMap(String id, Map<String, dynamic> map) {
    return EventNotification(
      id: id,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      eventDate: (map['eventDate'] as Timestamp).toDate(),
      eventId: map['eventId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      scheduledFor: map['scheduledFor'] != null 
          ? (map['scheduledFor'] as Timestamp).toDate() 
          : null,
      isRead: map['isRead'] ?? false,
    );
  }
}

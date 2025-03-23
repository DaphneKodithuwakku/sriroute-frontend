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
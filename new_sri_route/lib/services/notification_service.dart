import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Initialize notifications - simplified version without local notifications
  static Future<void> initializeNotifications() async {
    // Nothing to initialize for Firebase-only notifications
    debugPrint('Firebase notification service initialized');
  }
  
  // Stream of notifications for current user
  static Stream<List<EventNotification>> getNotifications() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return EventNotification.fromMap(doc.id, doc.data());
          }).toList();
        });
  }
  
  // Get unread notification count
  static Stream<int> getUnreadCount() {
    return getNotifications().map((notifications) {
      return notifications.where((notification) => !notification.isRead).length;
    });
  }
  
  // Add an event reminder for 24 hours before event
  static Future<void> addEventReminder(
    String eventId, 
    String eventTitle, 
    DateTime eventDate,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }
    
    // Calculate notification time (24 hours before event)
    final notificationTime = eventDate.subtract(const Duration(hours: 24));
    final now = DateTime.now();
    
    // Only allow if the notification time is in the future
    if (notificationTime.isBefore(now)) {
      throw Exception('Cannot set reminder for past events or events less than 24 hours away');
    }
    
    // Check for duplicate notifications
    final existingQuery = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('eventId', isEqualTo: eventId)
        .get();
        
    if (existingQuery.docs.isNotEmpty) {
      // Update existing notification instead of creating a new one
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(existingQuery.docs.first.id)
          .update({
            'createdAt': now,
            'isRead': false, // Mark as unread since it's being re-added
          });
      return;
    }
    
    // Create notification content with updated message
    final notification = EventNotification(
      id: '', // Will be set by Firestore
      title: 'Event Reminder',
      body: 'Your event "$eventTitle" is happening on ${_formatEventDate(eventDate)}',
      eventDate: eventDate,
      eventId: eventId,
      createdAt: now,
      scheduledFor: notificationTime, // Store scheduled time
    );
    
    // Add to Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .add(notification.toMap());
  }
  
  // Helper method to format event date in a readable format
  static String _formatEventDate(DateTime date) {
    // Format date as "Month Day, Year" (e.g., "January 15, 2025")
    return "${date.month}/${date.day}/${date.year}";
  }

  // Mark notification as read
  static Future<void> markAsRead(String notificationId) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
  
  // Mark all notifications as read
  static Future<void> markAllAsRead() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    
    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();
        
    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    
    await batch.commit();
  }
  
  // Delete a notification
  static Future<void> deleteNotification(String notificationId) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
  
  // Delete all notifications
  static Future<void> deleteAllNotifications() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    
    final batch = _firestore.batch();
    final notifications = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .get();
        
    for (var doc in notifications.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }
  
  // Clean up old notifications (older than 30 days)
  static Future<void> cleanupOldNotifications() async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }
    
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    
    final oldNotifications = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('createdAt', isLessThan: thirtyDaysAgo)
        .get();
        
    final batch = _firestore.batch();
    for (var doc in oldNotifications.docs) {
      batch.delete(doc.reference);
    }
    
    await batch.commit();
  }
}

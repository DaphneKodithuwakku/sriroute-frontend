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
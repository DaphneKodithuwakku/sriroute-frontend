import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/notification_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EventCalendarScreen(),
  ));
}

class Event {
  final String title;
  final DateTime date;
  final String location;
  final String description;
  bool isFavorite;  // Added isFavorite property

  Event({
    required this.title, 
    required this.date, 
    required this.location, 
    required this.description,
    this.isFavorite = false,  // Default to not favorite
  });

  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'location': location,
      'description': description,
      'isFavorite': isFavorite,
    };
  }
import 'package:flutter/material.dart';

/// Represents a pilgrimage site recommendation from Gemini API
class PilgrimageRecommendation {
  final String name;
  final String description;
  final String historicalSignificance;
  final String bestTimeToVisit;
  final String estimatedDuration;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String? distanceFromStart;
  final String? travelTimeByCarFromStart;
  final DateTime? calculatedAt;  // When the travel info was calculated
  final Map<String, dynamic>? additionalInfo;  // For any extra information

  PilgrimageRecommendation({
    required this.name,
    required this.description,
    required this.historicalSignificance,
    required this.bestTimeToVisit,
    required this.estimatedDuration,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    this.distanceFromStart,
    this.travelTimeByCarFromStart,
    this.calculatedAt,
    this.additionalInfo,
  });

  factory PilgrimageRecommendation.fromJson(Map<String, dynamic> json) {
    return PilgrimageRecommendation(
      name: json['name'] as String,
      description: json['description'] as String,
      historicalSignificance: json['historicalSignificance'] as String,
      bestTimeToVisit: json['bestTimeToVisit'] as String,
      estimatedDuration: json['estimatedDuration'] as String,
      latitude: (json['latitude'] is int)
          ? (json['latitude'] as int).toDouble()
          : json['latitude'] as double,
      longitude: (json['longitude'] is int)
          ? (json['longitude'] as int).toDouble()
          : json['longitude'] as double,
      imageUrl: json['imageUrl'] as String,
      distanceFromStart: json['distanceFromStart'] as String?,
      travelTimeByCarFromStart: json['travelTimeByCarFromStart'] as String?,
      calculatedAt: json['calculatedAt'] != null 
          ? DateTime.parse(json['calculatedAt'] as String) 
          : null,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'historicalSignificance': historicalSignificance,
      'bestTimeToVisit': bestTimeToVisit,
      'estimatedDuration': estimatedDuration,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'distanceFromStart': distanceFromStart,
      'travelTimeByCarFromStart': travelTimeByCarFromStart,
      'calculatedAt': calculatedAt?.toIso8601String(),
      'additionalInfo': additionalInfo,
    };
  }
}

/// Represents user location data
class UserLocation {
  final double latitude;
  final double longitude;
  final String address;
  final String district;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.district,
  });
}
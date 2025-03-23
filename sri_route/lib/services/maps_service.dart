import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as dart;
import 'dart:math' show pi;

class MapsService {
  // Singleton pattern
  static final MapsService _instance = MapsService._internal();
  factory MapsService() => _instance;
  MapsService._internal();

  // API key for Google Maps services
  // Replace with your actual Google Maps API key that has Directions API enabled
  static const String apiKey = 'AIzaSyDW2rIuK8kD5XBCGlMQQocVD43GGUas0bM';

  // Improve the travel info calculation with more realistic estimates
  Future<Map<String, String>> getTravelInfo(
      double startLat, double startLng, double endLat, double endLng) async {
    try {
      // First try to use Google Directions API for accurate info
      final response = await http
          .get(Uri.parse('https://maps.googleapis.com/maps/api/directions/json?'
              'origin=$startLat,$startLng'
              '&destination=$endLat,$endLng'
              '&mode=driving'
              '&key=$apiKey'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          var routes = data['routes'] as List;
          if (routes.isNotEmpty) {
            var legs = routes[0]['legs'] as List;
            if (legs.isNotEmpty) {
              var distance = legs[0]['distance']['text'];
              var duration = legs[0]['duration']['text'];

              return {
                'distance': distance,
                'duration': duration,
              };
            }
          }
        } else {
          debugPrint("Google Directions API error: ${data['status']}");
        }
      }

      // Fallback to estimation if API call fails
      debugPrint("Using distance estimation as fallback");
      return estimateTravelInfo(startLat, startLng, endLat, endLng);
    } catch (e) {
      debugPrint("Error getting travel info: $e");
      return estimateTravelInfo(startLat, startLng, endLat, endLng);
    }
  }

  // Improve the estimation algorithm
  Map<String, String> estimateTravelInfo(
      double startLat, double startLng, double endLat, double endLng) {
    try {
      // Calculate straight-line distance (Haversine formula)
      const double earthRadius = 6371; // kilometers

      final double latDiff = _toRadians(endLat - startLat);
      final double lngDiff = _toRadians(endLng - startLng);

      final double a = sin(latDiff / 2) * sin(latDiff / 2) +
          cos(_toRadians(startLat)) *
              cos(_toRadians(endLat)) *
              sin(lngDiff / 2) *
              sin(lngDiff / 2);

      final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
      final double distance = earthRadius * c;

      // Add 30% to account for roads not being straight lines
      final double roadDistance = distance * 1.3;

      // Estimate travel time with variable speed based on distance
      // Shorter distances typically have slower average speeds due to local roads
      double avgSpeedKmh;
      if (roadDistance < 5) {
        avgSpeedKmh = 25; // City center/local roads
      } else if (roadDistance < 20) {
        avgSpeedKmh = 35; // Main city roads
      } else if (roadDistance < 50) {
        avgSpeedKmh = 50; // Highways with some traffic
      } else {
        avgSpeedKmh = 60; // Highways/expressways
      }

      final double travelTimeHours = roadDistance / avgSpeedKmh;
      final int travelTimeMinutes = (travelTimeHours * 60).round();

      // Format the results
      String distanceText;
      if (roadDistance < 1) {
        distanceText = '${(roadDistance * 1000).round()} m';
      } else {
        distanceText = '${roadDistance.toStringAsFixed(1)} km';
      }

      String durationText;
      if (travelTimeMinutes < 60) {
        durationText = '$travelTimeMinutes min';
      } else {
        final int hours = travelTimeMinutes ~/ 60;
        final int minutes = travelTimeMinutes % 60;
        durationText = '$hours h ${minutes > 0 ? '$minutes min' : ''}';
      }

      return {
        'distance': distanceText,
        'duration': durationText,
      };
    } catch (e) {
      debugPrint("Error in travel estimation: $e");
      return {
        'distance': 'Unknown',
        'duration': 'Unknown',
      };
    }
  }

  double _toRadians(double degrees) => degrees * pi / 180;

  double sin(double x) => _castToDouble(dart.sin(x));
  double cos(double x) => _castToDouble(dart.cos(x));
  double sqrt(double x) => _castToDouble(dart.sqrt(x));
  double atan2(double y, double x) => _castToDouble(dart.atan2(y, x));

  double _castToDouble(num value) => value.toDouble();
}

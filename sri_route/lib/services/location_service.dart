import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // API key for Google Maps services
  // This should match with the key used in your Google Maps widget
  static const String googleMapsApiKey =
      'AIzaSyDW2rIuK8kD5XBCGlMQQocVD43GGUas0bM';

  // Check if location services are enabled and request permission
  Future<bool> checkLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Checking location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Requesting to open app settings to enable permission
      await openAppSettings();
      return false;
    }

    return true;
  }

  // Updating getCurrentLocation to include timestamp
  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await checkLocationPermission();

    if (!hasPermission) {
      debugPrint('Location permission denied');
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Log success
      debugPrint(
          'Location obtained: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  // Add a method to get address with better error handling
  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // Building more detailed address
        List<String> addressParts = [];

        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        } else if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }

        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }

        String address = addressParts.join(', ');
        return address.isNotEmpty
            ? address
            : 'Location at ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
      }
      return 'Unknown location';
    } catch (e) {
      debugPrint('Error getting address: $e');
      return 'Location at ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
    }
  }

  // Getting district from coordinates
  Future<String?> getDistrictFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String? district = place.subAdministrativeArea;
        if (district != null && district.isNotEmpty) {
          if (!district.toLowerCase().contains('district')) {
            district = '$district District';
          }
          return district;
        }
        return place.administrativeArea;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting district: $e');
      return null;
    }
  }
}

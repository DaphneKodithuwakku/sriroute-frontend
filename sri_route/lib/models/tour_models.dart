import 'package:flutter/material.dart';

/// Represents a tour location (temple, church, mosque, etc.)
class TourLocation {
  final String id;
  final String name;
  final String description;
  final String thumbnailUrl;
  final List<TourPoint> tourPoints;

  const TourLocation({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.tourPoints,
  });

  factory TourLocation.fromMap(Map<String, dynamic> map) {
    return TourLocation(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String,
      tourPoints:
          (map['tourPoints'] as List)
              .map((point) => TourPoint.fromMap(point as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'tourPoints': tourPoints.map((point) => point.toMap()).toList(),
    };
  }
}

/// Represents a 360° panorama view point within a tour
class TourPoint {
  final String id;
  final String name;
  final String imageUrl;
  final String? storagePath; // Firebase storage path (optional)
  final List<TourHotspot> hotspots;
  final double initialLongitude; // Starting view position
  final double initialLatitude;

  const TourPoint({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.storagePath,
    required this.hotspots,
    this.initialLongitude = 0.0,
    this.initialLatitude = 0.0,
  });

  factory TourPoint.fromMap(Map<String, dynamic> map) {
    return TourPoint(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
      storagePath: map['storagePath'] as String?,
      initialLongitude: map['initialLongitude'] as double? ?? 0.0,
      initialLatitude: map['initialLatitude'] as double? ?? 0.0,
      hotspots:
          (map['hotspots'] as List?)
              ?.map(
                (hotspot) =>
                    TourHotspot.fromMap(hotspot as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'storagePath': storagePath,
      'initialLongitude': initialLongitude,
      'initialLatitude': initialLatitude,
      'hotspots': hotspots.map((hotspot) => hotspot.toMap()).toList(),
    };
  }
}

/// Represents a hotspot/link point in a panorama view
class TourHotspot {
  final String id;
  final double longitude;
  final double latitude;
  final String targetPointId; // Target point's ID instead of index
  final String label;
  final IconData? icon;
  final Color? color;

  const TourHotspot({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.targetPointId,
    required this.label,
    this.icon,
    this.color,
  });

  factory TourHotspot.fromMap(Map<String, dynamic> map) {
    return TourHotspot(
      id: map['id'] as String,
      longitude: map['longitude'] as double,
      latitude: map['latitude'] as double,
      targetPointId: map['targetPointId'] as String,
      label: map['label'] as String,
      icon:
          map['icon'] != null
              ? IconData(map['icon'] as int, fontFamily: 'MaterialIcons')
              : null,
      color: map['color'] != null ? Color(map['color'] as int) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'longitude': longitude,
      'latitude': latitude,
      'targetPointId': targetPointId,
      'label': label,
      'icon': icon?.codePoint,
      'color': color?.value,
    };
  }
}

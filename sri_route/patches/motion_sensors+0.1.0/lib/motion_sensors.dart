// This is a patched version of the motion_sensors package with the namespace fix
// in the Android build.gradle file, providing minimal implementation needed for Panorama

import 'dart:async';
import 'package:flutter/services.dart';

// Define the event classes needed by panorama
class OrientationEvent {
  // Changed from azimuth to yaw to match what panorama expects
  final double yaw, pitch, roll;
  OrientationEvent(this.yaw, this.pitch, this.roll);
}

class AbsoluteOrientationEvent {
  final double yaw, pitch, roll;
  AbsoluteOrientationEvent(this.yaw, this.pitch, this.roll);
}

class ScreenOrientationEvent {
  final double angle;
  ScreenOrientationEvent(this.angle);
}

// Create a sensor class to handle subscriptions
class Sensor<T> {
  Stream<T> _stream = Stream.empty();
  Stream<T> get onUpdate => _stream;

  // Mock listen method that returns an empty subscription
  StreamSubscription<T> listen(void Function(T event) onData) {
    return _stream.listen(onData);
  }
}

// Main class that panorama uses
class MotionSensors {
  static const MethodChannel _channel = MethodChannel('motion_sensors');

  // Define sensor instances
  final orientation = Sensor<OrientationEvent>();
  final absoluteOrientation = Sensor<AbsoluteOrientationEvent>();
  final screenOrientation = Sensor<ScreenOrientationEvent>();

  // Update intervals (not actually used but required by panorama)
  set orientationUpdateInterval(int interval) {}
  set absoluteOrientationUpdateInterval(int interval) {}

  // Initialize the sensors (dummy implementation)
  static Future<void> initialize() async {}
}

// Export a singleton instance for global use
final motionSensors = MotionSensors();

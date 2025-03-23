import 'package:flutter/material.dart';

class TempleDetailScreen extends StatelessWidget {
  final String templeName;
  final String? storagePath;

  // Define constants for sizes and paddings
  static const double _imageBannerHeight = 300.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalSpacing = 8.0;
  static const double _ratingIconSize = 20.0;
  
  const TempleDetailScreen({
    Key? key, 
    required this.templeName,
    this.storagePath,
  }) : super(key: key);

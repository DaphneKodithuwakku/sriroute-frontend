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

  // Factory constructor to create from route arguments
  factory TempleDetailScreen.fromArguments(dynamic arguments) {
    if (arguments is Map) {
      return TempleDetailScreen(
        templeName: arguments['name'] as String,
        storagePath: arguments['storagePath'] as String?,
      );
    } else {
      return TempleDetailScreen(templeName: arguments as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get temple-specific description
    final String description = _getDescription(templeName);
    final Color overlayColor = Colors.black.withOpacity(0.6);
    
    // Get appropriate asset image based on temple name
    final String imageAsset = _getImageAsset(templeName);
    final String locationText = _getLocationText(templeName);
    
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      imageAsset,
                      height: _imageBannerHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 40,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: _buildVrBadge(overlayColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(_horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRatingRow(),
                      const SizedBox(height: 12),
                      Text(
                        templeName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: _verticalSpacing),
                      Text(
                        locationText,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: _verticalSpacing),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStartTourButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
  } // Return appropriate asset based on temple name
  String _getImageAsset(String templeName) {
    switch (templeName) {
      case 'Sri Dalada Maligawa':
        return 'assets/sri_dalada_maligawa.jpg';
      case 'Jami Ul-Alfar Mosque':
        return 'assets/jami_ul_alfar.jpg';
      case 'Sambodhi Pagoda Temple':
        return 'assets/sambodhi_pagoda.jpg';
      case 'Sacred Heart of Jesus Church':
        return 'assets/sacred_heart_church.jpeg'; // Placeholder
      case 'Ruhunu Maha Kataragama Devalaya':
        return 'assets/kataragama_devalaya.jpeg'; // Placeholder
      default:
        return 'assets/sambodhi_pagoda.jpg';
    }
  }

  // Return appropriate location text based on temple name
  String _getLocationText(String templeName) {
    switch (templeName) {
      case 'Sri Dalada Maligawa':
        return 'Temple in Kandy';
      case 'Jami Ul-Alfar Mosque':
        return 'Mosque in Pettah, Colombo';
      case 'Sambodhi Pagoda Temple':
        return 'Shrine in Colombo';
      case 'Sacred Heart of Jesus Church':
        return 'Church in Rajagiriya';
      case 'Ruhunu Maha Kataragama Devalaya':
        return 'Temple in Kandy';
      default:
        return 'Religious site in Sri Lanka';
    }
  }
  // Extract badge to separate method
  Widget _buildVrBadge(Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.view_in_ar,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(width: 4),
          Text(
            'VR',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  // Extract details section to separate method
  Widget _buildDetailsSection(String description) {
    return Padding(
      padding: const EdgeInsets.all(_horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRatingRow(),
          const SizedBox(height: 12),
          const Text(
            'Sambodhi Pagoda Temple',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: _verticalSpacing),
          Text(
            'Shrine in Colombo',
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
    );
  }
  
  // Extract rating row to a separate method
  Widget _buildRatingRow() {
    return Row(
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: _ratingIconSize,
        ),
        const SizedBox(width: 4),
        const Text(
          '4.6',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: _verticalSpacing),
        Text(
          '(599 reviews)',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  // Extract start tour button to a separate method
  Widget _buildStartTourButton() {
    return Builder(
      builder: (context) => ElevatedButton(
        onPressed: () {
          // Add logging to verify the storage path
          print('Starting tour with storage path: $storagePath');
          
          Navigator.pushNamed(
            context, 
            '/panorama',
            arguments: storagePath,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Start Virtual Tour',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
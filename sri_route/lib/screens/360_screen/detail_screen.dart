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
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
                        style: TextStyle(color: Colors.grey[700], height: 1.5),
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
          Icon(Icons.view_in_ar, color: Colors.white, size: 20),
          SizedBox(width: 4),
          Text(
            'VR',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: _verticalSpacing),
          Text(
            'Shrine in Colombo',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Text(
            'Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: _verticalSpacing),
          Text(
            description,
            style: TextStyle(color: Colors.grey[700], height: 1.5),
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
        const Icon(Icons.star, color: Colors.amber, size: _ratingIconSize),
        const SizedBox(width: 4),
        const Text(
          '4.6',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: _verticalSpacing),
        Text(
          '(599 reviews)',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  // Extract start tour button to a separate method
  Widget _buildStartTourButton() {
    return Builder(
      builder:
          (context) => ElevatedButton(
            onPressed: () {
              // Add logging to verify the storage path
              print('Starting tour with storage path: $storagePath');

              Navigator.pushNamed(context, '/panorama', arguments: storagePath);
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
    );
  }

  String _getDescription(String templeName) {
    switch (templeName) {
      case 'Jami Ul-Alfar Mosque':
        return 'The Jami Ul-Alfar Mosque, widely known as the Red Mosque, is one of Colombo\'s most iconic religious landmarks. Built in 1908 by the city\'s Muslim trading community, the mosque stands as a testament to Sri Lanka\'s rich multicultural heritage. Located in the heart of Pettah, its unique red-and-white patterned exterior makes it one of the most visually striking buildings in Colombo.\n\nDesigned in a blend of Indo-Saracenic, Moorish, Gothic, and Indian architectural styles, its intricate domes, minarets, and symmetrical designs create a truly mesmerizing structure. For the Muslim community, the Red Mosque is not just a place of worship but a symbol of faith and unity.\n\nVisitors are encouraged to dress modestly and visit outside prayer hours to fully appreciate the beauty of this historical masterpiece. Whether for spiritual reflection, historical curiosity, or architectural admiration, the Red Mosque is a must-visit destination for anyone exploring Colombo.';

      case 'Sri Dalada Maligawa':
        return 'The Sri Dalada Maligawa, or Temple of the Sacred Tooth Relic, is Sri Lanka\'s most revered Buddhist temple, located in the historic city of Kandy. This sacred site houses the left canine tooth of Gautama Buddha, making it one of the most important pilgrimage destinations for Buddhists worldwide. Recognized as a UNESCO World Heritage Site, the temple is a symbol of Sri Lanka\'s rich cultural and religious heritage.\n\nThe temple complex features stunning Kandyan architecture, adorned with intricate wood carvings, gold embellishments, and traditional paintings that reflect the artistic grandeur of Sri Lanka\'s royal history. The Esala Perahera, one of Asia\'s grandest Buddhist festivals, takes place annually in Kandy, celebrating the sacred relic.\n\nFor Buddhists, the Temple of the Tooth Relic holds deep spiritual significance. It is believed that whoever possesses the relic holds the divine right to rule the country. Visitors should dress modestly, covering shoulders and knees, and remove footwear before entering as a sign of respect.';

      case 'Sambodhi Pagoda Temple':
        return 'The Sambodhi Pagoda, located near the bustling Pettah district in Colombo, is a distinctive Buddhist temple known for its elevated stupa, which stands atop a large platform supported by two towering concrete arches. Built to be visible from the sea, this unique structure serves as a spiritual beacon for sailors and a peaceful retreat amidst the city\'s vibrant surroundings.\n\nUnlike traditional Buddhist stupas, the Sambodhi Pagoda\'s raised design allows visitors to ascend via a long flight of stairs to reach the main shrine area. This elevation provides stunning panoramic views of Colombo\'s port and skyline, making it a remarkable spot for contemplation and serenity.\n\nThe pagoda was constructed to commemorate Buddha\'s teachings (Dhamma) and the spread of Buddhism across the world. For Buddhists, it serves as a place of meditation and devotion. Visitors should dress modestly, wearing clothing that covers shoulders and knees, and remove footwear before entering the shrine area.';

      case 'Sacred Heart of Jesus Church':
        return 'The Sacred Heart of Jesus Church, located in the suburban area of Rajagiriya, is a significant place of worship for Sri Lanka\'s Catholic community. Known for its serene atmosphere and deep spiritual presence, the church stands as a symbol of faith, devotion, and unity among its congregation.\n\nThe church\'s simple yet elegant design reflects traditional Catholic architecture, featuring a spacious prayer hall, intricate stained-glass windows, and a beautifully adorned altar. The statue of the Sacred Heart of Jesus serves as the central devotion, representing divine love, mercy, and compassion.\n\nThe weekly masses, special feast days, and community gatherings make the Sacred Heart of Jesus Church an important religious and social hub for worshippers. The annual Feast of the Sacred Heart, celebrated with grand processions and religious ceremonies, is a highlight of the church calendar. Visitors should dress modestly and maintain silence inside the church, especially during prayer services.';

      case 'Ruhunu Maha Kataragama Devalaya':
        return 'The Ruhunu Maha Kataragama Devalaya, located in Kandy, is a revered Hindu-Buddhist temple dedicated to Lord Kataragama (Murugan/Skanda), the warrior deity widely worshipped by both Hindus and Buddhists in Sri Lanka. This sacred site is an extension of the famous Kataragama Devalaya in the South and holds immense religious and cultural significance.\n\nThe temple\'s traditional Dravidian-style architecture, with its intricately carved gopuram (entrance tower), colorful murals, and sacred sanctum, reflects the artistic and religious heritage of Hinduism in Sri Lanka. Inside, the shrine houses the idol of Lord Kataragama, adorned with flowers and offerings, creating an atmosphere of devotion and reverence.\n\nBuddhists also revere this temple, as Lord Kataragama is considered a guardian deity (Deva) in Buddhist tradition. For Hindus, the temple is a powerful spiritual center where devotees perform prayers, vows, and traditional offerings such as fruits, flowers, and milk to seek divine blessings. Visitors should dress modestly, covering shoulders and knees, and remove footwear before entering.';

      default:
        return 'A beautiful religious site rich in cultural heritage and spiritual significance. Visitors can explore the unique architecture, witness traditional rituals, and experience the deep devotion of worshippers.';
    }
  }
}

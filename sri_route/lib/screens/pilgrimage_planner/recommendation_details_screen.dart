class RecommendationDetailsScreen extends StatelessWidget {
  final PilgrimageRecommendation recommendation;
  
  const RecommendationDetailsScreen({
    required this.recommendation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image or map at the top
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    recommendation.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            recommendation.latitude,
                            recommendation.longitude,
                          ),
                          zoom: 15,
                        ),
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        markers: {
                          Marker(
                            markerId: MarkerId(recommendation.name),
                            position: LatLng(
                              recommendation.latitude,
                              recommendation.longitude,
                            ),
                          ),
                        },
                      );
                    },
                  ),
                  // Gradient overlay for text visibility
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Title positioned at the bottom of the image
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Text(
                      recommendation.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Enhanced travel information section
            Container(
              color: Colors.teal.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.route, color: Colors.teal, size: 28),
                            const SizedBox(height: 4),
                            const Text(
                              'TRAVEL DISTANCE',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recommendation.distanceFromStart ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.teal.withOpacity(0.3),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.directions_car, color: Colors.teal, size: 28),
                            const SizedBox(height: 4),
                            const Text(
                              'TRAVEL TIME',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recommendation.travelTimeByCarFromStart ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 50,
                        color: Colors.teal.withOpacity(0.3),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.timelapse, color: Colors.teal, size: 28),
                            const SizedBox(height: 4),
                            const Text(
                              'VISIT TIME',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              recommendation.estimatedDuration,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Add timestamp at the bottom
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Travel info calculated at: ${DateTime.now().toString().substring(0, 19)}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content sections
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildInfoSection(
                    'Description',
                    recommendation.description,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoSection(
                    'Historical Significance',
                    recommendation.historicalSignificance,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Best Time to Visit',
                    recommendation.bestTimeToVisit,
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    'Estimated Duration',
                    recommendation.estimatedDuration,
                    Icons.access_time,
                  ),
                  const SizedBox(height: 24),
                  _buildMapSection(context),
                  const SizedBox(height: 24),
                  // Action buttons at the bottom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        'Navigate',
                        Icons.directions,
                        () => _launchMapsUrl(),
                      ),
                      _buildActionButton(
                        'Share',
                        Icons.share,
                        () => _sharePlace(),
                      ),
                      _buildActionButton(
                        'Save',
                        Icons.bookmark_border,
                        () => _savePlace(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }
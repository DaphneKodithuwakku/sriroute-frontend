import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/pilgrimage_models.dart';
import '../../services/gemini_service.dart';
import '../../models/location_model.dart';
import '../../services/maps_service.dart';
import 'recommendation_details_screen.dart';

class RecommendationsScreen extends StatefulWidget {
  final String religion;
  final String dateRange;
  final String region;
  final String locationName;
  final LocationModel userLocation;

  const RecommendationsScreen({
    required this.religion,
    required this.dateRange,
    required this.region,
    required this.locationName,
    required this.userLocation,
    super.key,
  });

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  late Future<List<PilgrimageRecommendation>> _recommendationsFuture;
  final MapsService _mapsService = MapsService();

  @override
  void initState() {
    super.initState();
    _recommendationsFuture = _loadRecommendations();
  }

  Future<List<PilgrimageRecommendation>> _loadRecommendations() async {
    final geminiService = GeminiService();
    final recommendations = await geminiService.getPilgrimageRecommendations(
      religion: widget.religion,
      dateRange: widget.dateRange,
      region: widget.region,
      locationName: widget.locationName,
      userLatitude: widget.userLocation.latitude,
      userLongitude: widget.userLocation.longitude,
    );
    
    // Enhance recommendations with travel info
    final enhancedRecommendations = <PilgrimageRecommendation>[];
    
    for (final recommendation in recommendations) {
      final travelInfo = await _mapsService.getTravelInfo(
        widget.userLocation.latitude, 
        widget.userLocation.longitude,
        recommendation.latitude,
        recommendation.longitude
      );
      
      enhancedRecommendations.add(PilgrimageRecommendation(
        name: recommendation.name,
        description: recommendation.description,
        historicalSignificance: recommendation.historicalSignificance,
        bestTimeToVisit: recommendation.bestTimeToVisit,
        estimatedDuration: recommendation.estimatedDuration,
        latitude: recommendation.latitude,
        longitude: recommendation.longitude,
        imageUrl: recommendation.imageUrl,
        distanceFromStart: travelInfo['distance'] ?? 'Unknown',
        travelTimeByCarFromStart: travelInfo['duration'] ?? 'Unknown',
      ));
    }
    
    return enhancedRecommendations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'AI Recommendations',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal[900],
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 22,
            color: Colors.teal,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with search criteria
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilgrimage Sites for ${widget.religion}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.teal[600]),
                        const SizedBox(width: 8),
                        Text('Date: ${widget.dateRange}', style: TextStyle(color: Colors.teal[700])),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.teal[600]),
                        const SizedBox(width: 8),
                        Text('Region: ${widget.region}', style: TextStyle(color: Colors.teal[700])),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<PilgrimageRecommendation>>(
                  future: _recommendationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.teal),
                            SizedBox(height: 16),
                            Text(
                              'Generating AI recommendations...',
                              style: TextStyle(color: Colors.teal),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 60, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _recommendationsFuture = _loadRecommendations();
                                });
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 60, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No recommendations found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    } else {
                      final recommendations = snapshot.data!;
                      return ListView.builder(
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          final recommendation = recommendations[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecommendationDetailsScreen(
                                      recommendation: recommendation,
                                    ),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Map
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                        child: SizedBox(
                                          height: 180,
                                          width: double.infinity,
                                          child: GoogleMap(
                                            initialCameraPosition: CameraPosition(
                                              target: LatLng(
                                                recommendation.latitude,
                                                recommendation.longitude,
                                              ),
                                              zoom: 14,
                                            ),
                                            zoomControlsEnabled: false,
                                            mapToolbarEnabled: false,
                                            myLocationButtonEnabled: false,
                                            markers: {
                                              Marker(
                                                markerId: MarkerId(recommendation.name),
                                                position: LatLng(recommendation.latitude, recommendation.longitude),
                                                infoWindow: InfoWindow(title: recommendation.name),
                                              ),
                                            },
                                          ),
                                        ),
                                      ),
                                      // Travel info overlay
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withOpacity(0.7),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.directions_car, color: Colors.white, size: 16),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    recommendation.distanceFromStart ?? 'Unknown distance',
                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(Icons.access_time, color: Colors.white, size: 16),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    recommendation.travelTimeByCarFromStart ?? 'Unknown time',
                                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Content
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recommendation.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          recommendation.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.grey[700]),
                                        ),
                                        const SizedBox(height: 16),
                                        Wrap(
                                          spacing: 16, // horizontal space between children
                                          runSpacing: 8, // vertical space between lines
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min, // Make the Row take minimum space
                                              children: [
                                                Icon(Icons.access_time, size: 16, color: Colors.teal[600]),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    recommendation.estimatedDuration,
                                                    style: TextStyle(color: Colors.teal[700]),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min, // Make the Row take minimum space
                                              children: [
                                                Icon(Icons.calendar_today, size: 16, color: Colors.teal[600]),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    recommendation.bestTimeToVisit,
                                                    style: TextStyle(color: Colors.teal[700]),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => RecommendationDetailsScreen(
                                                    recommendation: recommendation,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text('View Details'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
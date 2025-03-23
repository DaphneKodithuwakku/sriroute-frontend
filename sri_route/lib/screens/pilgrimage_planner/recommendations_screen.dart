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
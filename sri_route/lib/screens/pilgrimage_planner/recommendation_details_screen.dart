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
class TourService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Singleton pattern
  static final TourService _instance = TourService._internal();
  factory TourService() => _instance;
  TourService._internal();
  
  // Cache of loaded tour locations
  final Map<String, TourLocation> _locationCache = {};
  
  // Get all available tour locations
  Future<List<TourLocation>> getLocations() async {
    try {
      final List<TourLocation> locations = [];
      
      final listResult = await _storage.ref('tours').listAll();
      
      for (var prefix in listResult.prefixes) {
        try {
          final locationId = prefix.name;
          // If already in cache, use that
          if (_locationCache.containsKey(locationId)) {
            locations.add(_locationCache[locationId]!);
            continue;
          }
          
          // Get config file for this location
          final configRef = prefix.child('config.json');
          final configData = await configRef.getData();
          
          if (configData != null) {
            // Parse the config data
            final config = parseConfigData(configData);
            final location = TourLocation.fromMap(config);
            _locationCache[locationId] = location;
            locations.add(location);
          }
        } catch (e) {
          debugPrint('Error loading location: ${e.toString()}');
        }
      }
      
      return locations;
    } catch (e) {
      debugPrint('Error getting locations: ${e.toString()}');
      return [];
    }
  }
  
  // Parse config data from JSON - implement properly
  Map<String, dynamic> parseConfigData(List<int> data) {
    try {
      // Convert bytes to string and parse as JSON
      final jsonStr = utf8.decode(data);
      final Map<String, dynamic> jsonData = json.decode(jsonStr);
      return jsonData;
    } catch (e) {
      debugPrint('Error parsing config data: $e');
      // Return dummy data as fallback
      return {
        'id': 'default',
        'name': 'Sample Location',
        'description': 'A placeholder description',
        'thumbnailUrl': 'https://example.com/thumbnail.jpg',
        'tourPoints': [],
      };
    }
  }
  
  // Get location by ID
  Future<TourLocation?> getLocationById(String locationId) async {
    if (_locationCache.containsKey(locationId)) {
      return _locationCache[locationId];
    }
    
    try {
      // Try to load from Firebase
      final locations = await getLocations();
      return locations.firstWhere((loc) => loc.id == locationId);
    } catch (e) {
      print('Location not found: $locationId');
      return null;
    }
  }
  
  // Load all panorama images for a location (preloading)
  Future<void> preloadLocationImages(String locationId) async {
    final location = await getLocationById(locationId);
    if (location == null) return;
    
    for (var point in location.tourPoints) {
      await ImagePreloader.preloadImage(point.imageUrl);
    }
  }
  // Generate tour points automatically from a storage path
  Future<List<TourPoint>> generateTourFromStoragePath(String storagePath) async {
    try {
      // Add debug logging
      debugPrint('Generating tour from storage path: $storagePath');
      
      final storageRef = _storage.ref(storagePath);
      List<Reference> items = [];
      
      try {
        final listResult = await storageRef.listAll();
        
        // Filter for image files
        items = listResult.items.where((item) => 
          item.name.toLowerCase().endsWith('.jpg') || 
          item.name.toLowerCase().endsWith('.jpeg') ||
          item.name.toLowerCase().endsWith('.png')
        ).toList();
        
        debugPrint('Found ${items.length} image files in $storagePath');
      } catch (e) {
        debugPrint('Error listing files in storage: $e');
        throw Exception('Could not access storage location: $e');
      }
      
      if (items.isEmpty) {
        throw Exception('No panorama images found in $storagePath');
      }
      
      // Sort items to ensure consistent order
      items.sort((a, b) => a.name.compareTo(b.name));
      
      // Get URLs for all panorama images
      List<String> urls = [];
      List<String> names = [];
      
      for (var item in items) {
        try {
          final url = await item.getDownloadURL();
          urls.add(url);
          names.add(item.name);
          debugPrint('Got URL for ${item.name}: $url');
        } catch (e) {
          debugPrint('Error getting URL for ${item.name}: $e');
          // Continue with other images
        }
      }

      if (urls.isEmpty) {
        throw Exception('Failed to load any images from storage');
      }
      
      // Create tour points with hotspots
      List<TourPoint> tourPoints = [];
      
      // First point (Entrance)
      if (urls.length >= 1) {
        tourPoints.add(TourPoint(
          id: 'point_0',
          name: 'Entrance View (${names[0]})',
          imageUrl: urls[0],
          storagePath: '${storagePath}/${names[0]}',
          hotspots: urls.length > 1 ? [
            TourHotspot(
              id: 'hotspot_0_to_1',
              longitude: 30.0, 
              latitude: 0.0, 
              targetPointId: 'point_1',
              label: 'Enter',
              icon: Icons.arrow_forward,
              color: Colors.blue,
            ),
          ] : [],
        ));
      }
      
      // Middle points
      for (int i = 1; i < urls.length - 1; i++) {
        tourPoints.add(TourPoint(
          id: 'point_$i',
          name: 'View ${i+1} (${names[i]})',
          imageUrl: urls[i],
          storagePath: '${storagePath}/${names[i]}',
          hotspots: [
            TourHotspot(
              id: 'hotspot_${i}_to_${i+1}',
              longitude: 30.0, 
              latitude: 0.0, 
              targetPointId: 'point_${i+1}',
              label: 'Next',
              icon: Icons.arrow_forward,
              color: Colors.blue,
            ),
            TourHotspot(
              id: 'hotspot_${i}_to_${i-1}',
              longitude: -150.0, 
              latitude: 0.0, 
              targetPointId: 'point_${i-1}',
              label: 'Back',
              icon: Icons.arrow_back,
              color: Colors.orange,
            ),
          ],
        ));
      }
      
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
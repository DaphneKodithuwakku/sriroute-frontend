

class PanoramaScreen extends StatefulWidget {
  final String? storagePath;
  final TourLocation? location;
  final String? initialPointId;
  
  const PanoramaScreen({
    Key? key,
    this.storagePath,
    this.location, 
    this.initialPointId,
  }) : assert(storagePath != null || location != null),
       super(key: key);

  @override
  State<PanoramaScreen> createState() => _PanoramaScreenState();
}

class _PanoramaScreenState extends State<PanoramaScreen> with SingleTickerProviderStateMixin {
  final TourService _tourService = TourService();
  late Future<List<TourPoint>> _tourPointsFuture;
  TourPoint? _currentPoint;
  String? _currentPointId;
  String? _previousImageUrl;
  bool _isLoading = true;
  String _statusMessage = '';
  bool _isLoadingNext = false;
  double _longitude = 0;
  double _latitude = 0;
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  final Map<String, bool> _loadedPoints = {};
  Timer? _preloadTimer;
  
  // Error tracking
  String? _errorMessage;
  bool _hasError = false;
  int _errorRetryCount = 0;
  
  // Extract UI constants
  static const double _hotspotRadius = 30.0;
  static const int _maxErrorRetries = 3;
  static const Duration _preloadingTimerDuration = Duration(seconds: 3);
  static const Duration _transitionDuration = Duration(milliseconds: 500);
  static const Duration _tourTimeoutDuration = Duration(seconds: 30);
  
  // Responsive layout variables
  late double _screenWidth;
  late bool _isSmallScreen;
  
  @override
  void initState() {
    super.initState();
    
    _transitionController = AnimationController(
      duration: _transitionDuration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _transitionController,
        curve: Curves.easeInOut,
      ),
    );
    
    _currentPointId = widget.initialPointId;
    
    // Start loading tour points
    _tourPointsFuture = _loadTourPoints();
    
    // Enter fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    
    // Start background preloading timer
    _startBackgroundPreloading();
  }
  
  @override
  void dispose() {
    _transitionController.dispose();
    
    // Exit fullscreen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    
    _preloadTimer?.cancel();
    super.dispose();
  }
 // Start background preloading of nearby images
  void _startBackgroundPreloading() {
    _preloadTimer?.cancel();
    _preloadTimer = Timer.periodic(_preloadingTimerDuration, (_) async {
      try {
        final points = await _tourPointsFuture;
        if (points.isEmpty || _currentPoint == null) return;
        
        // Find adjacent points to preload
        final currentIndex = points.indexWhere((p) => p.id == _currentPoint!.id);
        if (currentIndex == -1) return;
        
        final urlsToPreload = <String>[];
        
        // Always preload next point first
        if (currentIndex + 1 < points.length) {
          urlsToPreload.add(points[currentIndex + 1].imageUrl);
        }
        
        // Then preload previous point
        if (currentIndex - 1 >= 0) {
          urlsToPreload.add(points[currentIndex - 1].imageUrl);
        }
        
        // Also preload two steps ahead if available
        if (currentIndex + 2 < points.length) {
          urlsToPreload.add(points[currentIndex + 2].imageUrl);
        }
        
        // Prioritize loading these images
        await ImagePreloader.prioritizeImages(urlsToPreload);
        
        // Update loaded status
        _updateLoadedStatus(points);
      } catch (e) {
        debugPrint('Error in background preloading: $e');
      }
    });
  }
  
  // Update which points are preloaded
  void _updateLoadedStatus(List<TourPoint> points) {
    final loadedUrls = ImagePreloader.loadedUrls;
    
    setState(() {
      for (final point in points) {
        _loadedPoints[point.id] = loadedUrls.contains(point.imageUrl);
      }
    });
  }
   // Load tour points either from a TourLocation or generate from a storage path
  Future<List<TourPoint>> _loadTourPoints() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Loading tour data...';
      _hasError = false;
      _errorMessage = null;
    });
    
    try {
      List<TourPoint> points;
      
      if (widget.location != null) {
        // If we have a location object, use its tour points
        points = widget.location!.tourPoints;
        
        setState(() {
          _statusMessage = 'Preparing initial view...';
        });
        
        if (points.isNotEmpty) {
          try {
            await ImagePreloader.preloadImage(points.first.imageUrl);
          } catch (e) {
            debugPrint('Error preloading first image: $e');
          }
          
          // Preload next image in the background
          if (points.length > 1) {
            _preloadNextImagesInBackground(points, 0);
          }
        }
      } else if (widget.storagePath != null) {
        // Generate tour points from storage path
        setState(() {
          _statusMessage = 'Generating tour from images...';
        });
        
        points = await _timeoutFuture(
          _tourService.generateTourFromStoragePath(widget.storagePath!),
          _tourTimeoutDuration,
          'Tour generation took too long',
        );
        
        // Preload the first image immediately
        if (points.isNotEmpty) {
          try {
            await ImagePreloader.preloadImage(points.first.imageUrl);
          } catch (e) {
            debugPrint('Error preloading first image: $e');
          }
          
          // Preload next image in the background
          if (points.length > 1) {
            _preloadNextImagesInBackground(points, 0);
          }
        }
      } else {
        throw Exception('Either location or storagePath must be provided');
      }
      
      // Set initial view point
      if (_currentPointId == null && points.isNotEmpty) {
        _currentPointId = points.first.id;
        _currentPoint = points.first;
        _longitude = _currentPoint?.initialLongitude ?? 0;
        _latitude = _currentPoint?.initialLatitude ?? 0;
      } else if (_currentPointId != null) {
        _currentPoint = points.firstWhere(
          (p) => p.id == _currentPointId,
          orElse: () => points.first,
        );
        _longitude = _currentPoint?.initialLongitude ?? 0;
        _latitude = _currentPoint?.initialLatitude ?? 0;
      }
      
      // Update loaded status
      _updateLoadedStatus(points);
      
      setState(() {
        _isLoading = false;
        _statusMessage = '';
      });
      
      // Start showing the content
      _transitionController.forward();
      
      return points;
    } catch (e) {
      debugPrint('Error loading tour points: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
      
      // Return a fallback tour point
      return [
        TourPoint(
          id: 'fallback',
          name: 'Sample View',
          imageUrl: 'https://360rumors.com/wp-content/uploads/2018/12/VIRB-360-sample-13.jpg',
          hotspots: [],
        ),
      ];
    }
  }
  
  // Helper to preload next images in background
  Future<void> _preloadNextImagesInBackground(List<TourPoint> points, int currentIndex) async {
    try {
      // Determine next points to preload
      final nextIndices = [];
      if (currentIndex + 1 < points.length) nextIndices.add(currentIndex + 1);
      if (currentIndex - 1 >= 0) nextIndices.add(currentIndex - 1);
      
      for (final index in nextIndices) {
        // Don't await, let this happen in the background
        ImagePreloader.preloadImage(points[index].imageUrl)
          .catchError((e) => debugPrint('Background preload error: $e'));
      }
      
      // Update loaded status after preloading
      _updateLoadedStatus(points);
    } catch (e) {
      debugPrint('Error in background preloading: $e');
    }
  }
  
  // Helper to add timeout to futures
  Future<T> _timeoutFuture<T>(Future<T> future, Duration timeout, String timeoutMessage) {
    return future.timeout(timeout, onTimeout: () {
      throw timeoutMessage;
    });
  }
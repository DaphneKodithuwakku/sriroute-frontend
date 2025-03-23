

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
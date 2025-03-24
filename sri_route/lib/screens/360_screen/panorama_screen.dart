import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:panorama/panorama.dart';
import '../../models/tour_models.dart';
import '../../services/tour_service.dart';
import '../../utils/image_loader.dart';
import '../../widgets/panorama_hotspot.dart';
import '../../widgets/transition_panorama.dart';

/// This screen displays a 360° panorama with interactive hotspots
///
class PanoramaScreen extends StatefulWidget {
  final String? storagePath; // Path to local or Firebase storage for image
  final TourLocation? location; // Specific location containing multiple points
  final String? initialPointId;

  // Ensure either storagePath or location is provided
  const PanoramaScreen({
    Key? key,
    this.storagePath,
    this.location,
    this.initialPointId,
  })  : assert(storagePath != null || location != null),
        super(key: key);

  @override
  State<PanoramaScreen> createState() => _PanoramaScreenState();
}

class _PanoramaScreenState extends State<PanoramaScreen>
    with SingleTickerProviderStateMixin {
  final TourService _tourService = TourService(); // Tour service instance
  late Future<List<TourPoint>>
      _tourPointsFuture; // Future to load all tour points
  TourPoint? _currentPoint;
  String? _currentPointId;
  String? _previousImageUrl;
  bool _isLoading = true;
  String _statusMessage = '';
  bool _isLoadingNext = false; // Flag used when jumping to the next panorama
  double _longitude = 0; // Current horizontal camera rotation
  double _latitude = 0;

  // Animation controller for fade transition between panoramas
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  final Map<String, bool> _loadedPoints = {}; //Cache to avoid reloading images
  Timer? _preloadTimer; // Timer to periodically preload nearby tour points

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
      CurvedAnimation(parent: _transitionController, curve: Curves.easeInOut),
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
        final currentIndex = points.indexWhere(
          (p) => p.id == _currentPoint!.id,
        );
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
          imageUrl:
              'https://360rumors.com/wp-content/uploads/2018/12/VIRB-360-sample-13.jpg',
          hotspots: [],
        ),
      ];
    }
  }

  // Helper to preload next images in background
  Future<void> _preloadNextImagesInBackground(
    List<TourPoint> points,
    int currentIndex,
  ) async {
    try {
      // Determine next points to preload
      final nextIndices = [];
      if (currentIndex + 1 < points.length) nextIndices.add(currentIndex + 1);
      if (currentIndex - 1 >= 0) nextIndices.add(currentIndex - 1);

      for (final index in nextIndices) {
        // Don't await, let this happen in the background
        ImagePreloader.preloadImage(
          points[index].imageUrl,
        ).catchError((e) => debugPrint('Background preload error: $e'));
      }

      // Update loaded status after preloading
      _updateLoadedStatus(points);
    } catch (e) {
      debugPrint('Error in background preloading: $e');
    }
  }

  // Helper to add timeout to futures
  Future<T> _timeoutFuture<T>(
    Future<T> future,
    Duration timeout,
    String timeoutMessage,
  ) {
    return future.timeout(
      timeout,
      onTimeout: () {
        throw timeoutMessage;
      },
    );
  }

  // Navigate to a different tour point with smoother transitions
  Future<void> _navigateToPoint(TourPoint point) async {
    if (point.id == _currentPointId) return;

    final isPreloaded = _loadedPoints[point.id] ?? false;

    // Set loading state only if image isn't preloaded
    if (!isPreloaded) {
      setState(() {
        _isLoadingNext = true;
        _hasError = false;
        _errorMessage = null;
      });
    }

    try {
      // Store previous image URL for transition effect if needed
      final previousPoint = _currentPoint;
      final previousImageUrl = previousPoint?.imageUrl;

      if (isPreloaded) {
        // For preloaded images, skip the fade transition and switch immediately
        setState(() {
          _previousImageUrl = null; // Don't need previous image for transition
          _currentPointId = point.id;
          _currentPoint = point;
          _longitude = point.initialLongitude;
          _latitude = point.initialLatitude;
        });

        // Make sure transition controller is at the forward position
        if (_transitionController.value != 1.0) {
          _transitionController.value =
              1.0; // Set to end value without animation
        }
      } else {
        // For non-preloaded images, use the fade transition
        await _transitionController.reverse();

        setState(() {
          _previousImageUrl = previousImageUrl;
          _currentPointId = point.id;
          _currentPoint = point;
          _longitude = point.initialLongitude;
          _latitude = point.initialLatitude;
          _isLoadingNext = false;
        });

        _transitionController.forward();
      }

      // Update the cached points list
      final tourPoints = await _tourPointsFuture;
      _updateLoadedStatus(tourPoints);

      // Preload adjacent points
      final currentIndex = tourPoints.indexWhere((p) => p.id == point.id);
      if (currentIndex != -1) {
        _preloadNextImagesInBackground(tourPoints, currentIndex);
      }
    } catch (e) {
      debugPrint('Error during navigation: $e');
      setState(() {
        _isLoadingNext = false;
        _hasError = true;
        _errorMessage = 'Failed to load next point: ${e.toString()}';
      });
      // Forward animation anyway to show the error state
      _transitionController.forward();
    }
  }

  // Find a tour point by ID in the list
  TourPoint? _findPointById(List<TourPoint> points, String id) {
    try {
      return points.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Retry after an error
  void _retryAfterError() {
    if (_errorRetryCount >= _maxErrorRetries) {
      // Too many retries, restart the entire process
      setState(() {
        _errorRetryCount = 0;
        _tourPointsFuture = _loadTourPoints();
      });
      return;
    }

    setState(() {
      _errorRetryCount++;
      _hasError = false;
      _errorMessage = null;

      if (_currentPoint != null) {
        _isLoadingNext = true;
        // Retry loading the current image
        ImagePreloader.preloadImage(_currentPoint!.imageUrl, highPriority: true)
            .then((_) {
          setState(() => _isLoadingNext = false);
          _transitionController.forward();
        }).catchError((e) {
          setState(() {
            _isLoadingNext = false;
            _hasError = true;
            _errorMessage = 'Retry failed: ${e.toString()}';
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive layout
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _isSmallScreen = _screenWidth < 600;

    return Scaffold(
      body: FutureBuilder<List<TourPoint>>(
        future: _tourPointsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingView('Loading tour...');
          }

          if (snapshot.hasError) {
            return _buildErrorView('Failed to load tour: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildErrorView('No tour points available');
          }

          final tourPoints = snapshot.data!;
          if (_currentPointId == null && tourPoints.isNotEmpty) {
            _currentPointId = tourPoints.first.id;
            _currentPoint = tourPoints.first;
          }

          final currentPoint =
              _findPointById(tourPoints, _currentPointId!) ?? tourPoints.first;
          final currentIndex = tourPoints.indexWhere(
            (p) => p.id == currentPoint.id,
          );

          return PopScope(
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                await _cleanupBeforeExit();
              }
            },
            child: Stack(
              children: [
                // Main panorama content with transition effect
                _buildPanoramaView(tourPoints, currentPoint),

                // UI Overlay with improved navigation
                _buildUIOverlay(
                  context,
                  tourPoints,
                  currentPoint,
                  currentIndex,
                ),

                // Close button in top right
                Positioned(
                  top: 16,
                  right: 16,
                  child: SafeArea(child: _buildCloseButton()),
                ),

                // Loading overlay if needed
                if (_isLoading) _buildLoadingView(_statusMessage),

                // Error overlay if needed
                if (_hasError && !_isLoading) _buildErrorOverlay(),
              ],
            ),
          );
        },
      ),
    );
  }

  // Close button in top right
  Widget _buildCloseButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(150),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 24),
        onPressed: () async {
          await _cleanupBeforeExit();
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  // Extract panorama view to a separate method using TransitionPanorama
  Widget _buildPanoramaView(
    List<TourPoint> tourPoints,
    TourPoint currentPoint,
  ) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(opacity: _fadeAnimation.value, child: child);
      },
      child: _hasError
          ? _buildImageErrorDisplay()
          : TransitionPanorama(
              imageUrl: currentPoint.imageUrl,
              previousImageUrl: _previousImageUrl,
              longitude: _longitude,
              latitude: _latitude,
              onLongitudeChanged: (value) => _longitude = value,
              onLatitudeChanged: (value) => _latitude = value,
              hotspots: _buildHotspots(currentPoint, tourPoints),
            ),
    );
  }

  // Extract hotspot building to a separate method
  List<Hotspot> _buildHotspots(
    TourPoint currentPoint,
    List<TourPoint> tourPoints,
  ) {
    return currentPoint.hotspots
        .map(
          (hotspot) => Hotspot(
            latitude: hotspot.latitude,
            longitude: hotspot.longitude,
            width: _hotspotRadius * 2,
            height: _hotspotRadius * 2,
            widget: PanoramaHotspotWidget(
              label: hotspot.label,
              icon: hotspot.icon ?? Icons.arrow_forward,
              color: hotspot.color ?? Colors.blue,
              isLoaded: _loadedPoints[hotspot.targetPointId] ?? false,
              onTap: () {
                final target = _findPointById(
                  tourPoints,
                  hotspot.targetPointId,
                );
                if (target != null) {
                  _navigateToPoint(target);
                }
              },
            ),
          ),
        )
        .toList();
  }

  // Add a method for cleanup before exiting
  Future<void> _cleanupBeforeExit() async {
    try {
      await ImagePreloader.clearCache();
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  // This widget builds a UI overlay on top of a virtual tour/panorama view
// It displays the current tour point name and loading indicator, and is responsive for different screen sizes
  Widget _buildUIOverlay(
    BuildContext context,
    List<TourPoint> tourPoints, //List of all tour points in the virtual tour
    TourPoint currentPoint,
    int currentIndex,
  ) {
    return SafeArea(
      child: Column(
        children: [
          // Top bar with panorama name
          if (!_isSmallScreen || _screenWidth > 400)
            Padding(
              padding: EdgeInsets.only(top: 16, left: _screenWidth * 0.05),
              child: Align(
                alignment:
                    Alignment.topLeft, // Aligns the info bar to top-left corner
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(150),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Show loading spinner when transitioning to the next point
                      if (_isLoadingNext)
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(right: 10),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      Text(
                        currentPoint.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _isSmallScreen ? 14 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          const Spacer(),

          // Bottom navigation controls - responsive
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _screenWidth * 0.05,
              vertical: 16,
            ),
            child: _buildNavigationControls(tourPoints, currentIndex),
          ),
        ],
      ),
    );
  }

  // Responsive navigation controls
  Widget _buildNavigationControls(
    List<TourPoint> tourPoints,
    int currentIndex,
  ) {
    if (tourPoints.length <= 1) {
      return const SizedBox.shrink();
    }

    // For very small screens, simplify the UI
    if (_isSmallScreen && _screenWidth < 350) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildNavigationPills(tourPoints, currentIndex)],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Previous button (icon only)
        if (currentIndex > 0)
          _buildNavigationButton(
            onPressed: () => _navigateToPoint(tourPoints[currentIndex - 1]),
            icon: Icons.arrow_back,
            isLoaded: _loadedPoints[tourPoints[currentIndex - 1].id] ?? false,
          )
        else
          const SizedBox(
            width: 50,
          ), // Smaller placeholder since we removed text
        // Pagination indicators
        _buildNavigationPills(tourPoints, currentIndex),

        // Next button (icon only)
        if (currentIndex < tourPoints.length - 1)
          _buildNavigationButton(
            onPressed: () => _navigateToPoint(tourPoints[currentIndex + 1]),
            icon: Icons.arrow_forward,
            isLoaded: _loadedPoints[tourPoints[currentIndex + 1].id] ?? false,
          )
        else
          const SizedBox(
            width: 50,
          ), // Smaller placeholder since we removed text
      ],
    );
  }

  // Navigation button with preload indicator - text removed
  Widget _buildNavigationButton({
    required VoidCallback onPressed,
    required IconData icon,
    required bool isLoaded,
  }) {
    return ElevatedButton(
      onPressed: _isLoadingNext ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black.withAlpha(150),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(12),
        shape: const CircleBorder(),
        minimumSize: const Size(50, 50),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, size: 24),
          if (isLoaded)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Pagination pills
  Widget _buildNavigationPills(List<TourPoint> tourPoints, int currentIndex) {
    // For many points, only show a window of points
    final maxVisiblePills = _isSmallScreen ? 5 : 9;
    List<int> visibleIndices;

    if (tourPoints.length <= maxVisiblePills) {
      visibleIndices = List.generate(tourPoints.length, (i) => i);
    } else {
      final halfVisible = maxVisiblePills ~/ 2;
      int start = currentIndex - halfVisible;
      int end = currentIndex + halfVisible;

      if (start < 0) {
        end += (0 - start);
        start = 0;
      }

      if (end >= tourPoints.length) {
        start = math.max(0, start - (end - tourPoints.length + 1));
        end = tourPoints.length - 1;
      }

      visibleIndices = List.generate(end - start + 1, (i) => i + start);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(150),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Show back arrow if we're not showing the first item
          if (visibleIndices.first > 0)
            GestureDetector(
              onTap: () =>
                  _navigateToPoint(tourPoints[visibleIndices.first - 1]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white.withAlpha(200),
                  size: 20,
                ),
              ),
            ),

          // Pagination pills
          for (final index in visibleIndices)
            GestureDetector(
              onTap: _isLoadingNext
                  ? null
                  : () => _navigateToPoint(tourPoints[index]),
              child: Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == currentIndex
                      ? Colors.white
                      : _loadedPoints[tourPoints[index].id] == true
                          ? Colors.white.withAlpha(150)
                          : Colors.white.withAlpha(80),
                ),
              ),
            ),

          // Show forward arrow if we're not showing the last item
          if (visibleIndices.last < tourPoints.length - 1)
            GestureDetector(
              onTap: () =>
                  _navigateToPoint(tourPoints[visibleIndices.last + 1]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white.withAlpha(200),
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Loading view
  Widget _buildLoadingView(String message) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Error overlay
  Widget _buildErrorOverlay() {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading image:\n${_errorMessage ?? "Unknown error"}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _retryAfterError,
              child: const Text('Retry'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ImagePreloader.clearCache();
                Navigator.of(context).pop();
              },
              child: const Text('Close Tour'),
            ),
          ],
        ),
      ),
    );
  }

  // Error view
  Widget _buildErrorView(String error) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading tour:\n$error',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorRetryCount = 0;
                  _tourPointsFuture = _loadTourPoints();
                });
              },
              child: const Text('Retry'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ImagePreloader.clearCache();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  // Image error display
  Widget _buildImageErrorDisplay() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.broken_image, size: 64, color: Colors.white54),
            const SizedBox(height: 16),
            const Text(
              'Image could not be loaded',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _retryAfterError,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

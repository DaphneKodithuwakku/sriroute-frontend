

/ Image loading event for progress reporting
class ImageLoadingEvent {
  final String url;
  final ImageLoadingStatus status;
  final double progress;
  final int? bytesLoaded;
  final int? bytesTotal;
  final String? error;
  
  ImageLoadingEvent({
    required this.url,
    required this.status,
    this.progress = 0.0,
    this.bytesLoaded,
    this.bytesTotal,
    this.error,
  });
}

enum ImageLoadingStatus {
  started,
  downloading,
  processing,
  completed,
  error,
  inProgress,
}

class ImagePreloader {
  // Cache management
  static final Map<String, Image> _cache = {};
  static final Map<String, Completer<void>> _loadingCompleters = {};
  static final Map<String, int> _retryCount = {};
  static const int _maxRetries = 3;
  
  // Cache managers
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();
  static CacheManager? _panoramaCacheManager;
  
  // Successfully loaded URLs tracking
  static final Set<String> _loadedUrls = {};
  
  // Event stream for progress updates
  static final StreamController<ImageLoadingEvent> _loadingEventController = 
      StreamController<ImageLoadingEvent>.broadcast();
  static Stream<ImageLoadingEvent> get loadingEvents => _loadingEventController.stream;

  // Remove unused variables related to memory monitoring
  static int _maxCacheSize = 100; // Default cache size in MB

  static Future<CacheManager> get panoramaCacheManager async {
    if (_panoramaCacheManager == null) {
      final cacheDir = await getTemporaryDirectory();
      final panoramaCacheDir = Directory('${cacheDir.path}/panorama_cache');
      
      if (!await panoramaCacheDir.exists()) {
        await panoramaCacheDir.create(recursive: true);
      }
      
      _panoramaCacheManager = CacheManager(
        Config(
          'panoramaCache',
          stalePeriod: const Duration(days: 7),
          maxNrOfCacheObjects: 20,
          repo: JsonCacheInfoRepository(databaseName: 'panoramaImagesCache'),
          fileService: HttpFileService(),
        ),
      );
    }
    return _panoramaCacheManager!;
  }

  // Initialize the cache system
  static Future<void> init({int maxCacheSize = 100}) async {
    _maxCacheSize = maxCacheSize;
    return Future.value();
  }
  
  // Preload an image with progress updates
  static Future<void> preloadImage(
    String url, {
    bool highPriority = false,
    bool isPanorama = true,
    int maxWidth = 4096,
    int maxHeight = 2048,
    Function(double progress)? onProgress,
  }) async {
    if (_cache.containsKey(url)) {
      _loadedUrls.add(url);
      _loadingEventController.add(
        ImageLoadingEvent(
          url: url, 
          status: ImageLoadingStatus.completed,
          progress: 1.0,
        ),
      );
      return;
    }
    
    if (_loadingCompleters.containsKey(url)) {
      _loadingEventController.add(
        ImageLoadingEvent(
          url: url, 
          status: ImageLoadingStatus.inProgress,
          progress: 0.5,
        ),
      );
      return _loadingCompleters[url]!.future;
    }
    
    final completer = Completer<void>();
    _loadingCompleters[url] = completer;
    _retryCount[url] = 0;
    
    _loadingEventController.add(
      ImageLoadingEvent(
        url: url, 
        status: ImageLoadingStatus.started,
        progress: 0.0,
      ),
    );
    
    await _tryLoadImage(
      url, 
      completer,
      highPriority: highPriority,
      isPanorama: isPanorama,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      onProgress: onProgress,
    );
    
    return completer.future;
  }
  
  // Try loading image with retry logic
  static Future<void> _tryLoadImage(
    String url, 
    Completer<void> completer, {
    bool highPriority = false,
    bool isPanorama = true,
    int maxWidth = 4096,
    int maxHeight = 2048,
    Function(double progress)? onProgress,
  }) async {
    if (_retryCount[url]! >= _maxRetries) {
      debugPrint('Maximum retries reached for $url');
      completer.completeError('Failed to load image after $_maxRetries attempts');
      _loadingEventController.add(
        ImageLoadingEvent(
          url: url, 
          status: ImageLoadingStatus.error,
          error: 'Failed to load image after $_maxRetries attempts',
        ),
      );
      _loadingCompleters.remove(url);
      _retryCount.remove(url);
      return;
    }
    
    try {
      final cacheManager = isPanorama ? await panoramaCacheManager : _cacheManager;
      
      final fileInfo = await cacheManager.downloadFile(
        url,
        key: isPanorama ? 'panorama_${url.hashCode}' : null,
      );
      
      _loadingEventController.add(
        ImageLoadingEvent(
          url: url, 
          status: ImageLoadingStatus.processing,
          progress: 0.9,
        ),
      );
      
      // Always use constrained loading since memory check is disabled
      await _loadConstrainedImage(url, fileInfo.file, completer, maxWidth, maxHeight);
      
    } catch (e) {
      _loadingEventController.add(
        ImageLoadingEvent(
          url: url, 
          status: ImageLoadingStatus.error,
          error: e.toString(),
        ),
      );
      
      debugPrint('Error loading $url: $e');
      _retryCount[url] = (_retryCount[url] ?? 0) + 1;
      
      if (_retryCount[url]! < _maxRetries) {
        debugPrint('Retrying $url (attempt ${_retryCount[url]})');
        await Future.delayed(Duration(milliseconds: 500 * _retryCount[url]!));
        _tryLoadImage(
          url, 
          completer,
          highPriority: highPriority,
          isPanorama: isPanorama,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          onProgress: onProgress,
        );
      } else {
        debugPrint('All retries failed for $url: $e');
        completer.completeError(e);
        _loadingEventController.add(
          ImageLoadingEvent(
            url: url, 
            status: ImageLoadingStatus.error,
            error: e.toString(),
          ),
        );
        _loadingCompleters.remove(url);
        _retryCount.remove(url);
      }
    }
  }

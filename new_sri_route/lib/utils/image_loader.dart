import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

// Image loading event for progress reporting
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

  // Check if an image is already successfully loaded
  static bool isImageLoaded(String url) => _loadedUrls.contains(url);

  // Get all loaded URLs
  static Set<String> get loadedUrls => Set.from(_loadedUrls);

  // Load image with size constraints
  static Future<void> _loadConstrainedImage(
    String url,
    File file,
    Completer<void> completer,
    int maxWidth,
    int maxHeight,
  ) async {
    try {
      if (!await file.exists()) {
        completer.completeError('File does not exist: ${file.path}');
        _loadingCompleters.remove(url);
        _retryCount.remove(url);
        return;
      }
      
      final bytes = await file.readAsBytes();
      
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: maxWidth,
        targetHeight: maxHeight,
      );
      
      final frameInfo = await codec.getNextFrame();
      final image = frameInfo.image;
      
      final imageProvider = MemoryImage(bytes);
      _cache[url] = Image(image: imageProvider);
      
      // Clean up
      image.dispose();
      codec.dispose();
      
      debugPrint('Successfully loaded: $url');
      _loadedUrls.add(url);
      completer.complete();
      _loadingEventController.add(
        ImageLoadingEvent(
          url: url, 
          status: ImageLoadingStatus.completed,
          progress: 1.0,
        ),
      );
      _loadingCompleters.remove(url);
      _retryCount.remove(url);
      
    } catch (e) {
      debugPrint('Error processing image $url: $e');
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
  
  // Load a downsampled version of the image - this should remain
  static Future<void> _loadDownsampledImage(
    String url,
    File file,
    Completer<void> completer,
    int maxWidth,
    int maxHeight,
  ) async {
    try {
      if (!await file.exists()) {
        completer.completeError('File does not exist: ${file.path}');
        _loadingCompleters.remove(url);
        _retryCount.remove(url);
        return;
      }
      
      final bytes = await compute(_resizeImageData, {
        'path': file.path,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
      });
      
      final imageProvider = MemoryImage(bytes);
      _cache[url] = Image(image: imageProvider);
      
      debugPrint('Loaded downsampled image: $url');
      _loadedUrls.add(url);
      completer.complete();
      _loadingEventController.add(
        ImageLoadingEvent(
          url: url, 
          status: ImageLoadingStatus.completed,
          progress: 1.0,
        ),
      );
      _loadingCompleters.remove(url);
      _retryCount.remove(url);
      
    } catch (e) {
      debugPrint('Error downsampling image $url: $e');
      await _loadConstrainedImage(url, file, completer, maxWidth, maxHeight);
    }
  }

  // Get a cached image if available, otherwise create a new one
  static Image getImage(
    String url, {
    Key? key,
    bool usePlaceholder = true,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }
    
    // Start preloading this image
    preloadImage(url);
    
    return Image(
      key: key,
      image: ResizeImage(
        NetworkImage(url),
        width: width?.toInt(),
        height: height?.toInt(),
      ),
      fit: fit,
      filterQuality: FilterQuality.medium,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget(error.toString());
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: frame != null 
            ? child 
            : Container(
                width: width,
                height: height,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              ),
        );
      },
    );
  }
  
  // Get a panorama image with progressive loading
  static Image getPanoramaImage(
    String url, {
    Key? key,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
  }) {
    if (!_cache.containsKey(url)) {
      preloadImage(url, isPanorama: true);
    }
    
    return Image.network(
      url,
      key: key,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame != null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: loadingBuilder ?? (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 10),
              if (loadingProgress.expectedTotalBytes != null)
                Text(
                  '${((loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)) * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
      errorBuilder: errorBuilder ?? (context, error, stackTrace) {
        return _buildErrorWidget(error.toString());
      },
    );
  }
  
  // Helper to build error widget
  static Widget _buildErrorWidget(String error) {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Failed to load image',
              style: TextStyle(color: Colors.red[800]),
            ),
          ],
        ),
      ),
    );
  }
  
  // Batch preload multiple images
  static Future<List<String>> preloadImages(
    List<String> urls, {
    bool highPriority = false, 
    bool isPanorama = true,
    void Function(double progress)? onProgress,
  }) async {
    final loadedUrls = <String>[];
    final failedUrls = <String>[];
    
    for (int i = 0; i < urls.length; i++) {
      try {
        await preloadImage(
          urls[i], 
          highPriority: highPriority, 
          isPanorama: isPanorama,
          onProgress: (progress) {
            onProgress?.call((i + progress) / urls.length);
          },
        );
        loadedUrls.add(urls[i]);
      } catch (e) {
        failedUrls.add(urls[i]);
      }
      
      if (onProgress != null) {
        onProgress((i + 1) / urls.length);
      }
    }
    
    return loadedUrls;
  }
  
  // Cache management methods
  static void removeFromCache(String url) {
    _cache.remove(url);
    debugPrint('Removed from cache: $url');
  }
  
  static bool isImageCached(String url) => _cache.containsKey(url);
  
  static int get cacheSize => _cache.length;
  
  static Future<void> clearCache() async {
    try {
      await _cacheManager.emptyCache();
      
      if (_panoramaCacheManager != null) {
        await _panoramaCacheManager!.emptyCache();
      }
      
      debugPrint('Image cache cleared');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
    
    _cache.clear();
    _loadedUrls.clear();
  }
  
  // Consolidate low memory handlers into one method
  static void handleLowMemory() {
    _cache.clear();
    debugPrint('Low memory: cleared image cache');
  }

  // Prioritize loading of specific images
  static Future<void> prioritizeImages(List<String> urls) async {
    final notLoadedUrls = urls.where((url) => !isImageLoaded(url)).toList();
    
    if (notLoadedUrls.isEmpty) return;
    
    if (notLoadedUrls.isNotEmpty) {
      try {
        await preloadImage(notLoadedUrls.first, highPriority: true);
      } catch (e) {
        debugPrint('Error prioritizing image: $e');
      }
    }
    
    for (var i = 1; i < notLoadedUrls.length; i++) {
      preloadImage(notLoadedUrls[i]).catchError((e) => debugPrint('Background load error: $e'));
    }
  }
}

// Isolate function for image resizing - keep as is
Future<Uint8List> _resizeImageData(Map<String, dynamic> params) async {
  final File imageFile = File(params['path']);
  
  try {
    if (!await imageFile.exists()) {
      throw Exception('Image file does not exist');
    }
    
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: params['maxWidth'],
      targetHeight: params['maxHeight'],
    );
    
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;
    
    // Convert to PNG - lower quality but smaller size
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    // Clean up
    image.dispose();
    codec.dispose();
    
    if (byteData == null) {
      throw Exception('Failed to convert image to bytes');
    }
    
    return byteData.buffer.asUint8List();
  } catch (e) {
    print('Error in _resizeImageData: $e');
    rethrow;
  }
}

import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';
import 'transition_image.dart';

class TransitionPanorama extends StatefulWidget {
  final String imageUrl;
  final String? previousImageUrl;
  final double longitude;
  final double latitude;
  final ValueChanged<double>? onLongitudeChanged;
  final ValueChanged<double>? onLatitudeChanged;
  final List<Hotspot> hotspots;
  
  const TransitionPanorama({
    Key? key,
    required this.imageUrl,
    this.previousImageUrl,
    required this.longitude,
    required this.latitude,
    this.onLongitudeChanged,
    this.onLatitudeChanged,
    this.hotspots = const [],
  }) : super(key: key);

  @override
  State<TransitionPanorama> createState() => _TransitionPanoramaState();
}

class _TransitionPanoramaState extends State<TransitionPanorama> {
  @override
  Widget build(BuildContext context) {
    return Panorama(
      longitude: widget.longitude,
      latitude: widget.latitude,
      sensitivity: 1.0,
      animSpeed: 0.5, 
      sensorControl: SensorControl.None,
      onViewChanged: (longitude, latitude, _) {
        widget.onLongitudeChanged?.call(longitude);
        widget.onLatitudeChanged?.call(latitude);
      },
      hotspots: widget.hotspots,
      child: _buildPanoramaImage(),
    );
  }
  
  // Fixed: Return Image widget instead of custom widget
  Image _buildPanoramaImage() {
    return Image.network(
      widget.imageUrl,
      fit: BoxFit.cover,
      // Use memory cache for faster loading of preloaded images
      cacheWidth: 4096,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        
        return Stack(
          fit: StackFit.expand,
          children: [
            // Only show previous image when explicitly provided AND loading isn't almost complete
            if (widget.previousImageUrl != null && 
                (loadingProgress.expectedTotalBytes == null || 
                 loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! < 0.9))
              Image.network(
                widget.previousImageUrl!,
                fit: BoxFit.cover,
              ),
              
            // Loading indicator on top
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / 
                          (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  if (loadingProgress.expectedTotalBytes != null)
                    Text(
                      '${((loadingProgress.cumulativeBytesLoaded / 
                         loadingProgress.expectedTotalBytes!) * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            offset: Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.black,
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.red, size: 64),
          ),
        );
      },
    );
  }
}

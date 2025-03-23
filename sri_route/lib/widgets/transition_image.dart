import 'package:flutter/material.dart';
import '../utils/image_loader.dart';

/// A widget that smoothly transitions between panorama images
class TransitionPanoramaImage extends StatefulWidget {
  final String imageUrl;
  final String? previousImageUrl;
  final ValueChanged<ImageInfo> onImageLoad;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?) loadingBuilder;

  const TransitionPanoramaImage({
    Key? key,
    required this.imageUrl,
    this.previousImageUrl,
    required this.onImageLoad,
    required this.loadingBuilder,
  }) : super(key: key);

  @override
  State<TransitionPanoramaImage> createState() =>
      _TransitionPanoramaImageState();
}

class _TransitionPanoramaImageState extends State<TransitionPanoramaImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isCurrentLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _checkIfPreloaded();
  }

  @override
  void didUpdateWidget(TransitionPanoramaImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _isCurrentLoaded = false;
      _checkIfPreloaded();
    }
  }

  void _checkIfPreloaded() {
    // Check if the image is already cached
    if (ImagePreloader.isImageLoaded(widget.imageUrl)) {
      setState(() {
        _isCurrentLoaded = true;
      });
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If we have a previous image and the current isn't loaded, show the previous
    if (widget.previousImageUrl != null && !_isCurrentLoaded) {
      return Stack(
        children: [
          // Previous image as background
          if (widget.previousImageUrl != null)
            Image.network(widget.previousImageUrl!, fit: BoxFit.cover),

          // Current image loading on top with opacity transition
          FadeTransition(
            opacity: _animation,
            child: _buildNetworkImage(widget.imageUrl),
          ),
        ],
      );
    }

    // Otherwise just show the current image
    return _buildNetworkImage(widget.imageUrl);
  }

  // Extract duplicated image code to a separate method
  Widget _buildNetworkImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          // Image is loaded, trigger fade-in
          if (!_isCurrentLoaded && url == widget.imageUrl) {
            _isCurrentLoaded = true;
            _controller.forward();
          }
          return child;
        }
        return widget.loadingBuilder(context, child, loadingProgress);
      },
      errorBuilder: (context, error, stack) {
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

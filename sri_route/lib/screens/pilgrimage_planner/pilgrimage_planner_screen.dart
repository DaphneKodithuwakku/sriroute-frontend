import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'recommendations_screen.dart'; // Add this import statement
import '../../services/location_service.dart';
import '../../models/location_model.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sacred Journey',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.teal[900],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.teal[900]),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(
            red: 255,
            green: 255,
            blue: 255,
            alpha: 230,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const Text('Home Screen'),
    const Text('VR Tour Screen'),
    const PilgrimagePlannerScreen(),
    const Text('User Manual Screen'),
    const Text('Profile Screen'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(elevation: 0),
      body: SafeArea(
        child: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  red: 0,
                  green: 0,
                  blue: 0,
                  alpha: 77,
                ),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? Colors.white
                      : Colors.white.withValues(
                          red: 255,
                          green: 255,
                          blue: 255,
                          alpha: 179,
                        ),
                  size: 24,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: SimpleVRGlassesIcon(
                  color: _selectedIndex == 1
                      ? Colors.white
                      : Colors.white.withValues(
                          red: 255,
                          green: 255,
                          blue: 255,
                          alpha: 179,
                        ),
                  size: 34,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: _selectedIndex == 2
                      ? Colors.white
                      : Colors.white.withValues(
                          red: 255,
                          green: 255,
                          blue: 255,
                          alpha: 179,
                        ),
                  size: 24,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.menu_book,
                  color: _selectedIndex == 3
                      ? Colors.white
                      : Colors.white.withValues(
                          red: 255,
                          green: 255,
                          blue: 255,
                          alpha: 179,
                        ),
                  size: 24,
                ),
                onPressed: () => _onItemTapped(3),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 4
                      ? Colors.white
                      : Colors.white.withValues(
                          red: 255,
                          green: 255,
                          blue: 255,
                          alpha: 179,
                        ),
                  size: 24,
                ),
                onPressed: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleVRGlassesIcon extends StatelessWidget {
  final Color color;
  final double size;

  const SimpleVRGlassesIcon({super.key, required this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SimpleVRGlassesPainter(color: color)),
    );
  }
}

class _SimpleVRGlassesPainter extends CustomPainter {
  final Color color;

  _SimpleVRGlassesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 0.15,
        size.height * 0.35,
        size.width * 0.85,
        size.height * 0.65,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.35),
      Offset(size.width * 0.5, size.height * 0.65),
      paint,
    );

    canvas.drawOval(
      Rect.fromLTRB(
        size.width * 0.2,
        size.height * 0.4,
        size.width * 0.45,
        size.height * 0.6,
      ),
      paint,
    );

    canvas.drawOval(
      Rect.fromLTRB(
        size.width * 0.55,
        size.height * 0.4,
        size.width * 0.8,
        size.height * 0.6,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PilgrimagePlannerScreen extends StatefulWidget {
  const PilgrimagePlannerScreen({super.key});

  @override
  State<PilgrimagePlannerScreen> createState() =>
      _PilgrimagePlannerScreenState();
}

class _PilgrimagePlannerScreenState extends State<PilgrimagePlannerScreen> {
  final TextEditingController daysController = TextEditingController();
  String selectedReligion = 'Buddhism';
  String selectedRegion = 'Colombo District'; // Default region

  final List<String> religions = [
    'Buddhism',
    'Hinduism',
    'Christianity',
    'Islam',
  ];

  // Complete list of Sri Lanka districts
  final List<String> regions = [
    'Ampara District',
    'Anuradhapura District',
    'Badulla District',
    'Batticaloa District',
    'Colombo District',
    'Galle District',
    'Gampaha District',
    'Hambantota District',
    'Jaffna District',
    'Kalutara District',
    'Kandy District',
    'Kegalle District',
    'Kilinochchi District',
    'Kurunegala District',
    'Mannar District',
    'Matale District',
    'Matara District',
    'Monaragala District',
    'Mullaitivu District',
    'Nuwara Eliya District',
    'Polonnaruwa District',
    'Puttalam District',
    'Ratnapura District',
    'Trincomalee District',
    'Vavuniya District',
  ];

  LocationModel? userLocation;
  bool _isLoadingLocation = false;
  String? _locationError;

  @override
  void initState() {
    super.initState();
    // Initialize with default location
    userLocation = LocationModel(
      latitude: 6.9271,
      longitude: 79.8612,
      name: 'Colombo',
    );

    // Attempt to get user's current location when the screen loads
    _getCurrentLocation();
  }

  // Add method to get current location
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationError = null;
    });

    debugPrint('PilgrimagePlanner: Getting current location...');

    try {
      // Show feedback if it takes time
      Future.delayed(const Duration(seconds: 2), () {
        if (_isLoadingLocation && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Getting your location... Please wait.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      });

      // Use the LocationService to get location
      final locationService = LocationService();
      final position = await locationService.getCurrentLocation();

      if (position != null) {
        final placeName = await locationService.getAddressFromCoordinates(
              position.latitude,
              position.longitude,
            ) ??
            'Current Location';

        if (mounted) {
          setState(() {
            userLocation = LocationModel(
              latitude: position.latitude,
              longitude: position.longitude,
              name: placeName,
              timestamp: DateTime.now(), // Explicitly add timestamp
            );
            _isLoadingLocation = false;

            // Update the region based on location
            _updateRegionBasedOnLocation();
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Location updated: $placeName'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Could not get location');
      }
    } catch (e) {
      debugPrint('Error getting location: $e');

      if (mounted) {
        setState(() {
          _locationError = e.toString();
          _isLoadingLocation = false;
        });
      }
    }
  }

  // Update region based on current location
  void _updateRegionBasedOnLocation() {
    if (userLocation == null) return;

    // Find nearest region by comparing coordinates
    // Here's a simplified version - in a real app you would have more precise region boundaries
    if (userLocation!.latitude > 7.8 && userLocation!.latitude < 9.8) {
      // Northern regions
      if (userLocation!.longitude < 80.2) {
        selectedRegion = 'Jaffna District';
      } else {
        selectedRegion = 'Trincomalee District';
      }
    } else if (userLocation!.latitude > 7.0 && userLocation!.latitude < 7.8) {
      // Central regions
      selectedRegion = 'Kandy District';
    } else if (userLocation!.latitude > 6.5 && userLocation!.latitude < 7.0) {
      // Western regions
      if (userLocation!.longitude < 80.0) {
        selectedRegion = 'Colombo District';
      } else {
        selectedRegion = 'Kegalle District';
      }
    } else {
      // Southern regions
      if (userLocation!.longitude < 80.3) {
        selectedRegion = 'Galle District';
      } else {
        selectedRegion = 'Hambantota District';
      }
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 2)),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.teal,
            colorScheme: const ColorScheme.light(primary: Colors.teal),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        String formattedStart = DateFormat('MMM d').format(picked.start);
        String formattedEnd = DateFormat('MMM d, yyyy').format(picked.end);
        daysController.text = '$formattedStart - $formattedEnd';
      });
    }
  }

  // Add this method to verify location before navigation
  void _navigateToRecommendations() {
    // Validate date range
    if (daysController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date range'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if we have a valid location
    if (userLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set your starting location'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // If location is too old, suggest refreshing
    final now = DateTime.now();
    final locationTimestamp = userLocation!.timestamp ?? now;
    final difference = now.difference(locationTimestamp);

    if (difference.inMinutes > 30) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location might be outdated'),
          content: const Text(
            'Your location data is more than 30 minutes old. Would you like to refresh it before continuing?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getCurrentLocation().then((_) {
                  // Only navigate if we're still mounted
                  if (mounted) _actuallyNavigateToRecommendations();
                });
              },
              child: const Text('REFRESH'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _actuallyNavigateToRecommendations();
              },
              child: const Text('CONTINUE ANYWAY'),
            ),
          ],
        ),
      );
    } else {
      _actuallyNavigateToRecommendations();
    }
  }

  // The actual navigation method
  void _actuallyNavigateToRecommendations() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationsScreen(
          religion: selectedReligion,
          dateRange: daysController.text,
          region: selectedRegion,
          locationName: userLocation!.name,
          userLocation: userLocation!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Your Pilgrimage',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal[800],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal[800]),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Religion Selection
                const Text(
                  'Select Religion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                _buildReligionSelector(),
                const SizedBox(height: 24),

                // Date Range Selection
                const Text(
                  'Select Date Range',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: daysController,
                  readOnly: true,
                  onTap: () => _selectDateRange(context),
                  decoration: InputDecoration(
                    hintText: 'Select date range',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                ),
                const SizedBox(height: 24),

                // Region Selection
                const Text(
                  'Select Region',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedRegion,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: regions
                      .map(
                        (region) => DropdownMenuItem(
                          value: region,
                          child: Text(region),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedRegion = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 24),

                // Location Section
                const Text(
                  'Starting Location',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.teal[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              userLocation?.name ?? 'Unknown location',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          _isLoadingLocation
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : TextButton.icon(
                                  onPressed: _getCurrentLocation,
                                  icon: const Icon(Icons.my_location),
                                  label: const Text('Get Current'),
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.teal.withOpacity(0.1),
                                  ),
                                ),
                        ],
                      ),
                      if (userLocation != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'GPS: ${userLocation!.latitude.toStringAsFixed(4)}, ${userLocation!.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      if (_locationError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _locationError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _navigateToRecommendations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Get Recommendations',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Simple religion selector with radio buttons
  Widget _buildReligionSelector() {
    return Column(
      children: religions.map((religion) {
        return RadioListTile<String>(
          title: Text(religion),
          value: religion,
          groupValue: selectedReligion,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedReligion = value;
              });
            }
          },
        );
      }).toList(),
    );
  }
}

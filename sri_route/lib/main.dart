import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sacred Journey',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.teal[50],
        primarySwatch: Colors.blue, // From first app
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.teal[900],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.teal[900]),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),
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
          hintStyle: TextStyle(color: Colors.teal[300]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 5,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  // List of pages or screens
  static final List<Widget> _widgetOptions = <Widget>[
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal[100]!, Colors.teal[50]!],
        ),
      ),
      child: const Center(child: Text('Home Screen')),
    ),
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal[100]!, Colors.teal[50]!],
        ),
      ),
      child: const Center(child: Text('VR Tour')),
    ),
    const PilgrimagePlannerScreen(),
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal[100]!, Colors.teal[50]!],
        ),
      ),
      child: const Center(child: Text('User Manual Screen')),
    ),
    Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal[100]!, Colors.teal[50]!],
        ),
      ),
      child: const Center(child: Text('Profile Screen')),
    ),
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
      appBar: AppBar(
        title: Text(
          'Sacred Journey',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.teal[900],
          ),
        ),
        centerTitle: true,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home, size: 24),
                color:
                    _selectedIndex == 0
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: VRTourIcon(
                  color:
                      _selectedIndex == 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                  size: 28,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                icon: Icon(Icons.search, size: 24),
                color:
                    _selectedIndex == 2
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(Icons.menu_book, size: 24),
                color:
                    _selectedIndex == 3
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                onPressed: () => _onItemTapped(3),
              ),
              IconButton(
                icon: Icon(Icons.person, size: 24),
                color:
                    _selectedIndex == 4
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                onPressed: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom VR Tour Icon
class VRTourIcon extends StatelessWidget {
  final Color color;
  final double size;

  const VRTourIcon({required this.color, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(painter: _VRTourPainter(color: color)),
    );
  }
}

// Painter for VR Tour Icon
class _VRTourPainter extends CustomPainter {
  final Color color;

  _VRTourPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;

    final Paint fillPaint =
        Paint()
          ..color = color.withOpacity(0.2)
          ..style = PaintingStyle.fill;

    final Rect headsetRect = Rect.fromLTRB(
      size.width * 0.15,
      size.height * 0.25,
      size.width * 0.85,
      size.height * 0.75,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(headsetRect, Radius.circular(4)),
      fillPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(headsetRect, Radius.circular(4)),
      paint,
    );

    canvas.drawOval(
      Rect.fromLTRB(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.45,
        size.height * 0.65,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromLTRB(
        size.width * 0.55,
        size.height * 0.35,
        size.width * 0.75,
        size.height * 0.65,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width * 0.15, size.height * 0.5),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.85, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      paint,
    );

    final Paint tourPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.1,
      tourPaint,
    );
    final Path tourPath =
        Path()
          ..moveTo(size.width * 0.45, size.height * 0.55)
          ..quadraticBezierTo(
            size.width * 0.5,
            size.height * 0.45,
            size.width * 0.55,
            size.height * 0.55,
          );
    canvas.drawPath(tourPath, tourPaint);

    final Paint shadowPaint =
        Paint()
          ..color = color.withOpacity(0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width * 0.15, size.height * 0.75),
      Offset(size.width * 0.85, size.height * 0.75),
      shadowPaint,
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
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  String selectedReligion = 'Buddhism';

  final List<String> religions = [
    'Buddhism',
    'Hinduism',
    'Christianity',
    'Islam',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.teal[100]!, Colors.teal[50]!],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Craft Your Pilgrimage',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                    shadows: [
                      Shadow(
                        color: Colors.teal[200]!,
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedReligion,
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Colors.teal,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Religion',
                      labelStyle: TextStyle(
                        color: Colors.teal[900],
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                    ),
                    items:
                        religions.map((String religion) {
                          return DropdownMenuItem<String>(
                            value: religion,
                            child: Text(religion),
                          );
                        }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedReligion = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  budgetController,
                  'Budget',
                  'Enter your budget',
                  TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  daysController,
                  'Days',
                  'Enter number of days',
                  TextInputType.number,
                  const Icon(Icons.calendar_month, color: Colors.teal),
                ),
                const SizedBox(height: 20),
                _buildTextField(regionController, 'Region', 'Enter region'),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        budgetController.clear();
                        daysController.clear();
                        regionController.clear();
                        setState(() {
                          selectedReligion = 'Buddhism';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.teal[900],
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ResultsScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Explore',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, [
    TextInputType? keyboardType,
    Widget? suffixIcon,
  ]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: Colors.teal[900],
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: suffixIcon,
      ),
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Your Sacred Path',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.teal[900],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[100]!, Colors.teal[50]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Discover Your Journey',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: const [
                      PilgrimageCard(
                        imageUrl: 'https://via.placeholder.com/600x400',
                        title: 'Sacred Site 1',
                        location: 'Location 1',
                      ),
                      SizedBox(height: 16),
                      PilgrimageCard(
                        imageUrl: 'https://via.placeholder.com/600x400',
                        title: 'Sacred Site 2',
                        location: 'Location 2',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PilgrimageCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;

  const PilgrimageCard({
    required this.imageUrl,
    required this.title,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.teal[200],
                    child: const Icon(
                      Icons.error,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.teal[900]!.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          location,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

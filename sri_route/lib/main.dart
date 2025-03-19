import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class ResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Results')),
      body: Center(child: Text('Results will be displayed here')),
    );
  }
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
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

// Duplicate class definition removed

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
  void dispose() {
    // Dispose controllers to prevent memory leaks
    budgetController.dispose();
    daysController.dispose();
    regionController.dispose();
    super.dispose();
  }

  // Basic validation before navigating to ResultsScreen
  void _validateAndNavigate() {
    if (budgetController.text.isEmpty ||
        daysController.text.isEmpty ||
        regionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final budget = double.tryParse(budgetController.text);
    final days = int.tryParse(daysController.text);
    if (budget == null || days == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget and Days must be valid numbers')),
      );
      return;
    }

    // Navigate to ResultsScreen if validation passes
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsScreen()),
    );
  }

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
                const Text(
                  'Plan Your Journey with AI',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
                    decoration: InputDecoration(
                      labelText: selectedReligion, // Dynamically update label
                      labelStyle: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                    ),
                    items:
                        religions.map((String religion) {
                          return DropdownMenuItem<String>(
                            value: religion,
                            child: Text(
                              religion,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
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
                  'Budget:',
                  'Enter your budget',
                  TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  daysController,
                  'Days / Time:',
                  'Enter number of days',
                  TextInputType.number,
                  const Icon(Icons.calendar_today, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _buildTextField(regionController, 'Region:', 'Enter region'),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            budgetController.clear();
                            daysController.clear();
                            regionController.clear();
                            setState(() {
                              selectedReligion = 'Buddhism';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'CANCEL',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: _validateAndNavigate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF1A237E,
                            ), // Dark blue
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'GENERATE',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
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
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: suffixIcon,
        filled: true, // Enable filled background
        fillColor: Colors.white.withOpacity(0.9), // Match dropdown background
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
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}

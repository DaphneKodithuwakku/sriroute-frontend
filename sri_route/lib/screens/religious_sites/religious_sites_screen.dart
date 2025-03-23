import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Religious Sites App',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(),
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

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    const Center(child: Text('VR Tour Screen')),
    const Center(child: Text('Search Screen')),
    const Center(child: Text('User Manual Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
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
                icon: Icon(Icons.home, color: Colors.white, size: 24),
                onPressed: () => _onItemTapped(0),
                color:
                    _selectedIndex == 0
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
              ),
              IconButton(
                icon: SimpleVRGlassesIcon(
                  color:
                      _selectedIndex == 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                  size: 34,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white, size: 24),
                onPressed: () => _onItemTapped(2),
                color:
                    _selectedIndex == 2
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
              ),
              IconButton(
                icon: Icon(Icons.menu_book, color: Colors.white, size: 24),
                onPressed: () => _onItemTapped(3),
                color:
                    _selectedIndex == 3
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 24),
                onPressed: () => _onItemTapped(4),
                color:
                    _selectedIndex == 4
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Home Screen'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReligiousSitesPage()),
              );
            },
            child: const Text('Go to Religious Sites'),
          ),
        ],
      ),
    );
  }
}

class SimpleVRGlassesIcon extends StatelessWidget {
  final Color color;
  final double size;

  const SimpleVRGlassesIcon({required this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    final Paint paint =
        Paint()
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

class ReligiousSitesPage extends StatefulWidget {
  @override
  _ReligiousSitesPageState createState() => _ReligiousSitesPageState();
}

class _ReligiousSitesPageState extends State<ReligiousSitesPage> {
  String? selectedReligion;
  String? selectedDistrict;

  final List<String> religions = [
    "Buddhism",
    "Christianity",
    "Hinduism",
    "Islam",
  ];
  final List<String> districts = [
    "Colombo",
    "Kandy",
    "Jaffna",
    "Galle",
    "Anuradhapura",
  ];

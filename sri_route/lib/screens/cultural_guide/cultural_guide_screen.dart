import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueGrey[800],
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey[800]!, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey[800],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const TransportPage(),
    const PilgrimagePlannerPage(),
    const CulturalSensitivityPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  color: _selectedIndex == 0 ? Colors.white : Colors.white70,
                  size: 24,
                ),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: SimpleVRGlassesIcon(
                  color: _selectedIndex == 1 ? Colors.white : Colors.white70,
                  size: 34,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: _selectedIndex == 2 ? Colors.white : Colors.white70,
                  size: 24,
                ),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.menu_book,
                  color: _selectedIndex == 3 ? Colors.white : Colors.white70,
                  size: 24,
                ),
                onPressed: () => _onItemTapped(3),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 4 ? Colors.white : Colors.white70,
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

class CulturalSensitivityPage extends StatefulWidget {
  const CulturalSensitivityPage({super.key});

  @override
  _CulturalSensitivityPageState createState() =>
      _CulturalSensitivityPageState();
}

class _CulturalSensitivityPageState extends State<CulturalSensitivityPage> {
  String selectedReligion = 'Buddhism';

  final Map<String, Map<String, dynamic>> guidelines = {
    'Buddhism': {
      'title': 'Buddhist Cultural Sensitivity',
      'icon': Icons.temple_buddhist,
      'color': Colors.brown[700],
      'dress_code': {
        'title': 'Dress Code',
        'icon': Icons.checkroom,
        'content':
            'Wear loose-fitting, white or muted clothing to temples—bright colors may be seen as disrespectful. Cover shoulders, chest, and knees. Remove hats and shoes before entering sacred spaces. Avoid leather, as it’s linked to harming animals.',
      },
      'photo_rules': {
        'title': 'Photography Rules',
        'icon': Icons.camera_alt,
        'content':
            'Never pose in front of or touch Buddha statues for photos—it’s considered disrespectful. Photography inside shrines is often forbidden; look for signs or ask monks. Avoid flash to preserve serenity and artifacts.',
      },
      'behavior': {
        'title': 'Respectful Behavior',
        'icon': Icons.people,
        'content':
            'Bow slightly to monks as a greeting, but don’t shake hands. Never point your feet at Buddha images or people—it’s offensive. Sit lower than monks or statues to show humility. Avoid loud speech or laughter in meditation areas.',
      },
      'offerings': {
        'title': 'Appropriate Offerings',
        'icon': Icons.card_giftcard,
        'content':
            'Offer lotus flowers, incense sticks, or small candles—avoid artificial items. Present offerings with both hands, palms up, as a sign of respect. Join locals in chanting or bowing if invited, but don’t interrupt meditations.',
      },
    },
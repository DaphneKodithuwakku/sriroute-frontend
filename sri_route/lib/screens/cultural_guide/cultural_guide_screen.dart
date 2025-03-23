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

     'Christianity': {
      'title': 'Christian Cultural Sensitivity',
      'icon': Icons.church,
      'color': Colors.blueGrey[600],
      'dress_code': {
        'title': 'Dress Code',
        'icon': Icons.checkroom,
        'content':
            'Wear modest attire—long skirts or pants, no shorts. In Catholic churches, women may cover heads with a scarf during Mass. Protestant services may be less formal but avoid casual wear like flip-flops. Remove hats indoors unless it’s a religious custom.',
      },
      'photo_rules': {
        'title': 'Photography Rules',
        'icon': Icons.camera_alt,
        'content':
            'Photography varies by denomination: Catholic cathedrals may ban it during Mass, while Protestant churches might allow it. Never photograph the Eucharist or baptism without permission. Respect stained glass and relics by avoiding flash.',
      },
      'behavior': {
        'title': 'Respectful Behavior',
        'icon': Icons.people,
        'content':
            'Genuflect (kneel briefly) when passing the altar in Catholic churches. Join hymns or prayers if invited, but don’t take Communion unless you’re baptized in that denomination. Silence phones and avoid walking during scripture readings.',
      },
      'offerings': {
        'title': 'Appropriate Offerings',
        'icon': Icons.card_giftcard,
        'content':
            'Place monetary tithes in offering plates discreetly—coins are fine, but bills are common. Candles can be lit for prayer in Catholic churches; follow the local custom. Avoid flowers during Lent unless specified by the church.',
      },
    },
    'Hinduism': {
      'title': 'Hindu Cultural Sensitivity',
      'icon': Icons.temple_hindu,
      'color': Colors.deepOrange[700],
      'dress_code': {
        'title': 'Dress Code',
        'icon': Icons.checkroom,
        'content':
            'Wear traditional attire like sarees or kurtas if possible; otherwise, cover legs and shoulders. Remove shoes far from the sanctum—some temples ban leather belts or bags. During festivals like Diwali, bright colors are encouraged.',
      },
      'photo_rules': {
        'title': 'Photography Rules',
        'icon': Icons.camera_alt,
        'content':
            'Photography of the inner sanctum or deity is forbidden—priests may confiscate devices. Avoid capturing rituals like aarti unless permitted. Outdoor temple architecture is usually fine to photograph, but ask locals first.',
      },
      'behavior': {
        'title': 'Respectful Behavior',
        'icon': Icons.people,
        'content':
            'Circumambulate (walk around) deities clockwise—never counterclockwise. Don’t touch priests or offerings unless invited. Accept tilak (forehead mark) graciously with your right hand. Avoid entering temples during menstruation in some regions.',
      },
      'offerings': {
        'title': 'Appropriate Offerings',
        'icon': Icons.card_giftcard,
        'content':
            'Offer marigolds, bananas, or sweets like laddoos—check temple rules, as some ban onions or garlic. Present offerings to priests with your right hand, bowing slightly. During festivals, small oil lamps (diyas) are appreciated.',
      },
    },
    'Islam': {
      'title': 'Islamic Cultural Sensitivity',
      'icon': Icons.mosque,
      'color': Colors.teal[800],
      'dress_code': {
        'title': 'Dress Code',
        'icon': Icons.checkroom,
        'content':
            'Women must wear hijabs and loose abayas covering all but face and hands in mosques. Men should wear long pants and shirts—no shorts. Remove shoes and socks before entering prayer halls; some mosques provide robes if needed.',
      },
      'photo_rules': {
        'title': 'Photography Rules',
        'icon': Icons.camera_alt,
        'content':
            'Photography is often banned inside mosques, especially during Salah (prayer). Avoid capturing worshippers’ faces, particularly women. Minarets and courtyards are usually fine, but confirm with mosque staff.',
      },
      'behavior': {
        'title': 'Respectful Behavior',
        'icon': Icons.people,
        'content':
            'Stand aside during the five daily prayers—don’t cross prayer lines. Say “As-salamu Alaikum” as a greeting, responding with “Wa Alaikum Assalam.” Men and women sit separately; non-Muslims shouldn’t enter the mihrab (prayer niche).',
      },
      'offerings': {
        'title': 'Appropriate Offerings',
        'icon': Icons.card_giftcard,
        'content':
            'Donate to charity boxes (Sadaqah) discreetly—small bills are fine. During Ramadan, sharing dates or water for Iftar is valued, but ask first. Avoid food offerings inside the mosque unless it’s a community event.',
      },
    },
  };

  final Map<String, Map<String, String>> iconToGuideline = {
    'Buddhism': {
      'Bow to Monks': 'behavior',
      'Sit Lower': 'behavior',
      'Mindful Silence': 'behavior',
      'No Handshakes': 'behavior',
    },
    'Christianity': {
      'Genuflect': 'behavior',
      'Join Hymns': 'behavior',
      'No Lent Flowers': 'offerings',
      'No Communion': 'behavior',
    },
    'Hinduism': {
      'Clockwise Walk': 'behavior',
      'Accept Tilak': 'behavior',
      'Marigolds': 'offerings',
      'No Alcohol': 'behavior',
    },
    'Islam': {
      'Prayer Space': 'behavior',
      'Salam Greeting': 'behavior',
      'Gender Separate': 'behavior',
      'Ramadan Dates': 'offerings',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Check if we're in a MainScreen context
            if (ModalRoute.of(context)?.settings.name == '/home') {
              // If in MainScreen, just navigate back to home tab
              Navigator.of(context).pushReplacementNamed('/home', arguments: 0);
            } else if (Navigator.canPop(context)) {
              // If we can pop (we're on a separate route), just pop back
              Navigator.of(context).pop();
            } else {
              // Otherwise, navigate to home as fallback
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
        ),
        title: Text(
          guidelines[selectedReligion]!['title']!,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    guidelines[selectedReligion]!['color'] as Color,
                    (guidelines[selectedReligion]!['color'] as Color)
                        .withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
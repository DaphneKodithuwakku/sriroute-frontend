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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ), // Adjusted to make it thinner
              child: Row(
                children: [
                  Icon(
                    guidelines[selectedReligion]!['icon'] as IconData,
                    color: Colors.white,
                    size: 30,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButton<String>(
                      value: selectedReligion,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      dropdownColor: Colors.blueGrey[800],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedReligion = newValue!;
                        });
                      },
                      items:
                          ['Buddhism', 'Christianity', 'Hinduism', 'Islam']
                              .map(
                                (religion) => DropdownMenuItem(
                                  value: religion,
                                  child: Text(religion),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildVisualGuide(),
            const SizedBox(height: 24),
            ...['dress_code', 'photo_rules', 'behavior', 'offerings'].map(
              (key) => _buildGuideItem(
                guidelines[selectedReligion]![key]['icon'] as IconData,
                guidelines[selectedReligion]![key]['title'] as String,
                guidelines[selectedReligion]![key]['content'] as String,
                guidelines[selectedReligion]!['color'] as Color,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.book, color: Colors.blueGrey[800], size: 28),
                        const SizedBox(width: 12),
                        Text(
                          "Additional Resources",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildResourceTile(
                      Icons.language,
                      "Local Customs Guide",
                      "Download our comprehensive guide",
                      () => _showDownloadDialog(context),
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

  Widget _buildVisualGuide() {
    if (selectedReligion == 'Buddhism') {
      return _buildBuddhismVisualGuide();
    } else if (selectedReligion == 'Hinduism') {
      return _buildHinduismVisualGuide();
    } else if (selectedReligion == 'Christianity') {
      return _buildChristianityVisualGuide();
    } else {
      return _buildIslamVisualGuide();
    }
  }

  Widget _buildBuddhismVisualGuide() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildGuideIcon(
            icon: Icons.person_outline,
            label: 'Bow to Monks',
            color: Colors.brown[700]!,
          ),
          _buildGuideIcon(
            icon: Icons.directions_walk,
            label: 'Sit Lower',
            color: Colors.brown[700]!,
          ),
          _buildGuideIcon(
            icon: Icons.self_improvement,
            label: 'Mindful Silence',
            color: Colors.brown[700]!,
          ),
          _buildGuideIcon(
            icon: Icons.handshake,
            label: 'No Handshakes',
            color: Colors.brown[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildChristianityVisualGuide() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildGuideIcon(
            icon: Icons.pan_tool,
            label: 'Genuflect',
            color: Colors.blueGrey[600]!,
          ),
          _buildGuideIcon(
            icon: Icons.music_note,
            label: 'Join Hymns',
            color: Colors.blueGrey[600]!,
          ),
          _buildGuideIcon(
            icon: Icons.local_florist,
            label: 'No Lent Flowers',
            color: Colors.blueGrey[600]!,
          ),
          _buildGuideIcon(
            icon: Icons.no_meals,
            label: 'No Communion',
            color: Colors.blueGrey[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildHinduismVisualGuide() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildGuideIcon(
            icon: Icons.donut_large,
            label: 'Clockwise Walk',
            color: Colors.deepOrange[700]!,
          ),
          _buildGuideIcon(
            icon: Icons.front_hand,
            label: 'Accept Tilak',
            color: Colors.deepOrange[700]!,
          ),
          _buildGuideIcon(
            icon: Icons.local_florist,
            label: 'Marigolds',
            color: Colors.deepOrange[700]!,
          ),
          _buildGuideIcon(
            icon: Icons.no_drinks,
            label: 'No Alcohol',
            color: Colors.deepOrange[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildIslamVisualGuide() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildGuideIcon(
            icon: Icons.mosque,
            label: 'Prayer Space',
            color: Colors.teal[800]!,
          ),
          _buildGuideIcon(
            icon: Icons.handshake,
            label: 'Salam Greeting',
            color: Colors.teal[800]!,
          ),
          _buildGuideIcon(
            icon: Icons.people_alt,
            label: 'Gender Separate',
            color: Colors.teal[800]!,
          ),
          _buildGuideIcon(
            icon: Icons.local_dining,
            label: 'Ramadan Dates',
            color: Colors.teal[800]!,
          ),
        ],
      ),
    );
  }

  Widget _buildGuideIcon({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildGuideItem(
    IconData icon,
    String title,
    String text,
    Color color,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(text, style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey[800], size: 24),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  void _showDownloadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Download Guide'),
            content: const Text(
              'Would you like to download the cultural sensitivity guide?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Download started...')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Download'),
              ),
            ],
          ),
    );
  }
}

// Simple VR Glasses Icon
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

// Placeholder pages
class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: const Center(child: Text('Home Page')),
  );
}

class TransportPage extends StatelessWidget {
  const TransportPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Virtual Videos')),
    body: const Center(child: Text('Virtual Videos')),
  );
}

class PilgrimagePlannerPage extends StatelessWidget {
  const PilgrimagePlannerPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Pilgrimage Planner')),
    body: const Center(child: Text('Pilgrimage Planner Page')),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profile')),
    body: const Center(child: Text('Profile Page')),
  );
}

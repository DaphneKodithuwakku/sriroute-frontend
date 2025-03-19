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
        primaryColor: Colors.blueGrey[800], // Professional dark blue-grey
        scaffoldBackgroundColor: Colors.grey[50], // Subtle off-white background
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
      home: const CulturalSensitivityPage(),
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
  int _selectedNavIndex = 2;

  final Map<String, Map<String, dynamic>> guidelines = {
    'Buddhism': {
      'title': 'Buddhist Cultural Sensitivity',
      'icon': Icons.temple_buddhist,
      'color': Colors.brown[700], // Professional earthy brown
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
      'color': Colors.blueGrey[600], // Professional muted blue-grey
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
      'color': Colors.deepOrange[700], // Professional deep orange
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
      'color': Colors.teal[800], // Professional teal
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

  void _navigateToPage(int index) {
    setState(() {
      _selectedNavIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransportPage()),
        );
        break;
      case 2:
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationsPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          guidelines[selectedReligion]!['title']!,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language, size: 24),
            onSelected: (String language) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Language changed to $language')),
              );
            },
            itemBuilder: (BuildContext context) {
              return ['English', 'Sinhala', 'Tamil'].map((String language) {
                return PopupMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList();
            },
          ),
        ],
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
              padding: const EdgeInsets.all(16),
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
                    _buildResourceTile(
                      Icons.translate,
                      "Common Phrases",
                      "Learn respectful greetings",
                      () => _showPhrasesDialog(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[800]!, Colors.blueGrey[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarIcon(
                Icons.home_outlined,
                0,
                _selectedNavIndex,
                _navigateToPage,
              ),
              NavBarIcon(
                Icons.directions_bus_outlined,
                1,
                _selectedNavIndex,
                _navigateToPage,
              ),
              NavBarIcon(
                Icons.explore_outlined,
                2,
                _selectedNavIndex,
                _navigateToPage,
              ),
              NavBarIcon(
                Icons.notifications_outlined,
                3,
                _selectedNavIndex,
                _navigateToPage,
              ),
              NavBarIcon(
                Icons.person_outline,
                4,
                _selectedNavIndex,
                _navigateToPage,
              ),
            ],
          ),
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
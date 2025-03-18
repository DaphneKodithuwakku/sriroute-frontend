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
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const CulturalSensitivityPage(),
    );
  }
}

class CulturalSensitivityPage extends StatefulWidget {
  const CulturalSensitivityPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CulturalSensitivityPageState createState() =>
      _CulturalSensitivityPageState();
}

class _CulturalSensitivityPageState extends State<CulturalSensitivityPage> {
  String selectedLanguage = 'English';

  final Map<String, Map<String, String>> guidelines = {
    'English': {
      'title': 'Cultural Sensitivity Guide',
      'dress_code': 'Dress modestly according to local customs.',
      'photo_rules': 'Avoid taking photos where not allowed.',
      'behavior': 'Respect religious rituals and silence zones.',
    },
    'සිංහල': {
      'title': 'සංස්කෘතික සංවේදනීය මාර්ගෝපදේශය',
      'dress_code': 'දේශීය සිරිත් සීළිට අනූව වස්ත්‍රාභරණය කරන්න.',
      'photo_rules': 'අවසර නැති ප්‍රදේශවල ඡායාරූප ගැනීමෙන් වළකින්න.',
      'behavior': 'ධාර්මික චාරිත්‍ර සහ නිහතමානී ප්‍රදේශ ගරු කරන්න.',
    },
    'தமிழ்': {
      'title': 'கலாச்சார உணர்வுத் தலைமுறை',
      'dress_code': 'உள்ளூர் மரபுகளின்படி ஏற்ற உடையணியுங்கள்.',
      'photo_rules': 'அனுமதி இல்லாத இடங்களில் புகைப்படம் எடுக்க வேண்டாம்.',
      'behavior': 'மத சடங்குகள் மற்றும் அமைதி பகுதிகளை மதிக்கவும்.',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(guidelines[selectedLanguage]!['title']!)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selector
            DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                });
              },
              items:
                  ['English', 'සිංහල', 'தமிழ்']
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: Text(lang)),
                      )
                      .toList(),
            ),
            const SizedBox(height: 20),

            // Guidelines
            _buildGuideItem(
              Icons.check,
              guidelines[selectedLanguage]!['dress_code']!,
            ),
            _buildGuideItem(
              Icons.camera_alt,
              guidelines[selectedLanguage]!['photo_rules']!,
            ),
            _buildGuideItem(
              Icons.volume_off,
              guidelines[selectedLanguage]!['behavior']!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideItem(IconData icon, String text) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(text),
      ),
    );
  }
}

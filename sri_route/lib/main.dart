import 'package:flutter/material.dart';

void main() {
  runApp(const SriRouteApp());
}

class SriRouteApp extends StatelessWidget {
  const SriRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.teal[50],
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
      home: const PilgrimagePlannerScreen(),
    );
  }
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Sacred Journey Planner',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Colors.teal[900],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 22),
          onPressed: () {
            // Add navigation logic here if needed
          },
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

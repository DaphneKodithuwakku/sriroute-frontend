import 'package:flutter/material.dart';

void main() {
  runApp(SriRouteApp());
}

class SriRouteApp extends StatelessWidget {
  const SriRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: PilgrimagePlannerScreen(),
    );
  }
}

class PilgrimagePlannerScreen extends StatefulWidget {
  const PilgrimagePlannerScreen({super.key});

  @override
  _PilgrimagePlannerScreenState createState() =>
      _PilgrimagePlannerScreenState();
}

class _PilgrimagePlannerScreenState extends State<PilgrimagePlannerScreen> {
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController daysController = TextEditingController();
  final TextEditingController regionController = TextEditingController();
  String selectedReligion = 'Buddhism';

  List<String> religions = ['Buddhism', 'Hinduism', 'Christianity', 'Islam'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plan Your Journey with AI')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              value: selectedReligion,
              items:
                  religions.map((String religion) {
                    return DropdownMenuItem(
                      value: religion,
                      child: Text(religion),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReligion = value as String;
                });
              },
              decoration: InputDecoration(labelText: 'Religion'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: budgetController,
              decoration: InputDecoration(labelText: 'Budget'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: daysController,
              decoration: InputDecoration(labelText: 'Days / Time'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: regionController,
              decoration: InputDecoration(labelText: 'Region'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Clear inputs
                    budgetController.clear();
                    daysController.clear();
                    regionController.clear();
                    setState(() {
                      selectedReligion = 'Buddhism';
                    });
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(
                    'Generate',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Pilgrimage Suggestions')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Hey! Here are some places according to your budget, days, and region.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Image.network(
            'https://via.placeholder.com/300',
          ), // Placeholder for an actual image
          SizedBox(height: 10),
          Image.network('https://via.placeholder.com/300'),
        ],
      ),
    );
  }
}

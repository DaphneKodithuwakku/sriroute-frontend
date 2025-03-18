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
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Your Journey with AI',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () {},
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonFormField(
                value: selectedReligion,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.indigo[900],
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: Colors.indigo[900],
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
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
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Budget:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: budgetController,
              decoration: InputDecoration(
                hintText: 'Enter your budget',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text(
              'Days :',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: daysController,
              decoration: InputDecoration(
                hintText: 'Enter number of days',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixIcon: Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            Text(
              'Region:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: regionController,
              decoration: InputDecoration(
                hintText: 'Enter region',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
            Spacer(),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    minimumSize: Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
                    backgroundColor: Colors.indigo[900],
                    foregroundColor: Colors.white,
                    minimumSize: Size(120, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Generate'),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavBarIcon(Icons.home_outlined, 0, _selectedIndex, (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
                NavBarIcon(Icons.directions_bus_outlined, 1, _selectedIndex, (
                  index,
                ) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
                NavBarIcon(Icons.explore_outlined, 2, _selectedIndex, (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
                NavBarIcon(Icons.notifications_outlined, 3, _selectedIndex, (
                  index,
                ) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
                NavBarIcon(Icons.person_outline, 4, _selectedIndex, (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavBarIcon extends StatelessWidget {
  final IconData iconData;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const NavBarIcon(
    this.iconData,
    this.index,
    this.selectedIndex,
    this.onTap, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        iconData,
        color: index == selectedIndex ? Colors.white : Colors.grey,
        size: 24,
      ),
      onPressed: () => onTap(index),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Your Journey with AI',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Hey! Here are some places according to your budget, days and region',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          PilgrimageCard(
            imageUrl: 'https://via.placeholder.com/600x400',
            title: 'Jetavanaramaya Stupa',
            location: 'Anuradhapura, Sri Lanka',
          ),
          SizedBox(height: 16),
          PilgrimageCard(
            imageUrl: 'https://via.placeholder.com/600x400',
            title: 'Sri Dalada Maligawa',
            location: 'Kandy, Sri Lanka',
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 12, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.home_outlined, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.directions_bus_outlined, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.explore_outlined, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.notifications_outlined, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.person_outline, color: Colors.grey),
                  onPressed: () {},
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
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

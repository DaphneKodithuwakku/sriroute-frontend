import 'package:flutter/material.dart';
import 'homescreen.dart'; // Import HomeScreen
import 'profile.dart'; // Import ProfilePage

class SidePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40), // Space from top
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop(); // Close drawer
            },
          ),
          SizedBox(height: 20),
          _buildMenuItem(context, Icons.apps, "Home", Colors.red, HomeScreen()),
          _buildMenuItem(context, Icons.search, "Pilgrimage Planner", Colors.orange, null),
          _buildMenuItem(context, Icons.favorite, "Virtual Tour Favorites", Colors.amber, null),
          _buildMenuItem(context, Icons.settings, "Settings", Colors.green, ProfilePage()),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Color color, Widget? page) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(); // Close the drawer first
        if (page != null) {
          Navigator.pushReplacement( // Navigate to the page
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'homescreen.dart';
import 'profile.dart';

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
              Navigator.of(context).pop();
            },
          ),
          SizedBox(height: 20),
          _buildMenuItem(Icons.apps, "Home", Colors.red),
          _buildMenuItem(Icons.search, "Pilgrimage Planner", Colors.orange),
          _buildMenuItem(
            Icons.favorite,
            "Virtual Tour Favorites",
            Colors.amber,
          ),
          _buildMenuItem(Icons.settings, "Settings", Colors.green),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color color) {
    return Padding(
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
    );
  }
}

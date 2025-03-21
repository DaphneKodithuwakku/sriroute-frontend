import 'package:flutter/material.dart';
import 'package:profilepage/editprofile.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profilepicture.png'),
          ),
          SizedBox(height: 10),
          Text(
            'Jenny Peters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey),
              SizedBox(width: 5),
              Text(
                'Alberto, Canada',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage())
              )
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            ),
            child: Text('Edit profile', style: TextStyle(color: Colors.white)),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                _buildSettingsTile(
                  Icons.bookmark,
                  'Saved/Favourite Virtual Tours',
                ),
                _buildSettingsTile(Icons.security, 'Security & Permissions'),
                _buildSettingsTile(Icons.notifications, 'Notifications'),
                _buildSettingsTile(Icons.lock, 'Privacy'),
                Divider(),
                _buildSettingsTile(Icons.language, 'Language'),
                _buildSettingsTile(Icons.help, 'Help & Support'),
                _buildSettingsTile(Icons.info, 'Terms and Policies'),
                _buildSettingsTile(Icons.flag, 'Report a problem'),
                _buildSettingsTile(Icons.logout, 'Log out'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: () {},
    );
  }
}

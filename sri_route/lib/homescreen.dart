import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Image + User Info
            Stack(
              children: [
                // Background Image
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/header_bg.png',
                      ), // Your background image
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // User Info + Profile Pic
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi, Jenny',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Alberto, Canada',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color.fromARGB(179, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              'assets/user_profile.png',
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.settings,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for places...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Categories Section
            sectionTitle('Categories'),
            categoryGrid(),
            SizedBox(height: 20),
            // Popular Virtual Tours
            sectionTitle('Popular (Virtual Tours)'),
            tourList(),
            SizedBox(height: 20),
            // Maps Section
            sectionTitle('Maps'),
            mapContainer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.vrpano), label: 'Tours'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget categoryGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        children: [
          categoryItem('Religious Sites', Icons.place, Colors.red),
          categoryItem('Virtual Tours', Icons.vrpano, Colors.orange),
          categoryItem('Pilgrimage Planner', Icons.event, Colors.yellow),
          categoryItem('Donation', Icons.volunteer_activism, Colors.green),
          categoryItem('Cultural Guide', Icons.menu_book, Colors.lightGreen),
          categoryItem('Achievements', Icons.videogame_asset, Colors.blue),
        ],
      ),
    );
  }

  Widget categoryItem(String title, IconData icon, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget tourList() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          tourCard('Sri Dalada M...', 'Kandy', 'assets/sri_dalada.png'),
          tourCard('Red Mosque', 'Colombo', 'assets/red_mosque.png'),
          tourCard('Basilica of O...', 'Ragama', 'assets/basilica.png'),
        ],
      ),
    );
  }

  Widget tourCard(String title, String location, String image) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              image,
              height: 80,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(location, style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }

  Widget mapContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage('assets/map.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SriRoute',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 🔥 SliverAppBar (Sticky Scrolling Header)
          SliverAppBar(
            expandedHeight: 180, // Adjust height as needed
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image with Curved Corners
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: Image.asset(
                      'assets/header_bg.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Dark Overlay for better visibility
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),

                  // Header Content (Hi Jenny + Icons + Search)
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),

                          // Row with User Info + Icons
                          Row(
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Alberto, Canada',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundImage: AssetImage(
                                      'assets/user_profile.png',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 15),

                          // Search Bar inside the header
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Search for places...',
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 🔥 Body starts here (Categories, Virtual Tours, etc.)
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),

              // Categories
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10), // Reduced space here
              // Grid of Categories
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                childAspectRatio:
                    1, // Adjusts the aspect ratio of the grid items
                children: [
                  categoryItem('Religious Sites', Icons.place, Colors.red),
                  categoryItem('Virtual Tours', Icons.vrpano, Colors.orange),
                  categoryItem(
                    'Pilgrimage Planner',
                    Icons.event,
                    Colors.yellow,
                  ),
                  categoryItem(
                    'Donation',
                    Icons.volunteer_activism,
                    Colors.green,
                  ),
                  categoryItem(
                    'Cultural Guide',
                    Icons.menu_book,
                    Colors.lightGreen,
                  ),
                  categoryItem(
                    'Achievements',
                    Icons.videogame_asset,
                    Colors.blue,
                  ),
                ],
              ),

              SizedBox(height: 5),

              // Popular Virtual Tours
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Popular (Virtual Tours)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),

              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 16),
                  children: [
                    tourCard(
                      'Sri Dalada M...',
                      'Kandy',
                      'assets/sri_dalada.png',
                    ),
                    tourCard('Red Mosque', 'Colombo', 'assets/red_mosque.png'),
                    tourCard(
                      'Basilica of O...',
                      'Ragama',
                      'assets/basilica.png',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Maps Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Maps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
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
              ),

              SizedBox(height: 30), // Prevent bottom cut-off
            ]),
          ),
        ],
      ),

      // Bottom Navigation Bar
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

  // Category Item Widget
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

  // Tour Card Widget
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
}

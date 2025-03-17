import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, Jenny'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/user_profile.png',
              ), // Change to your image
            ),
            onPressed: () {},
          ),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alberto, Canada',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search for places...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
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
              SizedBox(height: 20),
              Text(
                'Popular (Virtual Tours)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
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
              Text(
                'Maps',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/map.png',
                    ), // Change to your map image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
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

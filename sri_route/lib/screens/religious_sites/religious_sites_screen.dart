import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Religious Sites App',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    const Center(child: Text('VR Tour Screen')),
    const Center(child: Text('Search Screen')),
    const Center(child: Text('User Manual Screen')),
    const Center(child: Text('Profile Screen')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 24),
                onPressed: () => _onItemTapped(0),
                color:
                    _selectedIndex == 0
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
              ),
              IconButton(
                icon: SimpleVRGlassesIcon(
                  color:
                      _selectedIndex == 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.7),
                  size: 34,
                ),
                onPressed: () => _onItemTapped(1),
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white, size: 24),
                onPressed: () => _onItemTapped(2),
                color:
                    _selectedIndex == 2
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
              ),
              IconButton(
                icon: Icon(Icons.menu_book, color: Colors.white, size: 24),
                onPressed: () => _onItemTapped(3),
                color:
                    _selectedIndex == 3
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 24),
                onPressed: () => _onItemTapped(4),
                color:
                    _selectedIndex == 4
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Home Screen'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReligiousSitesPage()),
              );
            },
            child: const Text('Go to Religious Sites'),
          ),
        ],
      ),
    );
  }
}

class SimpleVRGlassesIcon extends StatelessWidget {
  final Color color;
  final double size;

  const SimpleVRGlassesIcon({required this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(painter: _SimpleVRGlassesPainter(color: color)),
    );
  }
}

class _SimpleVRGlassesPainter extends CustomPainter {
  final Color color;

  _SimpleVRGlassesPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    canvas.drawRect(
      Rect.fromLTRB(
        size.width * 0.15,
        size.height * 0.35,
        size.width * 0.85,
        size.height * 0.65,
      ),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.35),
      Offset(size.width * 0.5, size.height * 0.65),
      paint,
    );

    canvas.drawOval(
      Rect.fromLTRB(
        size.width * 0.2,
        size.height * 0.4,
        size.width * 0.45,
        size.height * 0.6,
      ),
      paint,
    );

    canvas.drawOval(
      Rect.fromLTRB(
        size.width * 0.55,
        size.height * 0.4,
        size.width * 0.8,
        size.height * 0.6,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ReligiousSitesPage extends StatefulWidget {
  @override
  _ReligiousSitesPageState createState() => _ReligiousSitesPageState();
}

class _ReligiousSitesPageState extends State<ReligiousSitesPage> {
  String? selectedReligion;
  String? selectedDistrict;

  final List<String> religions = [
    "Buddhism",
    "Christianity",
    "Hinduism",
    "Islam",
  ];
  final List<String> districts = [
    "Colombo",
    "Kandy",
    "Jaffna",
    "Galle",
    "Anuradhapura",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Religious Sites",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Religion",
                labelStyle: const TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.account_balance,
                  color: Colors.teal,
                ),
              ),
              value: selectedReligion,
              items:
                  religions.map((religion) {
                    return DropdownMenuItem<String>(
                      value: religion,
                      child: Text(religion),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReligion = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select District",
                labelStyle: const TextStyle(color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.location_on, color: Colors.teal),
              ),
              value: selectedDistrict,
              items:
                  districts.map((district) {
                    return DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                });
              },
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ReligiousSitesList(
                religion: selectedReligion,
                district: selectedDistrict,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white, size: 24),
                onPressed: null, // No action
              ),
              IconButton(
                icon: SimpleVRGlassesIcon(
                  color: Colors.white.withOpacity(0.7),
                  size: 34,
                ),
                onPressed: null, // No action
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white, size: 24),
                onPressed: null, // No action
              ),
              IconButton(
                icon: Icon(Icons.menu_book, color: Colors.white, size: 24),
                onPressed: null, // No action
              ),
              IconButton(
                icon: Icon(Icons.person, color: Colors.white, size: 24),
                onPressed: null, // No action
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReligiousSitesList extends StatelessWidget {
  final String? religion;
  final String? district;

  const ReligiousSitesList({this.religion, this.district});

  IconData _getReligionIcon(String religion) {
    switch (religion) {
      case "Buddhism":
        return Icons.temple_buddhist;
      case "Christianity":
        return Icons.church;
      case "Hinduism":
        return Icons.temple_hindu;
      case "Islam":
        return Icons.mosque;
      default:
        return Icons.place;
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSites =
        religiousSites.where((site) {
          final matchesReligion = religion == null || site.religion == religion;
          final matchesDistrict = district == null || site.district == district;
          return matchesReligion && matchesDistrict;
        }).toList();

    if (religion == null || district == null) {
      return Center(
        child: Text(
          "Please select both a religion and a district.",
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    if (filteredSites.isEmpty) {
      return Center(
        child: Text(
          "No sites found for the selected criteria.",
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredSites.length,
      itemBuilder: (context, index) {
        final site = filteredSites[index];
        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.teal.withOpacity(0.1),
                      child: Icon(
                        _getReligionIcon(site.religion),
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Text(
                        site.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    site.imagePath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Text('Image not available'),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  site.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton.icon(
                  onPressed: () => _launchUrl(site.googleMapsLink),
                  icon: const Icon(Icons.map),
                  label: const Text('Open in Google Maps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2), // Dark Blue
                    foregroundColor: Colors.white, // Text/icon color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  "${site.religion} - ${site.district}",
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReligiousSite {
  final String name;
  final String religion;
  final String district;
  final String imagePath;
  final String description;
  final String googleMapsLink;

  ReligiousSite({
    required this.name,
    required this.religion,
    required this.district,
    required this.imagePath,
    required this.description,
    required this.googleMapsLink,
  });
}

final List<ReligiousSite> religiousSites = [
  // Colombo
  ReligiousSite(
    name: "Gangaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
    imagePath: "assets/images/Gangaramaya_Temple.jpg",
    description:
        "A blend of modern and traditional architecture with a museum-like collection of artifacts.",
    googleMapsLink: "https://maps.google.com/?q=Gangaramaya+Temple,Colombo",
  ),
  ReligiousSite(
    name: "Kelaniya Raja Maha Vihara",
    religion: "Buddhism",
    district: "Colombo",
    imagePath: "assets/images/Kelaniya_Raja_Maha_Vihara.jpg",
    description:
        "Famous for its ancient frescoes and believed to be visited by the Buddha.",
    googleMapsLink:
        "https://maps.google.com/?q=Kelaniya+Raja+Maha+Vihara,Colombo",
  ),
  ReligiousSite(
    name: "Asokaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
    imagePath: "assets/images/Asokaramaya_Temple.jpg",
    description:
        "A serene Buddhist temple known for its peaceful environment and intricate designs.",
    googleMapsLink: "https://maps.google.com/?q=Asokaramaya+Temple,Colombo",
  ),
  ReligiousSite(
    name: "Vajira Sri Temple",
    religion: "Buddhism",
    district: "Colombo",
    imagePath: "assets/images/Vajira_Sri_Temple.jpg",
    description:
        "A notable Buddhist temple in Colombo with a rich cultural heritage.",
    googleMapsLink: "https://maps.google.com/?q=Vajira+Sri+Temple,Colombo",
  ),
  ReligiousSite(
    name: "Isipathanaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
    imagePath: "assets/images/Isipathanaramaya_Temple.jpg",
    description:
        "A Buddhist temple known for its architectural beauty and tranquil setting.",
    googleMapsLink:
        "https://maps.google.com/?q=Isipathanaramaya+Temple,Colombo",
  ),
  ReligiousSite(
    name: "St. Anthony’s Shrine",
    religion: "Christianity",
    district: "Colombo",
    imagePath: "assets/images/St_Anthony’s_Shrine.jpg",
    description:
        "A Catholic shrine known for miracles and drawing multi-faith visitors.",
    googleMapsLink: "https://maps.google.com/?q=St+Anthony’s+Shrine,Colombo",
  ),
  ReligiousSite(
    name: "Wolvendaal Church",
    religion: "Christianity",
    district: "Colombo",
    imagePath: "assets/images/Wolvendaal_Church.jpg",
    description:
        "A historic Dutch colonial church with a unique architectural style.",
    googleMapsLink: "https://maps.google.com/?q=Wolvendaal+Church,Colombo",
  ),
  ReligiousSite(
    name: "St. Lucia’s Cathedral",
    religion: "Christianity",
    district: "Colombo",
    imagePath: "assets/images/St_Lucia’s_Cathedral.jpg",
    description:
        "The main Catholic cathedral in Colombo, known for its grand structure.",
    googleMapsLink: "https://maps.google.com/?q=St+Lucia’s+Cathedral,Colombo",
  ),
  ReligiousSite(
    name: "All Saints’ Church",
    religion: "Christianity",
    district: "Colombo",
    imagePath: "assets/images/All_Saints’_Church.jpg",
    description: "A prominent Anglican church in Colombo with a rich history.",
    googleMapsLink: "https://maps.google.com/?q=All+Saints’+Church,Colombo",
  ),
  ReligiousSite(
    name: "St. Andrew’s Scots Kirk",
    religion: "Christianity",
    district: "Colombo",
    imagePath: "assets/images/St_Andrew’s_Scots_Kirk.jpg",
    description:
        "A Presbyterian church known for its Scottish heritage and architecture.",
    googleMapsLink: "https://maps.google.com/?q=St+Andrew’s+Scots+Kirk,Colombo",
  ),
  ReligiousSite(
    name: "Sri Kailawasanathan Swami Devasthanam",
    religion: "Hinduism",
    district: "Colombo",
    imagePath: "assets/images/Sri_Kailawasanathan_Swami_Devasthanam.jpg",
    description:
        "A significant Hindu temple in Colombo dedicated to Lord Shiva.",
    googleMapsLink:
        "https://maps.google.com/?q=Sri+Kailawasanathan+Swami+Devasthanam,Colombo",
  ),
  ReligiousSite(
    name: "New Kathiresan Kovil",
    religion: "Hinduism",
    district: "Colombo",
    imagePath: "assets/images/New_Kathiresan_Kovil.jpg",
    description: "A vibrant Hindu temple known for its colorful architecture.",
    googleMapsLink: "https://maps.google.com/?q=New+Kathiresan+Kovil,Colombo",
  ),
  ReligiousSite(
    name: "Old Kathiresan Kovil",
    religion: "Hinduism",
    district: "Colombo",
    imagePath: "assets/images/Old_Kathiresan_Kovil.jpg",
    description: "An older Hindu temple with traditional South Indian design.",
    googleMapsLink: "https://maps.google.com/?q=Old+Kathiresan+Kovil,Colombo",
  ),
  ReligiousSite(
    name: "Sri Ponnambalawaneswaram Kovil",
    religion: "Hinduism",
    district: "Colombo",
    imagePath: "assets/images/Sri_Ponnambalawaneswaram_Kovil.jpg",
    description:
        "A historic Hindu temple made of black stone, dedicated to Lord Shiva.",
    googleMapsLink:
        "https://maps.google.com/?q=Sri+Ponnambalawaneswaram+Kovil,Colombo",
  ),
  ReligiousSite(
    name: "Sri Muthumariamman Kovil",
    religion: "Hinduism",
    district: "Colombo",
    imagePath: "assets/images/Sri_Muthumariamman_Kovil.jpg",
    description:
        "A Hindu temple dedicated to Goddess Mariamman, popular among devotees.",
    googleMapsLink:
        "https://maps.google.com/?q=Sri+Muthumariamman+Kovil,Colombo",
  ),
  ReligiousSite(
    name: "Jami Ul-Alfar Mosque",
    religion: "Islam",
    district: "Colombo",
    imagePath: "assets/images/Jami_Ul-Alfar_Mosque.jpg",
    description:
        "A striking red and white mosque in Pettah, known for its unique architecture.",
    googleMapsLink: "https://maps.google.com/?q=Jami+Ul-Alfar+Mosque,Colombo",
  ),
  ReligiousSite(
    name: "Dewatagaha Mosque",
    religion: "Islam",
    district: "Colombo",
    imagePath: "assets/images/Dewatagaha_Mosque.jpg",
    description: "A historic mosque with a shrine dedicated to a Muslim saint.",
    googleMapsLink: "https://maps.google.com/?q=Dewatagaha+Mosque,Colombo",
  ),
  ReligiousSite(
    name: "Colombo Grand Mosque",
    religion: "Islam",
    district: "Colombo",
    imagePath: "assets/images/Colombo_Grand_Mosque.jpg",
    description:
        "One of the oldest mosques in Colombo, serving the Muslim community.",
    googleMapsLink: "https://maps.google.com/?q=Colombo+Grand+Mosque,Colombo",
  ),
  ReligiousSite(
    name: "Kollupitiya Mosque",
    religion: "Islam",
    district: "Colombo",
    imagePath: "assets/images/Kollupitiya_Mosque.jpg",
    description: "A modern mosque located in the Kollupitiya area of Colombo.",
    googleMapsLink: "https://maps.google.com/?q=Kollupitiya+Mosque,Colombo",
  ),
  ReligiousSite(
    name: "Maradana Mosque",
    religion: "Islam",
    district: "Colombo",
    imagePath: "assets/images/Maradana_Mosque.jpg",
    description:
        "A key mosque in the Maradana area, known for its community activities.",
    googleMapsLink: "https://maps.google.com/?q=Maradana+Mosque,Colombo",
  ),

  // Kandy
  ReligiousSite(
    name: "Temple of the Tooth",
    religion: "Buddhism",
    district: "Kandy",
    imagePath: "assets/images/Temple_of_the_Tooth.jpg",
    description:
        "A sacred Buddhist temple housing the relic of the tooth of the Buddha.",
    googleMapsLink: "https://maps.google.com/?q=Temple+of+the+Tooth,Kandy",
  ),
  ReligiousSite(
    name: "Lankatilaka Vihara",
    religion: "Buddhism",
    district: "Kandy",
    imagePath: "assets/images/Lankatilaka_Vihara.jpg",
    description:
        "An ancient Buddhist temple known for its architecture and frescoes.",
    googleMapsLink: "https://maps.google.com/?q=Lankatilaka+Vihara,Kandy",
  ),
  ReligiousSite(
    name: "Gadaladeniya Vihara",
    religion: "Buddhism",
    district: "Kandy",
    imagePath: "assets/images/Gadaladeniya_Vihara.jpg",
    description:
        "A 14th-century Buddhist temple with intricate stone carvings.",
    googleMapsLink: "https://maps.google.com/?q=Gadaladeniya+Vihara,Kandy",
  ),
  ReligiousSite(
    name: "Embekka Devalaya",
    religion: "Buddhism",
    district: "Kandy",
    imagePath: "assets/images/Embekka_Devalaya.jpg",
    description: "Famous for its wooden pillars and historical significance.",
    googleMapsLink: "https://maps.google.com/?q=Embekka+Devalaya,Kandy",
  ),
  ReligiousSite(
    name: "Degaldoruwa Raja Maha Vihara",
    religion: "Buddhism",
    district: "Kandy",
    imagePath: "assets/images/Degaldoruwa_Raja_Maha_Vihara.jpg",
    description:
        "A cave temple known for its ancient murals and serene location.",
    googleMapsLink:
        "https://maps.google.com/?q=Degaldoruwa+Raja+Maha+Vihara,Kandy",
  ),
  ReligiousSite(
    name: "St. Paul’s Church",
    religion: "Christianity",
    district: "Kandy",
    imagePath: "assets/images/St_Paul’s_Church.jpg",
    description:
        "An Anglican church near the Temple of the Tooth, with colonial architecture.",
    googleMapsLink: "https://maps.google.com/?q=St+Paul’s+Church,Kandy",
  ),
  ReligiousSite(
    name: "Trinity College Chapel",
    religion: "Christianity",
    district: "Kandy",
    imagePath: "assets/images/Trinity_College_Chapel.jpg",
    description:
        "A chapel within Trinity College, known for its historical value.",
    googleMapsLink: "https://maps.google.com/?q=Trinity+College+Chapel,Kandy",
  ),
  ReligiousSite(
    name: "St. Anthony’s Cathedral",
    religion: "Christianity",
    district: "Kandy",
    imagePath: "assets/images/St_Anthony’s_Cathedral.jpg",
    description: "A Catholic cathedral in Kandy with a prominent presence.",
    googleMapsLink: "https://maps.google.com/?q=St+Anthony’s+Cathedral,Kandy",
  ),
  ReligiousSite(
    name: "Church of Ceylon",
    religion: "Christianity",
    district: "Kandy",
    imagePath: "assets/images/Church_of_Ceylon.jpg",
    description: "A significant Anglican church in the Kandy region.",
    googleMapsLink: "https://maps.google.com/?q=Church+of+Ceylon,Kandy",
  ),
  ReligiousSite(
    name: "Kandy Methodist Church",
    religion: "Christianity",
    district: "Kandy",
    imagePath: "assets/images/Kandy_Methodist_Church.jpg",
    description: "A Methodist church serving the local Christian community.",
    googleMapsLink: "https://maps.google.com/?q=Kandy+Methodist+Church,Kandy",
  ),
  ReligiousSite(
    name: "Kataragama Devale",
    religion: "Hinduism",
    district: "Kandy",
    imagePath: "assets/images/Kataragama_Devale.jpg",
    description:
        "A Hindu shrine dedicated to Lord Kataragama, located near the Temple of the Tooth.",
    googleMapsLink: "https://maps.google.com/?q=Kataragama+Devale,Kandy",
  ),
  ReligiousSite(
    name: "Sri Maha Vishnu Devale",
    religion: "Hinduism",
    district: "Kandy",
    imagePath: "assets/images/Sri_Maha_Vishnu_Devale.jpg",
    description: "A Hindu temple dedicated to Lord Vishnu in Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Sri+Maha+Vishnu+Devale,Kandy",
  ),
  ReligiousSite(
    name: "Pattini Devale",
    religion: "Hinduism",
    district: "Kandy",
    imagePath: "assets/images/Pattini_Devale.jpg",
    description:
        "A temple Dedicated to Goddess Pattini, a popular deity in Sri Lanka.",
    googleMapsLink: "https://maps.google.com/?q=Pattini+Devale,Kandy",
  ),
  ReligiousSite(
    name: "Natha Devale",
    religion: "Hinduism",
    district: "Kandy",
    imagePath: "assets/images/Natha_Devale.jpg",
    description: "One of the oldest shrines in Kandy, dedicated to Lord Natha.",
    googleMapsLink: "https://maps.google.com/?q=Natha+Devale,Kandy",
  ),
  ReligiousSite(
    name: "Kandy Jumma Mosque",
    religion: "Islam",
    district: "Kandy",
    imagePath: "assets/images/Kandy_Jumma_Mosque.jpg",
    description: "A central mosque in Kandy serving the Muslim population.",
    googleMapsLink: "https://maps.google.com/?q=Kandy+Jumma+Mosque,Kandy",
  ),
  ReligiousSite(
    name: "Meera Makam Mosque",
    religion: "Islam",
    district: "Kandy",
    imagePath: "assets/images/Meera_Makam_Mosque.jpg",
    description: "A historic mosque with cultural significance in Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Meera+Makam+Mosque,Kandy",
  ),
  ReligiousSite(
    name: "Hanafi Mosque",
    religion: "Islam",
    district: "Kandy",
    imagePath: "assets/images/Hanafi_Mosque.jpg",
    description: "A mosque following the Hanafi school of Islamic thought.",
    googleMapsLink: "https://maps.google.com/?q=Hanafi+Mosque,Kandy",
  ),
  ReligiousSite(
    name: "Katugastota Mosque",
    religion: "Islam",
    district: "Kandy",
    imagePath: "assets/images/Katugastota_Mosque.jpg",
    description: "A community mosque located in Katugastota, near Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Katugastota+Mosque,Kandy",
  ),
  ReligiousSite(
    name: "Peradeniya Mosque",
    religion: "Islam",
    district: "Kandy",
    imagePath: "assets/images/Peradeniya_Mosque.jpg",
    description: "A mosque near the University of Peradeniya in Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Peradeniya+Mosque,Kandy",
  ),

  // Jaffna
  ReligiousSite(
    name: "Nagadeepa Purana Vihara",
    religion: "Buddhism",
    district: "Jaffna",
    imagePath: "assets/images/Nagadeepa_Purana_Vihara.jpg",
    description:
        "An ancient Buddhist temple on Nainativu Island, visited by the Buddha.",
    googleMapsLink: "https://maps.google.com/?q=Nagadeepa+Purana+Vihara,Jaffna",
  ),
  ReligiousSite(
    name: "St. James’ Church",
    religion: "Christianity",
    district: "Jaffna",
    imagePath: "assets/images/St_James’_Church.jpg",
    description:
        "A historic Anglican church in Jaffna with colonial architecture.",
    googleMapsLink: "https://maps.google.com/?q=St+James’+Church,Jaffna",
  ),
  ReligiousSite(
    name: "St. Mary’s Cathedral",
    religion: "Christianity",
    district: "Jaffna",
    imagePath: "assets/images/St_Mary’s_Cathedral.jpg",
    description: "The main Catholic cathedral in Jaffna, a key religious site.",
    googleMapsLink: "https://maps.google.com/?q=St+Mary’s+Cathedral,Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Methodist Church",
    religion: "Christianity",
    district: "Jaffna",
    imagePath: "assets/images/Jaffna_Methodist_Church.jpg",
    description:
        "A Methodist church serving the Christian community in Jaffna.",
    googleMapsLink: "https://maps.google.com/?q=Jaffna+Methodist+Church,Jaffna",
  ),
  ReligiousSite(
    name: "St. John’s Church",
    religion: "Christianity",
    district: "Jaffna",
    imagePath: "assets/images/St_John’s_Church.jpg",
    description: "An Anglican church with historical significance in Jaffna.",
    googleMapsLink: "https://maps.google.com/?q=St+John’s+Church,Jaffna",
  ),
  ReligiousSite(
    name: "Nallur Kandaswamy Temple",
    religion: "Hinduism",
    district: "Jaffna",
    imagePath: "assets/images/Nallur_Kandaswamy_Temple.jpg",
    description:
        "A prominent Hindu temple in Jaffna dedicated to Lord Murugan.",
    googleMapsLink:
        "https://maps.google.com/?q=Nallur+Kandaswamy+Temple,Jaffna",
  ),
  ReligiousSite(
    name: "Naguleswaram Temple",
    religion: "Hinduism",
    district: "Jaffna",
    imagePath: "assets/images/Naguleswaram_Temple.jpg",
    description:
        "An ancient Hindu temple dedicated to Lord Shiva, one of the Pancha Ishwarams.",
    googleMapsLink: "https://maps.google.com/?q=Naguleswaram+Temple,Jaffna",
  ),
  ReligiousSite(
    name: "Keerimalai Naguleswaram Kovil",
    religion: "Hinduism",
    district: "Jaffna",
    imagePath: "assets/images/Keerimalai_Naguleswaram_Kovil.jpg",
    description: "A sacred Hindu temple near the Keerimalai springs.",
    googleMapsLink:
        "https://maps.google.com/?q=Keerimalai+Naguleswaram+Kovil,Jaffna",
  ),
  ReligiousSite(
    name: "Vallipuram Kovil",
    religion: "Hinduism",
    district: "Jaffna",
    imagePath: "assets/images/Vallipuram_Kovil.jpg",
    description:
        "A historic Hindu temple in Vallipuram dedicated to Lord Vishnu.",
    googleMapsLink: "https://maps.google.com/?q=Vallipuram+Kovil,Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Jumma Mosque",
    religion: "Islam",
    district: "Jaffna",
    imagePath: "assets/images/Jaffna_Jumma_Mosque.jpg",
    description: "A central mosque in Jaffna for the Muslim community.",
    googleMapsLink: "https://maps.google.com/?q=Jaffna+Jumma+Mosque,Jaffna",
  ),
  ReligiousSite(
    name: "Grand Mosque Jaffna",
    religion: "Islam",
    district: "Jaffna",
    imagePath: "assets/images/Grand_Mosque_Jaffna.jpg",
    description:
        "One of the largest mosques in Jaffna, serving as a community hub.",
    googleMapsLink: "https://maps.google.com/?q=Grand+Mosque+Jaffna,Jaffna",
  ),
  ReligiousSite(
    name: "Chavakachcheri Mosque",
    religion: "Islam",
    district: "Jaffna",
    imagePath: "assets/images/Chavakachcheri_Mosque.jpg",
    description:
        "A mosque in Chavakachcheri, catering to the local Muslim population.",
    googleMapsLink: "https://maps.google.com/?q=Chavakachcheri+Mosque,Jaffna",
  ),

  // Galle
  ReligiousSite(
    name: "Rumassala Temple",
    religion: "Buddhism",
    district: "Galle",
    imagePath: "assets/images/Rumassala_Temple.jpg",
    description: "A temple on Rumassala Hill, linked to the Ramayana legend.",
    googleMapsLink: "https://maps.google.com/?q=Rumassala+Temple,Galle",
  ),
  ReligiousSite(
    name: "Dutch Reformed Church",
    religion: "Christianity",
    district: "Galle",
    imagePath: "assets/images/Dutch_Reformed_Church.jpg",
    description:
        "A historic church within Galle Fort, built by the Dutch in 1755.",
    googleMapsLink: "https://maps.google.com/?q=Dutch+Reformed+Church,Galle",
  ),
  ReligiousSite(
    name: "All Saints’ Church Galle",
    religion: "Christianity",
    district: "Galle",
    imagePath: "assets/images/All_Saints’_Church_Galle.jpg",
    description: "An Anglican church in Galle with a colonial design.",
    googleMapsLink: "https://maps.google.com/?q=All+Saints’+Church+Galle,Galle",
  ),
  ReligiousSite(
    name: "St. Mary’s Cathedral Galle",
    religion: "Christianity",
    district: "Galle",
    imagePath: "assets/images/St_Mary’s_Cathedral_Galle.jpg",
    description: "The main Catholic cathedral in Galle, a prominent landmark.",
    googleMapsLink:
        "https://maps.google.com/?q=St+Mary’s+Cathedral+Galle,Galle",
  ),
  ReligiousSite(
    name: "Galle Methodist Church",
    religion: "Christianity",
    district: "Galle",
    imagePath: "assets/images/Galle_Methodist_Church.jpg",
    description: "A Methodist church serving the Christian community in Galle.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Methodist+Church,Galle",
  ),
  ReligiousSite(
    name: "Meeran Jumma Mosque",
    religion: "Islam",
    district: "Galle",
    imagePath: "assets/images/Meeran_Jumma_Mosque.jpg",
    description: "A prominent mosque within Galle Fort, a historical site.",
    googleMapsLink: "https://maps.google.com/?q=Meeran+Jumma+Mosque,Galle",
  ),
  ReligiousSite(
    name: "Galle Fort Mosque",
    religion: "Islam",
    district: "Galle",
    imagePath: "assets/images/Galle_Fort_Mosque.jpg",
    description:
        "A mosque located inside the Galle Fort, serving the Muslim community.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Fort+Mosque,Galle",
  ),
  ReligiousSite(
    name: "Ambalangoda Mosque",
    religion: "Islam",
    district: "Galle",
    imagePath: "assets/images/Ambalangoda_Mosque.jpg",
    description: "A community mosque in Ambalangoda, Galle district.",
    googleMapsLink: "https://maps.google.com/?q=Ambalangoda+Mosque,Galle",
  ),

  // Anuradhapura
  ReligiousSite(
    name: "Jaya Sri Maha Bodhi",
    religion: "Buddhism",
    district: "Anuradhapura",
    imagePath: "assets/images/Jaya_Sri_Maha_Bodhi.jpg",
    description:
        "A sacred fig tree believed to be a sapling from the Bodhi tree under which Buddha attained enlightenment.",
    googleMapsLink:
        "https://maps.google.com/?q=Jaya+Sri+Maha+Bodhi,Anuradhapura",
  ),
  ReligiousSite(
    name: "Ruwanwelisaya",
    religion: "Buddhism",
    district: "Anuradhapura",
    imagePath: "assets/images/Ruwanwelisaya.jpg",
    description:
        "A massive stupa built by King Dutugemunu, a UNESCO World Heritage site.",
    googleMapsLink: "https://maps.google.com/?q=Ruwanwelisaya,Anuradhapura",
  ),
  ReligiousSite(
    name: "Mihintale",
    religion: "Buddhism",
    district: "Anuradhapura",
    imagePath: "assets/images/Mihintale.jpg",
    description:
        "The cradle of Buddhism in Sri Lanka, where Buddhism was introduced.",
    googleMapsLink: "https://maps.google.com/?q=Mihintale,Anuradhapura",
  ),
  ReligiousSite(
    name: "Abhayagiri Vihara",
    religion: "Buddhism",
    district: "Anuradhapura",
    imagePath: "assets/images/Abhayagiri_Vihara.jpg",
    description:
        "An ancient Buddhist monastery with a large stupa and historical ruins.",
    googleMapsLink: "https://maps.google.com/?q=Abhayagiri+Vihara,Anuradhapura",
  ),
  ReligiousSite(
    name: "Jetavanaramaya",
    religion: "Buddhism",
    district: "Anuradhapura",
    imagePath: "assets/images/Jetavanaramaya.jpg",
    description:
        "One of the largest stupas in the world, built in the 3rd century.",
    googleMapsLink: "https://maps.google.com/?q=Jetavanaramaya,Anuradhapura",
  ),
  ReligiousSite(
    name: "St. Joseph’s Church",
    religion: "Christianity",
    district: "Anuradhapura",
    imagePath: "assets/images/St_Joseph’s_Church.jpg",
    description:
        "A Catholic church in Anuradhapura serving the local Christian community.",
    googleMapsLink:
        "https://maps.google.com/?q=St+Joseph’s+Church,Anuradhapura",
  ),
  ReligiousSite(
    name: "Natha Devale",
    religion: "Hinduism",
    district: "Anuradhapura",
    imagePath: "assets/images/Natha_Devale.jpg",
    description:
        "An ancient Hindu shrine dedicated to Lord Natha in Anuradhapura.",
    googleMapsLink: "https://maps.google.com/?q=Natha+Devale,Anuradhapura",
  ),
  ReligiousSite(
    name: "Shiva Devale No. 1",
    religion: "Hinduism",
    district: "Anuradhapura",
    imagePath: "assets/images/Shiva_Devale_No_1.jpg",
    description:
        "A Hindu temple dedicated to Lord Shiva, part of the ancient city.",
    googleMapsLink: "https://maps.google.com/?q=Shiva+Devale+No+1,Anuradhapura",
  ),
  ReligiousSite(
    name: "Shiva Devale No. 2",
    religion: "Hinduism",
    district: "Anuradhapura",
    imagePath: "assets/images/Shiva_Devale_No_2.jpg",
    description:
        "Another ancient Shiva temple in Anuradhapura’s sacred precinct.",
    googleMapsLink: "https://maps.google.com/?q=Shiva+Devale+No+2,Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Grand Mosque",
    religion: "Islam",
    district: "Anuradhapura",
    imagePath: "assets/images/Anuradhapura_Grand_Mosque.jpg",
    description: "The main mosque in Anuradhapura for the Muslim community.",
    googleMapsLink:
        "https://maps.google.com/?q=Anuradhapura+Grand+Mosque,Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Town Mosque",
    religion: "Islam",
    district: "Anuradhapura",
    imagePath: "assets/images/Anuradhapura_Town_Mosque.jpg",
    description: "A mosque in Anuradhapura town, a key religious site.",
    googleMapsLink:
        "https://maps.google.com/?q=Anuradhapura+Town+Mosque,Anuradhapura",
  ),
];

class ReligiousSitesScreen extends StatelessWidget {
  const ReligiousSitesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReligiousSitesPage();
  }
}

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
                  child: Image.network(
                    site.imageUrl,
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
  final String imageUrl;
  final String description;
  final String googleMapsLink;

  ReligiousSite({
    required this.name,
    required this.religion,
    required this.district,
    required this.imageUrl,
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
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A blend of modern and traditional architecture with a museum-like collection of artifacts.",
    googleMapsLink: "https://maps.google.com/?q=Gangaramaya+Temple,Colombo",
  ),
  ReligiousSite(
    name: "Kelaniya Raja Maha Vihara",
    religion: "Buddhism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "Famous for its ancient frescoes and believed to be visited by the Buddha.",
    googleMapsLink:
        "https://maps.google.com/?q=Kelaniya+Raja+Maha+Vihara,Colombo",
  ),
  ReligiousSite(
    name: "Asokaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A serene Buddhist temple known for its peaceful environment and intricate designs.",
    googleMapsLink: "https://maps.google.com/?q=Asokaramaya+Temple,Colombo",
  ),
  ReligiousSite(
    name: "Vajira Sri Temple",
    religion: "Buddhism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "A notable Buddhist temple in Colombo with a rich cultural heritage.",
    googleMapsLink: "https://maps.google.com/?q=Vajira+Sri+Temple,Colombo",
  ),
  ReligiousSite(
    name: "Isipathanaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A Buddhist temple known for its architectural beauty and tranquil setting.",
    googleMapsLink:
        "https://maps.google.com/?q=Isipathanaramaya+Temple,Colombo",
  ),
  ReligiousSite(
    name: "St. Anthony’s Shrine",
    religion: "Christianity",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A Catholic shrine known for miracles and drawing multi-faith visitors.",
    googleMapsLink: "https://maps.google.com/?q=St+Anthony’s+Shrine,Colombo",
  ),
  ReligiousSite(
    name: "Wolvendaal Church",
    religion: "Christianity",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A historic Dutch colonial church with a unique architectural style.",
    googleMapsLink: "https://maps.google.com/?q=Wolvendaal+Church,Colombo",
  ),
  ReligiousSite(
    name: "St. Lucia’s Cathedral",
    religion: "Christianity",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "The main Catholic cathedral in Colombo, known for its grand structure.",
    googleMapsLink: "https://maps.google.com/?q=St+Lucia’s+Cathedral,Colombo",
  ),
  ReligiousSite(
    name: "All Saints’ Church",
    religion: "Christianity",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "A prominent Anglican church in Colombo with a rich history.",
    googleMapsLink: "https://maps.google.com/?q=All+Saints’+Church,Colombo",
  ),
  ReligiousSite(
    name: "St. Andrew’s Scots Kirk",
    religion: "Christianity",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A Presbyterian church known for its Scottish heritage and architecture.",
    googleMapsLink: "https://maps.google.com/?q=St+Andrew’s+Scots+Kirk,Colombo",
  ),
  ReligiousSite(
    name: "Sri Kailawasanathan Swami Devasthanam",
    religion: "Hinduism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A significant Hindu temple in Colombo dedicated to Lord Shiva.",
    googleMapsLink:
        "https://maps.google.com/?q=Sri+Kailawasanathan+Swami+Devasthanam,Colombo",
  ),
  ReligiousSite(
    name: "New Kathiresan Kovil",
    religion: "Hinduism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A vibrant Hindu temple known for its colorful architecture.",
    googleMapsLink: "https://maps.google.com/?q=New+Kathiresan+Kovil,Colombo",
  ),
  ReligiousSite(
    name: "Old Kathiresan Kovil",
    religion: "Hinduism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "An older Hindu temple with traditional South Indian design.",
    googleMapsLink: "https://maps.google.com/?q=Old+Kathiresan+Kovil,Colombo",
  ),
  ReligiousSite(
    name: "Sri Ponnambalawaneswaram Kovil",
    religion: "Hinduism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A historic Hindu temple made of black stone, dedicated to Lord Shiva.",
    googleMapsLink:
        "https://maps.google.com/?q=Sri+Ponnambalawaneswaram+Kovil,Colombo",
  ),
  ReligiousSite(
    name: "Sri Muthumariamman Kovil",
    religion: "Hinduism",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A Hindu temple dedicated to Goddess Mariamman, popular among devotees.",
    googleMapsLink:
        "https://maps.google.com/?q=Sri+Muthumariamman+Kovil,Colombo",
  ),
  ReligiousSite(
    name: "Jami Ul-Alfar Mosque",
    religion: "Islam",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "A striking red and white mosque in Pettah, known for its unique architecture.",
    googleMapsLink: "https://maps.google.com/?q=Jami+Ul-Alfar+Mosque,Colombo",
  ),
  ReligiousSite(
    name: "Dewatagaha Mosque",
    religion: "Islam",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A historic mosque with a shrine dedicated to a Muslim saint.",
    googleMapsLink: "https://maps.google.com/?q=Dewatagaha+Mosque,Colombo",
  ),
  ReligiousSite(
    name: "Colombo Grand Mosque",
    religion: "Islam",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "One of the oldest mosques in Colombo, serving the Muslim community.",
    googleMapsLink: "https://maps.google.com/?q=Colombo+Grand+Mosque,Colombo",
  ),
  ReligiousSite(
    name: "Kollupitiya Mosque",
    religion: "Islam",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A modern mosque located in the Kollupitiya area of Colombo.",
    googleMapsLink: "https://maps.google.com/?q=Kollupitiya+Mosque,Colombo",
  ),
  ReligiousSite(
    name: "Maradana Mosque",
    religion: "Islam",
    district: "Colombo",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "A key mosque in the Maradana area, known for its community activities.",
    googleMapsLink: "https://maps.google.com/?q=Maradana+Mosque,Colombo",
  ),

  // Kandy
  ReligiousSite(
    name: "Temple of the Tooth",
    religion: "Buddhism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "A sacred Buddhist temple housing the relic of the tooth of the Buddha.",
    googleMapsLink: "https://maps.google.com/?q=Temple+of+the+Tooth,Kandy",
  ),
  ReligiousSite(
    name: "Lankatilaka Vihara",
    religion: "Buddhism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "An ancient Buddhist temple known for its architecture and frescoes.",
    googleMapsLink: "https://maps.google.com/?q=Lankatilaka+Vihara,Kandy",
  ),
  ReligiousSite(
    name: "Gadaladeniya Vihara",
    religion: "Buddhism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "A 14th-century Buddhist temple with intricate stone carvings.",
    googleMapsLink: "https://maps.google.com/?q=Gadaladeniya+Vihara,Kandy",
  ),
  ReligiousSite(
    name: "Embekka Devalaya",
    religion: "Buddhism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description: "Famous for its wooden pillars and historical significance.",
    googleMapsLink: "https://maps.google.com/?q=Embekka+Devalaya,Kandy",
  ),
  ReligiousSite(
    name: "Degaldoruwa Raja Maha Vihara",
    religion: "Buddhism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "A cave temple known for its ancient murals and serene location.",
    googleMapsLink:
        "https://maps.google.com/?q=Degaldoruwa+Raja+Maha+Vihara,Kandy",
  ),
  ReligiousSite(
    name: "St. Paul’s Church",
    religion: "Christianity",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "An Anglican church near the Temple of the Tooth, with colonial architecture.",
    googleMapsLink: "https://maps.google.com/?q=St+Paul’s+Church,Kandy",
  ),
  ReligiousSite(
    name: "Trinity College Chapel",
    religion: "Christianity",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A chapel within Trinity College, known for its historical value.",
    googleMapsLink: "https://maps.google.com/?q=Trinity+College+Chapel,Kandy",
  ),
  ReligiousSite(
    name: "St. Anthony’s Cathedral",
    religion: "Christianity",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "A Catholic cathedral in Kandy with a prominent presence.",
    googleMapsLink: "https://maps.google.com/?q=St+Anthony’s+Cathedral,Kandy",
  ),
  ReligiousSite(
    name: "Church of Ceylon",
    religion: "Christianity",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "A significant Anglican church in the Kandy region.",
    googleMapsLink: "https://maps.google.com/?q=Church+of+Ceylon,Kandy",
  ),
  ReligiousSite(
    name: "Kandy Methodist Church",
    religion: "Christianity",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "A Methodist church serving the local Christian community.",
    googleMapsLink: "https://maps.google.com/?q=Kandy+Methodist+Church,Kandy",
  ),
  ReligiousSite(
    name: "Kataragama Devale",
    religion: "Hinduism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A Hindu shrine dedicated to Lord Kataragama, located near the Temple of the Tooth.",
    googleMapsLink: "https://maps.google.com/?q=Kataragama+Devale,Kandy",
  ),
  ReligiousSite(
    name: "Sri Maha Vishnu Devale",
    religion: "Hinduism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A Hindu temple dedicated to Lord Vishnu in Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Sri+Maha+Vishnu+Devale,Kandy",
  ),
  ReligiousSite(
    name: "Pattini Devale",
    religion: "Hinduism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A temple dedicated to Goddess Pattini, a popular deity in Sri Lanka.",
    googleMapsLink: "https://maps.google.com/?q=Pattini+Devale,Kandy",
  ),
  ReligiousSite(
    name: "Natha Devale",
    religion: "Hinduism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "One of the oldest shrines in Kandy, dedicated to Lord Natha.",
    googleMapsLink: "https://maps.google.com/?q=Natha+Devale,Kandy",
  ),
  ReligiousSite(
    name: "Sri Ganesh Kovil",
    religion: "Hinduism",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A Hindu temple dedicated to Lord Ganesha in Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Sri+Ganesh+Kovil,Kandy",
  ),
  ReligiousSite(
    name: "Kandy Jumma Mosque",
    religion: "Islam",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A central mosque in Kandy serving the Muslim population.",
    googleMapsLink: "https://maps.google.com/?q=Kandy+Jumma+Mosque,Kandy",
  ),
  ReligiousSite(
    name: "Meera Makam Mosque",
    religion: "Islam",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A historic mosque with cultural significance in Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Meera+Makam+Mosque,Kandy",
  ),
  ReligiousSite(
    name: "Hanafi Mosque",
    religion: "Islam",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A mosque following the Hanafi school of Islamic thought.",
    googleMapsLink: "https://maps.google.com/?q=Hanafi+Mosque,Kandy",
  ),
  ReligiousSite(
    name: "Katugastota Mosque",
    religion: "Islam",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A community mosque located in Katugastota, near Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Katugastota+Mosque,Kandy",
  ),
  ReligiousSite(
    name: "Peradeniya Mosque",
    religion: "Islam",
    district: "Kandy",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A mosque near the University of Peradeniya in Kandy.",
    googleMapsLink: "https://maps.google.com/?q=Peradeniya+Mosque,Kandy",
  ),

  // Jaffna
  ReligiousSite(
    name: "Nagadeepa Purana Vihara",
    religion: "Buddhism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "An ancient Buddhist temple on Nainativu Island, visited by the Buddha.",
    googleMapsLink: "https://maps.google.com/?q=Nagadeepa+Purana+Vihara,Jaffna",
  ),
  ReligiousSite(
    name: "Nallur Buddhist Temple",
    religion: "Buddhism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description: "A Buddhist temple in the Nallur area of Jaffna.",
    googleMapsLink: "https://maps.google.com/?q=Nallur+Buddhist+Temple,Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Viharaya 1",
    religion: "Buddhism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "One of the Buddhist temples in Jaffna, serving the local community.",
    googleMapsLink: "https://maps.google.com/?q=Jaffna+Viharaya+1,Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Viharaya 2",
    religion: "Buddhism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description: "A Buddhist temple in Jaffna with cultural significance.",
    googleMapsLink: "https://maps.google.com/?q=Jaffna+Viharaya+2,Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Viharaya 3",
    religion: "Buddhism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "Another Buddhist temple in Jaffna, promoting peace and meditation.",
    googleMapsLink: "https://maps.google.com/?q=Jaffna+Viharaya+3,Jaffna",
  ),
  ReligiousSite(
    name: "St. James’ Church",
    religion: "Christianity",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A historic Anglican church in Jaffna with colonial architecture.",
    googleMapsLink: "https://maps.google.com/?q=St+James’+Church,Jaffna",
  ),
  ReligiousSite(
    name: "St. Mary’s Cathedral",
    religion: "Christianity",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "The main Catholic cathedral in Jaffna, a key religious site.",
    googleMapsLink: "https://maps.google.com/?q=St+Mary’s+Cathedral,Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Methodist Church",
    religion: "Christianity",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A Methodist church serving the Christian community in Jaffna.",
    googleMapsLink: "https://maps.google.com/?q=Jaffna+Methodist+Church,Jaffna",
  ),
  ReligiousSite(
    name: "Our Lady of Refuge Church",
    religion: "Christianity",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "A Catholic church known for its devotion to the Virgin Mary.",
    googleMapsLink:
        "https://maps.google.com/?q=Our+Lady+of+Refuge+Church,Jaffna",
  ),
  ReligiousSite(
    name: "St. John’s Church",
    religion: "Christianity",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "An Anglican church with historical significance in Jaffna.",
    googleMapsLink: "https://maps.google.com/?q=St+John’s+Church,Jaffna",
  ),
  ReligiousSite(
    name: "Nallur Kandaswamy Temple",
    religion: "Hinduism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A prominent Hindu temple in Jaffna dedicated to Lord Murugan.",
    googleMapsLink:
        "https://maps.google.com/?q=Nallur+Kandaswamy+Temple,Jaffna",
  ),
  ReligiousSite(
    name: "Naguleswaram Temple",
    religion: "Hinduism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "An ancient Hindu temple dedicated to Lord Shiva, one of the Pancha Ishwarams.",
    googleMapsLink: "https://maps.google.com/?q=Naguleswaram+Temple,Jaffna",
  ),
  ReligiousSite(
    name: "Maviddapuram Kandaswamy Kovil",
    religion: "Hinduism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A Hindu temple dedicated to Lord Murugan in Maviddapuram.",
    googleMapsLink:
        "https://maps.google.com/?q=Maviddapuram+Kandaswamy+Kovil,Jaffna",
  ),
  ReligiousSite(
    name: "Keerimalai Naguleswaram Kovil",
    religion: "Hinduism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A sacred Hindu temple near the Keerimalai springs.",
    googleMapsLink:
        "https://maps.google.com/?q=Keerimalai+Naguleswaram+Kovil,Jaffna",
  ),
  ReligiousSite(
    name: "Vallipuram Kovil",
    religion: "Hinduism",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A historic Hindu temple in Vallipuram dedicated to Lord Vishnu.",
    googleMapsLink: "https://maps.google.com/?q=Vallipuram+Kovil,Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Jumma Mosque",
    religion: "Islam",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A central mosque in Jaffna for the Muslim community.",
    googleMapsLink: "https://maps.google.com/?q=Jaffna+Jumma+Mosque,Jaffna",
  ),
  ReligiousSite(
    name: "Osmaniya Mosque",
    religion: "Islam",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A notable mosque in Jaffna with historical significance.",
    googleMapsLink: "https://maps.google.com/?q=Osmaniya+Mosque,Jaffna",
  ),
  ReligiousSite(
    name: "Grand Mosque Jaffna",
    religion: "Islam",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "One of the largest mosques in Jaffna, serving as a community hub.",
    googleMapsLink: "https://maps.google.com/?q=Grand+Mosque+Jaffna,Jaffna",
  ),
  ReligiousSite(
    name: "Chavakachcheri Mosque",
    religion: "Islam",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "A mosque in Chavakachcheri, catering to the local Muslim population.",
    googleMapsLink: "https://maps.google.com/?q=Chavakachcheri+Mosque,Jaffna",
  ),
  ReligiousSite(
    name: "Point Pedro Mosque",
    religion: "Islam",
    district: "Jaffna",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "A mosque in Point Pedro, a key religious site in northern Jaffna.",
    googleMapsLink: "https://maps.google.com/?q=Point+Pedro+Mosque,Jaffna",
  ),

  // Galle
  ReligiousSite(
    name: "Galle Buddhist Temple",
    religion: "Buddhism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description: "A Buddhist temple in Galle offering a peaceful retreat.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Buddhist+Temple,Galle",
  ),
  ReligiousSite(
    name: "Rumassala Temple",
    religion: "Buddhism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description: "A temple on Rumassala Hill, linked to the Ramayana legend.",
    googleMapsLink: "https://maps.google.com/?q=Rumassala+Temple,Galle",
  ),
  ReligiousSite(
    name: "Unawatuna Temple",
    religion: "Buddhism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "A Buddhist temple near Unawatuna beach, known for its serenity.",
    googleMapsLink: "https://maps.google.com/?q=Unawatuna+Temple,Galle",
  ),
  ReligiousSite(
    name: "Karandeniya Temple",
    religion: "Buddhism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description: "A local Buddhist temple in Karandeniya, Galle district.",
    googleMapsLink: "https://maps.google.com/?q=Karandeniya+Temple,Galle",
  ),
  ReligiousSite(
    name: "Hikkaduwa Temple",
    religion: "Buddhism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description: "A temple in Hikkaduwa, popular among tourists and locals.",
    googleMapsLink: "https://maps.google.com/?q=Hikkaduwa+Temple,Galle",
  ),
  ReligiousSite(
    name: "Dutch Reformed Church",
    religion: "Christianity",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A historic church within Galle Fort, built by the Dutch in 1755.",
    googleMapsLink: "https://maps.google.com/?q=Dutch+Reformed+Church,Galle",
  ),
  ReligiousSite(
    name: "All Saints’ Church Galle",
    religion: "Christianity",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "An Anglican church in Galle with a colonial design.",
    googleMapsLink: "https://maps.google.com/?q=All+Saints’+Church+Galle,Galle",
  ),
  ReligiousSite(
    name: "St. Mary’s Cathedral Galle",
    religion: "Christianity",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "The main Catholic cathedral in Galle, a prominent landmark.",
    googleMapsLink:
        "https://maps.google.com/?q=St+Mary’s+Cathedral+Galle,Galle",
  ),
  ReligiousSite(
    name: "Galle Methodist Church",
    religion: "Christianity",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "A Methodist church serving the Christian community in Galle.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Methodist+Church,Galle",
  ),
  ReligiousSite(
    name: "St. Aloysius Church",
    religion: "Christianity",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "A Catholic church in Galle with historical significance.",
    googleMapsLink: "https://maps.google.com/?q=St+Aloysius+Church,Galle",
  ),
  ReligiousSite(
    name: "Nagavihara Kovil",
    religion: "Hinduism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A Hindu temple in Galle dedicated to Lord Vishnu.",
    googleMapsLink: "https://maps.google.com/?q=Nagavihara+Kovil,Galle",
  ),
  ReligiousSite(
    name: "Sri Vishnu Kovil",
    religion: "Hinduism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A temple dedicated to Lord Vishnu in the Galle district.",
    googleMapsLink: "https://maps.google.com/?q=Sri+Vishnu+Kovil,Galle",
  ),
  ReligiousSite(
    name: "Galle Kovil 1",
    religion: "Hinduism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A local Hindu temple in Galle serving the community.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Kovil+1,Galle",
  ),
  ReligiousSite(
    name: "Galle Kovil 2",
    religion: "Hinduism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "Another Hindu temple in Galle with traditional architecture.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Kovil+2,Galle",
  ),
  ReligiousSite(
    name: "Galle Kovil 3",
    religion: "Hinduism",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A Hindu temple in Galle, part of the local religious landscape.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Kovil+3,Galle",
  ),
  ReligiousSite(
    name: "Meeran Jumma Mosque",
    religion: "Islam",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A prominent mosque within Galle Fort, a historical site.",
    googleMapsLink: "https://maps.google.com/?q=Meeran+Jumma+Mosque,Galle",
  ),
  ReligiousSite(
    name: "Galle Fort Mosque",
    religion: "Islam",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "A mosque located inside the Galle Fort, serving the Muslim community.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Fort+Mosque,Galle",
  ),
  ReligiousSite(
    name: "Hikkaduwa Mosque",
    religion: "Islam",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A mosque in Hikkaduwa, popular among locals and visitors.",
    googleMapsLink: "https://maps.google.com/?q=Hikkaduwa+Mosque,Galle",
  ),
  ReligiousSite(
    name: "Ambalangoda Mosque",
    religion: "Islam",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A community mosque in Ambalangoda, Galle district.",
    googleMapsLink: "https://maps.google.com/?q=Ambalangoda+Mosque,Galle",
  ),
  ReligiousSite(
    name: "Galle Town Mosque",
    religion: "Islam",
    district: "Galle",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A mosque in Galle town, central to the Muslim population.",
    googleMapsLink: "https://maps.google.com/?q=Galle+Town+Mosque,Galle",
  ),

  // Anuradhapura
  ReligiousSite(
    name: "Jaya Sri Maha Bodhi",
    religion: "Buddhism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "A sacred fig tree believed to be a sapling from the Bodhi tree under which Buddha attained enlightenment.",
    googleMapsLink:
        "https://maps.google.com/?q=Jaya+Sri+Maha+Bodhi,Anuradhapura",
  ),
  ReligiousSite(
    name: "Ruwanwelisaya",
    religion: "Buddhism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "A massive stupa built by King Dutugemunu, a UNESCO World Heritage site.",
    googleMapsLink: "https://maps.google.com/?q=Ruwanwelisaya,Anuradhapura",
  ),
  ReligiousSite(
    name: "Mihintale",
    religion: "Buddhism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "The cradle of Buddhism in Sri Lanka, where Buddhism was introduced.",
    googleMapsLink: "https://maps.google.com/?q=Mihintale,Anuradhapura",
  ),
  ReligiousSite(
    name: "Abhayagiri Vihara",
    religion: "Buddhism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "An ancient Buddhist monastery with a large stupa and historical ruins.",
    googleMapsLink: "https://maps.google.com/?q=Abhayagiri+Vihara,Anuradhapura",
  ),
  ReligiousSite(
    name: "Jetavanaramaya",
    religion: "Buddhism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1602210059334-3455a18f362d",
    description:
        "One of the largest stupas in the world, built in the 3rd century.",
    googleMapsLink: "https://maps.google.com/?q=Jetavanaramaya,Anuradhapura",
  ),
  ReligiousSite(
    name: "St. Joseph’s Church",
    religion: "Christianity",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A Catholic church in Anuradhapura serving the local Christian community.",
    googleMapsLink:
        "https://maps.google.com/?q=St+Joseph’s+Church,Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Methodist Church",
    religion: "Christianity",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A Methodist church in Anuradhapura with a growing congregation.",
    googleMapsLink:
        "https://maps.google.com/?q=Anuradhapura+Methodist+Church,Anuradhapura",
  ),
  ReligiousSite(
    name: "Holy Family Church",
    religion: "Christianity",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description:
        "A Catholic church dedicated to the Holy Family in Anuradhapura.",
    googleMapsLink:
        "https://maps.google.com/?q=Holy+Family+Church,Anuradhapura",
  ),
  ReligiousSite(
    name: "St. Mary’s Church",
    religion: "Christianity",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "A prominent Christian church in Anuradhapura.",
    googleMapsLink: "https://maps.google.com/?q=St+Mary’s+Church,Anuradhapura",
  ),
  ReligiousSite(
    name: "Church of Ceylon Anuradhapura",
    religion: "Christianity",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1518030704478-8c2e62f7e1b8",
    description: "An Anglican church in Anuradhapura with historical roots.",
    googleMapsLink:
        "https://maps.google.com/?q=Church+of+Ceylon+Anuradhapura,Anuradhapura",
  ),
  ReligiousSite(
    name: "Natha Devale",
    religion: "Hinduism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "An ancient Hindu shrine dedicated to Lord Natha in Anuradhapura.",
    googleMapsLink: "https://maps.google.com/?q=Natha+Devale,Anuradhapura",
  ),
  ReligiousSite(
    name: "Shiva Devale No. 1",
    religion: "Hinduism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A Hindu temple dedicated to Lord Shiva, part of the ancient city.",
    googleMapsLink: "https://maps.google.com/?q=Shiva+Devale+No+1,Anuradhapura",
  ),
  ReligiousSite(
    name: "Shiva Devale No. 2",
    religion: "Hinduism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "Another ancient Shiva temple in Anuradhapura’s sacred precinct.",
    googleMapsLink: "https://maps.google.com/?q=Shiva+Devale+No+2,Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Kovil 1",
    religion: "Hinduism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description: "A local Hindu temple in Anuradhapura serving devotees.",
    googleMapsLink:
        "https://maps.google.com/?q=Anuradhapura+Kovil+1,Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Kovil 2",
    religion: "Hinduism",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1593696140826-99e8c7f88640",
    description:
        "A Hindu temple in Anuradhapura with traditional architecture.",
    googleMapsLink:
        "https://maps.google.com/?q=Anuradhapura+Kovil+2,Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Grand Mosque",
    religion: "Islam",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "The main mosque in Anuradhapura for the Muslim community.",
    googleMapsLink:
        "https://maps.google.com/?q=Anuradhapura+Grand+Mosque,Anuradhapura",
  ),
  ReligiousSite(
    name: "Kekirawa Mosque",
    religion: "Islam",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A mosque in Kekirawa, part of the Anuradhapura district.",
    googleMapsLink: "https://maps.google.com/?q=Kekirawa+Mosque,Anuradhapura",
  ),
  ReligiousSite(
    name: "Mihintale Mosque",
    religion: "Islam",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "A mosque near Mihintale, serving the local Muslim population.",
    googleMapsLink: "https://maps.google.com/?q=Mihintale+Mosque,Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Town Mosque",
    religion: "Islam",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description: "A mosque in Anuradhapura town, a key religious site.",
    googleMapsLink:
        "https://maps.google.com/?q=Anuradhapura+Town+Mosque,Anuradhapura",
  ),
  ReligiousSite(
    name: "Medawachchiya Mosque",
    religion: "Islam",
    district: "Anuradhapura",
    imageUrl: "https://images.unsplash.com/photo-1564507004667-2e85cd1f49ad",
    description:
        "A mosque in Medawachchiya, part of the Anuradhapura district.",
    googleMapsLink:
        "https://maps.google.com/?q=Medawachchiya+Mosque,Anuradhapura",
  ),
];

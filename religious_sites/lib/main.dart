import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReligiousSitesPage(),
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
    );
  }
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
        backgroundColor: Colors.transparent, // No color behind the title
        elevation: 0, // Flat look, no shadow
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
            // Religion Dropdown
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
            // District Dropdown
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
            // Results
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

  // Religion-specific icons
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
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: ModalRoute.of(context)!.animation!,
            curve: Curves.easeIn,
          ),
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.withOpacity(0.1),
                child: Icon(
                  _getReligionIcon(site.religion),
                  color: Colors.teal,
                ),
              ),
              title: Text(
                site.name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "${site.religion} - ${site.district}",
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.teal,
              ),
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

  ReligiousSite({
    required this.name,
    required this.religion,
    required this.district,
  });
}

final List<ReligiousSite> religiousSites = [
  // Colombo
  ReligiousSite(
    name: "Gangaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Kelaniya Raja Maha Vihara",
    religion: "Buddhism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Asokaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Vajira Sri Temple",
    religion: "Buddhism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Isipathanaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "St. Anthony’s Shrine",
    religion: "Christianity",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Wolvendaal Church",
    religion: "Christianity",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "St. Lucia’s Cathedral",
    religion: "Christianity",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "All Saints’ Church",
    religion: "Christianity",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "St. Andrew’s Scots Kirk",
    religion: "Christianity",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Sri Kailawasanathan Swami Devasthanam",
    religion: "Hinduism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "New Kathiresan Kovil",
    religion: "Hinduism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Old Kathiresan Kovil",
    religion: "Hinduism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Sri Ponnambalawaneswaram Kovil",
    religion: "Hinduism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Sri Muthumariamman Kovil",
    religion: "Hinduism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Jami Ul-Alfar Mosque",
    religion: "Islam",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Dewatagaha Mosque",
    religion: "Islam",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Colombo Grand Mosque",
    religion: "Islam",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Kollupitiya Mosque",
    religion: "Islam",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Maradana Mosque",
    religion: "Islam",
    district: "Colombo",
  ),

  // Kandy
  ReligiousSite(
    name: "Temple of the Tooth",
    religion: "Buddhism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Lankatilaka Vihara",
    religion: "Buddhism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Gadaladeniya Vihara",
    religion: "Buddhism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Embekka Devalaya",
    religion: "Buddhism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Degaldoruwa Raja Maha Vihara",
    religion: "Buddhism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "St. Paul’s Church",
    religion: "Christianity",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Trinity College Chapel",
    religion: "Christianity",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "St. Anthony’s Cathedral",
    religion: "Christianity",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Church of Ceylon",
    religion: "Christianity",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Kandy Methodist Church",
    religion: "Christianity",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Kataragama Devale",
    religion: "Hinduism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Sri Maha Vishnu Devale",
    religion: "Hinduism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Pattini Devale",
    religion: "Hinduism",
    district: "Kandy",
  ),
  ReligiousSite(name: "Natha Devale", religion: "Hinduism", district: "Kandy"),
  ReligiousSite(
    name: "Sri Ganesh Kovil",
    religion: "Hinduism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Kandy Jumma Mosque",
    religion: "Islam",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Meera Makam Mosque",
    religion: "Islam",
    district: "Kandy",
  ),
  ReligiousSite(name: "Hanafi Mosque", religion: "Islam", district: "Kandy"),
  ReligiousSite(
    name: "Katugastota Mosque",
    religion: "Islam",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Peradeniya Mosque",
    religion: "Islam",
    district: "Kandy",
  ),

  // Jaffna
  ReligiousSite(
    name: "Nagadeepa Purana Vihara",
    religion: "Buddhism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Nallur Buddhist Temple",
    religion: "Buddhism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Viharaya 1",
    religion: "Buddhism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Viharaya 2",
    religion: "Buddhism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Viharaya 3",
    religion: "Buddhism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "St. James’ Church",
    religion: "Christianity",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "St. Mary’s Cathedral",
    religion: "Christianity",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Methodist Church",
    religion: "Christianity",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Our Lady of Refuge Church",
    religion: "Christianity",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "St. John’s Church",
    religion: "Christianity",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Nallur Kandaswamy Temple",
    religion: "Hinduism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Naguleswaram Temple",
    religion: "Hinduism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Maviddapuram Kandaswamy Kovil",
    religion: "Hinduism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Keerimalai Naguleswaram Kovil",
    religion: "Hinduism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Vallipuram Kovil",
    religion: "Hinduism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Jaffna Jumma Mosque",
    religion: "Islam",
    district: "Jaffna",
  ),
  ReligiousSite(name: "Osmaniya Mosque", religion: "Islam", district: "Jaffna"),
  ReligiousSite(
    name: "Grand Mosque Jaffna",
    religion: "Islam",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Chavakachcheri Mosque",
    religion: "Islam",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Point Pedro Mosque",
    religion: "Islam",
    district: "Jaffna",
  ),

  // Galle
  ReligiousSite(
    name: "Galle Buddhist Temple",
    religion: "Buddhism",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Rumassala Temple",
    religion: "Buddhism",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Unawatuna Temple",
    religion: "Buddhism",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Karandeniya Temple",
    religion: "Buddhism",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Hikkaduwa Temple",
    religion: "Buddhism",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Dutch Reformed Church",
    religion: "Christianity",
    district: "Galle",
  ),
  ReligiousSite(
    name: "All Saints’ Church Galle",
    religion: "Christianity",
    district: "Galle",
  ),
  ReligiousSite(
    name: "St. Mary’s Cathedral Galle",
    religion: "Christianity",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Galle Methodist Church",
    religion: "Christianity",
    district: "Galle",
  ),
  ReligiousSite(
    name: "St. Aloysius Church",
    religion: "Christianity",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Nagavihara Kovil",
    religion: "Hinduism",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Sri Vishnu Kovil",
    religion: "Hinduism",
    district: "Galle",
  ),
  ReligiousSite(name: "Galle Kovil 1", religion: "Hinduism", district: "Galle"),
  ReligiousSite(name: "Galle Kovil 2", religion: "Hinduism", district: "Galle"),
  ReligiousSite(name: "Galle Kovil 3", religion: "Hinduism", district: "Galle"),
  ReligiousSite(
    name: "Meeran Jumma Mosque",
    religion: "Islam",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Galle Fort Mosque",
    religion: "Islam",
    district: "Galle",
  ),
  ReligiousSite(name: "Hikkaduwa Mosque", religion: "Islam", district: "Galle"),
  ReligiousSite(
    name: "Ambalangoda Mosque",
    religion: "Islam",
    district: "Galle",
  ),
  ReligiousSite(
    name: "Galle Town Mosque",
    religion: "Islam",
    district: "Galle",
  ),

  // Anuradhapura
  ReligiousSite(
    name: "Jaya Sri Maha Bodhi",
    religion: "Buddhism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Ruwanwelisaya",
    religion: "Buddhism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Mihintale",
    religion: "Buddhism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Abhayagiri Vihara",
    religion: "Buddhism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Jetavanaramaya",
    religion: "Buddhism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "St. Joseph’s Church",
    religion: "Christianity",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Methodist Church",
    religion: "Christianity",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Holy Family Church",
    religion: "Christianity",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "St. Mary’s Church",
    religion: "Christianity",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Church of Ceylon Anuradhapura",
    religion: "Christianity",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Natha Devale",
    religion: "Hinduism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Shiva Devale No. 1",
    religion: "Hinduism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Shiva Devale No. 2",
    religion: "Hinduism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Kovil 1",
    religion: "Hinduism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Kovil 2",
    religion: "Hinduism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Grand Mosque",
    religion: "Islam",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Kekirawa Mosque",
    religion: "Islam",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Mihintale Mosque",
    religion: "Islam",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Anuradhapura Town Mosque",
    religion: "Islam",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Medawachchiya Mosque",
    religion: "Islam",
    district: "Anuradhapura",
  ),
];

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ReligiousSitesPage());
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
    "Colombo", "Kandy", "Galle", "Jaffna", "Anuradhapura", "Matale", "Gampaha",
    "Mannar",
    "Negombo",
    "Nuwara Eliya",
    "Puttalam",
    "Trincomalee",
    "Batticaloa",
    "Hambantota", // Add more districts as needed (Sri Lanka has 25 total)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Religious Sites in Sri Lanka")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Religion Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Select Religion"),
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
              decoration: const InputDecoration(labelText: "Select District"),
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

  @override
  Widget build(BuildContext context) {
    // Filter sites based on selected religion and district
    final filteredSites =
        religiousSites.where((site) {
          final matchesReligion = religion == null || site.religion == religion;
          final matchesDistrict = district == null || site.district == district;
          return matchesReligion && matchesDistrict;
        }).toList();

    if (religion == null || district == null) {
      return const Center(
        child: Text("Please select both a religion and a district."),
      );
    }

    if (filteredSites.isEmpty) {
      return const Center(
        child: Text("No sites found for the selected criteria."),
      );
    }

    return ListView.builder(
      itemCount: filteredSites.length,
      itemBuilder: (context, index) {
        final site = filteredSites[index];
        return ListTile(
          title: Text(site.name),
          subtitle: Text("${site.religion} - ${site.district}"),
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
  // Buddhism
  ReligiousSite(
    name: "Temple of the Tooth",
    religion: "Buddhism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Jaya Sri Maha Bodhi",
    religion: "Buddhism",
    district: "Anuradhapura",
  ),
  ReligiousSite(
    name: "Dambulla Cave Temple",
    religion: "Buddhism",
    district: "Matale",
  ),
  ReligiousSite(
    name: "Kelaniya Raja Maha Vihara",
    religion: "Buddhism",
    district: "Gampaha",
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
    name: "Gangaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
  ),

  // Christianity
  ReligiousSite(
    name: "St. Anthony’s Shrine",
    religion: "Christianity",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Shrine of Our Lady of Madhu",
    religion: "Christianity",
    district: "Mannar",
  ),
  ReligiousSite(
    name: "St. Mary’s Church",
    religion: "Christianity",
    district: "Negombo",
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
    name: "Dutch Reformed Church",
    religion: "Christianity",
    district: "Galle",
  ),

  // Hinduism
  ReligiousSite(
    name: "Nallur Kandaswamy Temple",
    religion: "Hinduism",
    district: "Jaffna",
  ),
  ReligiousSite(
    name: "Koneswaram Temple",
    religion: "Hinduism",
    district: "Trincomalee",
  ),
  ReligiousSite(
    name: "Sita Amman Temple",
    religion: "Hinduism",
    district: "Nuwara Eliya",
  ),
  ReligiousSite(
    name: "Munneswaram Temple",
    religion: "Hinduism",
    district: "Puttalam",
  ),
  ReligiousSite(
    name: "Thiruketheeswaram Temple",
    religion: "Hinduism",
    district: "Mannar",
  ),
  ReligiousSite(
    name: "Naguleswaram Temple",
    religion: "Hinduism",
    district: "Jaffna",
  ),

  // Islam
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
    name: "Kechimalai Mosque",
    religion: "Islam",
    district: "Batticaloa",
  ),
  ReligiousSite(
    name: "Hambantota Grand Mosque",
    religion: "Islam",
    district: "Hambantota",
  ),
  ReligiousSite(
    name: "Kattankudy Mosque",
    religion: "Islam",
    district: "Batticaloa",
  ),
  ReligiousSite(
    name: "Galle Fort Mosque",
    religion: "Islam",
    district: "Galle",
  ),
];

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ReligiousSitesPage());
  }
}

class ReligiousSitesPage extends StatefulWidget {
  const ReligiousSitesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
      appBar: AppBar(title: const Text("Religious Sites in Sri Lanka")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
  ReligiousSite(
    name: "Gangaramaya Temple",
    religion: "Buddhism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "St. Anthony’s Shrine",
    religion: "Christianity",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Sri Kailawasanathan Swami Devasthanam",
    religion: "Hinduism",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Jami Ul-Alfar Mosque",
    religion: "Islam",
    district: "Colombo",
  ),
  ReligiousSite(
    name: "Temple of the Tooth",
    religion: "Buddhism",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "St. Paul’s Church",
    religion: "Christianity",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Kandy Jumma Mosque",
    religion: "Islam",
    district: "Kandy",
  ),
  ReligiousSite(
    name: "Nagadeepa Purana Vihara",
    religion: "Buddhism",
    district: "Jaffna",
  ),
];

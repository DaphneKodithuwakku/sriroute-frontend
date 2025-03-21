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

 
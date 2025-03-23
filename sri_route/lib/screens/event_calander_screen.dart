import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../services/notification_service.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EventCalendarScreen(),
  ));
}

class Event {
  final String title;
  final DateTime date;
  final String location;
  final String description;
  bool isFavorite;  // Added isFavorite property

  Event({
    required this.title, 
    required this.date, 
    required this.location, 
    required this.description,
    this.isFavorite = false,  // Default to not favorite
  });

  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'location': location,
      'description': description,
      'isFavorite': isFavorite,
    };
  }
  // Create from a Firestore document
  factory Event.fromFirestore(Map<String, dynamic> doc) {
    return Event(
      title: doc['title'],
      date: (doc['date'] as Timestamp).toDate(),
      location: doc['location'],
      description: doc['description'],
      isFavorite: doc['isFavorite'] ?? false,
    );
  }
}

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  _EventCalendarScreenState createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sample event data
  final List<Event> events = [
    Event(title: 'Sinhala and Tamil New Year Day', date: DateTime(2025, 4, 13), location: 'Nationwide', description: 'Celebration of the traditional New Year.'),
    Event(title: 'May Day', date: DateTime(2025, 5, 1), location: 'Nationwide', description: 'A global day for workers\' rights.'),
    Event(title: 'Vesak Full Moon Poya Day', date: DateTime(2025, 5, 5), location: 'Nationwide', description: 'A significant Buddhist holiday in Sri Lanka.'),
    Event(title: 'Christmas Day', date: DateTime(2025, 12, 25), location: 'Nationwide', description: 'Celebration of the birth of Jesus Christ.'),
    Event(title: 'Vap Full Moon Poya Day', date: DateTime(2025, 10, 6), location: 'Nationwide', description: 'A Buddhist observance.'),
    Event(title: 'Deepavali Festival Day', date: DateTime(2025, 10, 20), location: 'Nationwide', description: 'Celebration of the Hindu Festival of Lights.'),
    Event(title: 'Ill Full Moon Poya Day', date: DateTime(2025, 11, 5), location: 'Nationwide', description: 'A Buddhist observance.'),
    Event(title: 'Unduvap Full Moon Poya Day', date: DateTime(2025, 12, 4), location: 'Nationwide', description: 'A Buddhist observance.'),
    Event(title: 'Independence Day', date: DateTime(2025, 2, 4), location: 'Nationwide', description: 'Celebration of Sri Lanka\'s independence.'),
    Event(title: 'Medin Full Moon Poya Day', date: DateTime(2025, 2, 13), location: 'Nationwide', description: 'A Buddhist observance.'),
    Event(title: 'Maha Shivaratri Day', date: DateTime(2025, 2, 26), location: 'Nationwide', description: 'A Hindu festival.'),
    Event(title: 'Eid al-Fitr', date: DateTime(2025, 3, 31), location: 'Nationwide', description: 'A Muslim holiday marking the end of Ramadan.'),
    Event(title: 'Bak Full Moon Poya Day', date: DateTime(2025, 4, 12), location: 'Nationwide', description: 'A Buddhist observance.'),
    Event(title: 'Poson Full Moon Poya Day', date: DateTime(2025, 6, 10), location: 'Nationwide', description: 'A Buddhist observance.'),
    Event(title: 'Esala Full Moon Poya Day', date: DateTime(2025, 7, 10), location: 'Nationwide', description: 'A Buddhist observance.'),
    Event(title: 'Nikini Full Moon Poya Day', date: DateTime(2025, 8, 8), location: 'Nationwide', description: 'A Buddhist observance.'),
    Event(title: 'Binara Full Moon Poya Day', date: DateTime(2025, 9, 7), location: 'Nationwide', description: 'A Buddhist observance.'),
    // Additional events
    Event(title: 'Eid al-Adha', date: DateTime(2025, 6, 7), location: 'Nationwide', description: 'Commemorates Ibrahim\'s willingness to sacrifice his son, celebrated with prayers and feasts.'),
    Event(title: 'Mawlid al-Nabi', date: DateTime(2025, 9, 5), location: 'Nationwide', description: 'Celebrates the birth of Prophet Muhammad with prayers and gatherings.'),
    Event(title: 'Start of Ramadan', date: DateTime(2025, 3, 1), location: 'Nationwide', description: 'Marks the beginning of the holy month of fasting for Muslims.'),
    Event(title: 'Laylat al-Qadr', date: DateTime(2025, 3, 27), location: 'Nationwide', description: 'The Night of Power, observed with night prayers.'),
    Event(title: 'Ashura', date: DateTime(2025, 7, 5), location: 'Nationwide', description: 'Marks the martyrdom of Husayn ibn Ali, observed with mourning.'),
    Event(title: 'Good Friday', date: DateTime(2025, 4, 3), location: 'Nationwide', description: 'Commemorates the crucifixion of Jesus Christ.'),
    Event(title: 'Easter Sunday', date: DateTime(2025, 4, 20), location: 'Nationwide, especially Negombo', description: 'Celebrates the resurrection of Jesus Christ, with masses.'),
    Event(title: 'Feast of the Assumption', date: DateTime(2025, 8, 15), location: 'Nationwide, especially Madhu', description: 'Commemorates Mary\'s assumption into heaven.'),
    Event(title: 'Feast of St. Anne', date: DateTime(2025, 7, 26), location: 'Talawila, Kalpitiya', description: 'Honors St. Anne with a grand feast.'),
    Event(title: 'Feast of Our Lady of Madhu', date: DateTime(2025, 8, 2), location: 'Madhu Church, Mannar', description: 'A significant pilgrimage to the Shrine of Our Lady of Madhu.'),
    Event(title: 'Pentecost Sunday', date: DateTime(2025, 6, 8), location: 'Nationwide', description: 'Celebrates the descent of the Holy Spirit.'),
    Event(title: 'All Saints Day', date: DateTime(2025, 11, 1), location: 'Nationwide', description: 'Honors all saints, especially with masses.'),
    Event(title: 'All Souls Day', date: DateTime(2025, 11, 2), location: 'Nationwide', description: 'Prayers for the souls of the departed.'),
    Event(title: 'St. Anthony\'s Feast', date: DateTime(2025, 6, 13), location: 'Nationwide, especially Kochchikade', description: 'Honors St. Anthony with a grand feast.'),
    Event(title: 'St. Sebastian\'s Feast', date: DateTime(2025, 1, 20), location: 'Nationwide, especially Negombo', description: 'Honors St. Sebastian with a grand feast.'),
    Event(title: 'St. Joseph Vaz Feast', date: DateTime(2025, 1, 16), location: 'Nationwide, especially Kandy', description: 'Honors St. Joseph Vaz with a grand feast.'),
    Event(title: 'St. Anne\'s Feast', date: DateTime(2025, 7, 26), location: 'Talawila, Kalpitiya', description: 'Honors St. Anne with a grand feast.'),
    Event(title: 'St. Peter\'s Feast', date: DateTime(2025, 6, 29), location: 'Nationwide, especially Colombo', description: 'Honors St. Peter with a grand feast.'),
    Event(title: 'St. Thomas\' Feast', date: DateTime(2025, 7, 3), location: 'Nationwide, especially Matara', description: 'Honors St. Thomas with a grand feast.'),
    Event(title: 'St. Jude\'s Feast', date: DateTime(2025, 10, 28), location: 'Nationwide, especially Negombo', description: 'Honors St. Jude with a grand feast.'),
    Event(title: 'Duruthu Full Moon Poya Day', date: DateTime(2025, 1, 14), location: 'Nationwide', description: 'Commemorates Buddha\'s first visit to Sri Lanka.'),
    Event(title: 'Navam Full Moon Poya Day', date: DateTime(2025, 2, 12), location: 'Colombo', description: 'Marks the first Buddhist council.'),
    Event(title: 'Adhi Esala Full Moon Poya Day', date: DateTime(2025, 6, 11), location: 'Nationwide', description: 'Precedes the Esala Perahera.'),
    Event(title: 'Kandy Esala Perahera', date: DateTime(2025, 7, 10), location: 'Kandy', description: 'Honors the Sacred Tooth Relic with a grand procession.'),
    Event(title: 'Adhi Poson Full Moon Poya Day', date: DateTime(2025, 5, 11), location: 'Nationwide', description: 'Tied to the introduction of Buddhism.'),
    Event(title: 'Thai Pongal', date: DateTime(2025, 1, 14), location: 'Nationwide, especially Tamil areas', description: 'A harvest festival thanking the Sun God.'),
    Event(title: 'Krishna Janmashtami', date: DateTime(2025, 8, 16), location: 'Nationwide, especially Jaffna', description: 'Celebrates the birth of Lord Krishna.'),
    Event(title: 'Nallur Festival', date: DateTime(2025, 8, 25), location: 'Nallur, Jaffna', description: 'A 25-day festival honoring Lord Murugan.'),
    Event(title: 'Vel Festival', date: DateTime(2025, 7, 15), location: 'Colombo', description: 'Commemorates Lord Skanda\'s victory with a chariot procession.'),
    Event(title: 'Durga Puja', date: DateTime(2025, 10, 2), location: 'Nationwide, especially Tamil areas', description: 'Celebrates Goddess Durga\'s victory.'),
    Event(title: 'Holi', date: DateTime(2025, 3, 17), location: 'Nationwide, especially Tamil areas', description: 'The Hindu Festival of Colors.')
  ];

  @override
  void initState() {
    super.initState();
    _selectedMonth = _focusedDay;
    _loadFavorites();
  }

  // Load user's favorite events from Firestore
  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final favoritesSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('favoriteEvents')
            .get();
        
        // Map of event titles to favorite status
        final Map<String, bool> favoriteMap = {};
        for (var doc in favoritesSnapshot.docs) {
          favoriteMap[doc.id] = true;
        }
        
        // Update the favorite status of events
        for (var event in events) {
          if (favoriteMap.containsKey(event.title)) {
            event.isFavorite = true;
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
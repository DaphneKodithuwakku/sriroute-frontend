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
  bool isFavorite;  
  //propherties for the Event calender


// Constructor with required fields and an optional `isFavorite` field
  Event({
    required this.title, 
    required this.date, 
    required this.location, 
    required this.description,
    this.isFavorite = false,  
  });

   // Convert Event object to a Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'location': location,
      'description': description,
      'isFavorite': isFavorite,
    };
  }

  
  // Factory constructor to create an Event object from Firestore data
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


// Stateful widget to display the event calendar screen
class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  _EventCalendarScreenState createState() => _EventCalendarScreenState();
}

// State class for EventCalendarScreen.
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
    

    // Get the currently logged-in user
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final favoritesSnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('favoriteEvents')
            .get();
        
        // Create a map to store event titles marked as favorite
        final Map<String, bool> favoriteMap = {};
        for (var doc in favoritesSnapshot.docs) {
          favoriteMap[doc.id] = true;
        }
        
              // Iterate through events and update the favorite status based on Firestore data
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

  // Toggle favorite status and update Firestore
  Future<void> _toggleFavorite(Event event) async {
    final user = _auth.currentUser;
    if (user == null) {
      // Show a message if the user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to save favorites'))
      );
      return;
    }
// Reference to the specific event in the user's favorites collection
    final eventRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favoriteEvents')
        .doc(event.title);


// Toggle favorite status locally for immediate UI update
    setState(() {
      event.isFavorite = !event.isFavorite;
    });

    try {
      if (event.isFavorite) {
         // Add event to favorites in Firestore
        await eventRef.set(event.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added "${event.title}" to favorites'))
        );
      } else {
         // Remove event from favorites in Firestore
        await eventRef.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed "${event.title}" from favorites'))
        );
      }
    } catch (e) {
       // Revert UI change if the operation fails
      setState(() {
        event.isFavorite = !event.isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorites: $e'))
      );
    }
  }

  // Get events for the selected month
  List<Event> _getEventsForSelectedMonth() {
    return events.where((event) => 
      event.date.year == _selectedMonth.year && 
      event.date.month == _selectedMonth.month
    ).toList()
      ..sort((a, b) => a.date.day.compareTo(b.date.day)); // Sort by day
  }

  // Get upcoming events based on the current date
  List<Event> _getUpcomingEvents() {
    final now = DateTime.now();
    return events
        .where((event) => event.date.isAfter(now))
        .toList()
        ..sort((a, b) => a.date.compareTo(b.date)); // Sort by date
  }

  // Format the month and year for display
  String _formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  // Change to previous month
  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  // Change to next month
  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Event Calendar", 
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Month selector with previous and next buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left),
                          onPressed: _previousMonth, // Navigate to previous month
                        ),
                        Text(
                          _formatMonthYear(_selectedMonth), // Display the selected month
                          style: TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold,
                            color: Colors.blue
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Events for the selected month
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Events in ${DateFormat('MMMM').format(_selectedMonth)}",
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10),

                      // Show message if there are no events for the selected month
                        if (_getEventsForSelectedMonth().isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                "No events for this month",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),

                         // Display the list of events for the selected month
                        for (var event in _getEventsForSelectedMonth())
                          _buildEventCard(event),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                 // Upcoming events section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upcoming Events",
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Display up to 5 upcoming events
                        for (var event in _getUpcomingEvents().take(5))
                          _buildEventCard(event),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }


// Widget to build an event card
  Widget _buildEventCard(Event event) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd').format(event.date),// Display event day
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Text(
              DateFormat('MMM').format(event.date),// Display event month
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        title: Text(
          event.title, // Event title
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(event.location),// Event location
        trailing: IconButton(
          icon: Icon(
            event.isFavorite ? Icons.favorite : Icons.favorite_border, // Favorite toggle icon
            color: event.isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: () => _toggleFavorite(event),// Toggle favorite status
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event, onFavoriteToggled: _toggleFavorite),
            ),
          );
        },
      ),
    );
  }
}

// Event details screen
class EventDetailScreen extends StatelessWidget {
  final Event event;
  final Function(Event) onFavoriteToggled;

  const EventDetailScreen({
    required this.event, 
    required this.onFavoriteToggled,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        actions: [
          // set Notification button to set reminder
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () => _setReminder(context),
            tooltip: 'Set reminder',
          ),
          // Favorite toggle button
          IconButton(
            icon: Icon(
              event.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: event.isFavorite ? Colors.red : null,
            ),
            onPressed: () => onFavoriteToggled(event),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event details card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event date
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy').format(event.date),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Event location
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.red),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.location,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(),
                    SizedBox(height: 8),
                    // Event description
                    Text(
                      'About this event:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      event.description,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    // Button to set reminder
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _setReminder(context),
                      icon: Icon(Icons.notifications_active),
                      label: Text('Set Reminder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
           // Card widget to display additional information about the event
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What to know:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('This is a national holiday in Sri Lanka'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: Icon(Icons.access_time),
                      title: Text('Events typically start in the morning'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      leading: Icon(Icons.people),
                      title: Text('Expected to be crowded at popular venues'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


// Function to set an event reminder
  Future<void> _setReminder(BuildContext context) async {
    try {
      // Get the current date and time
      final now = DateTime.now();
      final dayBeforeEvent = event.date.subtract(const Duration(hours: 24));
      
      if (dayBeforeEvent.isBefore(now)) {
        // Event is less than 24 hours away or already past
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot set reminder - event is less than 24 hours away'),
            backgroundColor: Colors.orange,
          ),
        );
        return;// Exit the function early

      }
      
        // Generate a unique identifier for the event using its title
      final eventId = event.title;
      
      // Schedule a notification for the event 24 hours before it starts
      await NotificationService.addEventReminder(
        eventId, 
        event.title, 
        event.date
      );
      
     // Show a confirmation message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reminder set - you will be notified the day before the event'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
       // Handle any errors that occur while setting the reminder
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set reminder: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
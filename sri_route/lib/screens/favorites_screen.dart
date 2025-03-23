import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'event_calander_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = true;
  List<Event> _favoriteEvents = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favoriteEvents')
          .get();

      final favorites = snapshot.docs.map((doc) {
        final data = doc.data();
        return Event(
          title: data['title'] ?? '',
          date: (data['date'] as Timestamp).toDate(),
          location: data['location'] ?? '',
          description: data['description'] ?? '',
          isFavorite: true,
        );
      }).toList();

      // Sort by date
      favorites.sort((a, b) => a.date.compareTo(b.date));

      setState(() {
        _favoriteEvents = favorites;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _toggleFavorite(Event event) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    final eventRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favoriteEvents')
        .doc(event.title);

    setState(() {
      event.isFavorite = !event.isFavorite;
    });

    try {
      if (event.isFavorite) {
        await eventRef.set(event.toMap());
      } else {
        await eventRef.delete();
        // Remove from local list
        setState(() {
          _favoriteEvents.removeWhere((e) => e.title == event.title);
        });
      }
    } catch (e) {
      // Revert UI if operation failed
      setState(() {
        event.isFavorite = !event.isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating favorite: $e'))
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _favoriteEvents.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add events to your favorites from the Event Calendar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _favoriteEvents.length,
                  itemBuilder: (context, index) {
                    final event = _favoriteEvents[index];
                    return _buildEventCard(event);
                  },
                ),
    );
  }
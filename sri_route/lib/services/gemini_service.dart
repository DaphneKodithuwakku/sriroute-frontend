import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pilgrimage_models.dart';

class GeminiService {
  // Singleton pattern
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  // Replace with your actual API key from Google AI Studio
  // Get your API key from: https://aistudio.google.com/app/apikey
  static const String apiKey = 'AIzaSyA1JtAqzYbKowykveCHis1WALBU_tsMUg4';
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  /// Get pilgrimage recommendations based on user preferences
  Future<List<PilgrimageRecommendation>> getPilgrimageRecommendations({
    required String religion,
    required String dateRange,
    required String region,
    required String locationName, // Add this parameter
    required double userLatitude, // Add this parameter
    required double userLongitude,
  }) async {
    try {
      // Check if API key is the placeholder value
      if (apiKey == 'YOUR_GEMINI_API_KEY') {
        debugPrint(
            'Error: Please replace the placeholder API key with your actual Gemini API key');
        return _getSampleRecommendations(
            religion, region, locationName, userLatitude, userLongitude);
      }

      // Construct a more detailed prompt for better results
      final prompt =
          """Recommend 3 pilgrimage sites in $region for $religion followers. 
The visit is planned for $dateRange. The visitor will be starting from coordinates: $userLatitude, $userLongitude (near $locationName).
For each site, provide:
1. Name
2. Description (100-150 words)
3. Historical significance
4. Best time to visit
5. Estimated visit duration
6. Location coordinates (latitude and longitude)
7. A URL for an image of the site

Format the response strictly as a JSON array with objects containing these fields: 
name, description, historicalSignificance, bestTimeToVisit, estimatedDuration, latitude, longitude, imageUrl
Do not include any explanatory text before or after the JSON array.
""";
      // Make the API request
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        // Parse the response
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Verifying the expected structure exists before accessing nested keys
        if (data['candidates'] is List &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content']?['parts'] is List &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final String generatedText =
              data['candidates'][0]['content']['parts'][0]['text'] as String;

          // Extract the JSON part from the response using a regular expression
          final jsonRegExp = RegExp(r'\[\s*\{.\}\s\]', dotAll: true);
          final match = jsonRegExp.firstMatch(generatedText);

          if (match != null) {
            final String? jsonStr = match.group(0);
            if (jsonStr != null) {
              final List<dynamic> recommendationsJson = jsonDecode(jsonStr);
              return recommendationsJson
                  .map<PilgrimageRecommendation>(
                      (json) => PilgrimageRecommendation.fromJson(json))
                  .toList();
            }
          }
        }
        debugPrint(
            'Failed to extract JSON from Gemini response. Using sample data.');
        return _getSampleRecommendations(
            religion, region, locationName, userLatitude, userLongitude);
      } else {
        debugPrint('API request failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        // Returning sample data as fallback
        return _getSampleRecommendations(
            religion, region, locationName, userLatitude, userLongitude);
      }
    } catch (e) {
      debugPrint('Error getting recommendations: $e');
      // Returning sample data as fallback
      return _getSampleRecommendations(
          religion, region, locationName, userLatitude, userLongitude);
    }
  }

  // Sample data for testing
  List<PilgrimageRecommendation> _getSampleRecommendations(String religion,
      String region, String locationName, double userLat, double userLng) {
    if (religion == 'Buddhism') {
      return [
        PilgrimageRecommendation(
          name: 'Sri Dalada Maligawa (Temple of the Sacred Tooth Relic)',
          description:
              'The Temple of the Sacred Tooth Relic is a Buddhist temple located in the royal palace complex of the former Kingdom of Kandy, which houses the relic of the tooth of the Buddha.',
          historicalSignificance:
              'Built during the 17th century, it has housed the sacred tooth relic of the Buddha since then, making it one of the most sacred Buddhist sites in Sri Lanka.',
          bestTimeToVisit: 'Early morning or during puja ceremonies',
          estimatedDuration: '2-3 hours',
          latitude: 7.2936,
          longitude: 80.6413,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Temple_of_the_Tooth_Kandy.jpg/1200px-Temple_of_the_Tooth_Kandy.jpg',
        ),
        PilgrimageRecommendation(
          name: 'Gangaramaya Temple',
          description:
              'Gangaramaya Temple is one of the most important temples in Colombo, known for its eclectic architecture and mix of Sri Lankan, Thai, Indian, and Chinese styles.',
          historicalSignificance:
              'Founded in the late 19th century, it has become a center for Buddhist learning and cultural significance in Colombo.',
          bestTimeToVisit: 'Morning hours or during Buddhist festivals',
          estimatedDuration: '1-2 hours',
          latitude: 6.9167,
          longitude: 79.8583,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/7/7d/Gangaramaya_Temple.jpg',
        ),
        PilgrimageRecommendation(
          name: 'Kelaniya Raja Maha Vihara',
          description:
              'A Buddhist temple located about 10 km from Colombo. The temple is believed to be particularly sacred as it was visited by the Buddha during his third visit to Sri Lanka.',
          historicalSignificance:
              'The original temple was believed to be built before 500 BCE, with the Buddha himself consecrating it during his visit.',
          bestTimeToVisit:
              'Early morning or during Duruthu Perahera in January',
          estimatedDuration: '1-2 hours',
          latitude: 6.9553,
          longitude: 79.9214,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Kelaniya_Temple.jpg/800px-Kelaniya_Temple.jpg',
        ),
      ];
    } else if (religion == 'Hinduism') {
      return [
        PilgrimageRecommendation(
          name: 'Sri Ponnambalam Vanesar Kovil',
          description:
              'A Hindu temple dedicated to Lord Shiva, known for its intricate stone carvings and traditional Dravidian architecture.',
          historicalSignificance:
              'Built in the late 19th century by a prominent Tamil merchant, it represents one of the finest examples of South Indian temple architecture in Sri Lanka.',
          bestTimeToVisit: 'Morning or evening puja times',
          estimatedDuration: '1 hour',
          latitude: 6.9321,
          longitude: 79.8578,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Old_Kathiresan_Temple%2C_Colombo.jpg/800px-Old_Kathiresan_Temple%2C_Colombo.jpg',
        ),
        PilgrimageRecommendation(
          name: 'Shri Ponnambalawaneswaram Kovil',
          description:
              'One of the oldest Hindu temples in Colombo, dedicated to Lord Shiva, featuring traditional South Indian temple architecture.',
          historicalSignificance:
              'Established in the 19th century, it has been a center for Hindu worship and cultural activities for the Tamil community.',
          bestTimeToVisit: 'During morning rituals or festival days',
          estimatedDuration: '1-2 hours',
          latitude: 6.9269,
          longitude: 79.8584,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Sri_Ponnambalawaneswaram_Hindu_temple_Colombo.jpg/800px-Sri_Ponnambalawaneswaram_Hindu_temple_Colombo.jpg',
        ),
        PilgrimageRecommendation(
          name: 'Sammangodu Sri Kathirvelayutha Swami Kovil',
          description:
              'A prominent Hindu temple dedicated to Lord Murugan (Kathirvelayuthan), known for its colorful gopuram (entrance tower) and annual festival.',
          historicalSignificance:
              'One of the most important Murugan temples in Colombo, playing a significant role in the religious life of the Hindu community.',
          bestTimeToVisit: 'During Thai Pusam festival (January-February)',
          estimatedDuration: '1 hour',
          latitude: 6.9342,
          longitude: 79.8602,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/New_Kathiresan_Temple.jpg/800px-New_Kathiresan_Temple.jpg',
        ),
      ];
    } else if (religion == 'Christianity') {
      return [
        PilgrimageRecommendation(
          name: 'St. Lucia\'s Cathedral',
          description:
              'The seat of the Archbishop of Colombo, this Roman Catholic cathedral is known for its Neo-Gothic architecture and beautiful stained glass windows.',
          historicalSignificance:
              'Built in the late 19th century, it has been the center of Catholic worship in Colombo for over a century.',
          bestTimeToVisit: 'Sunday morning Mass or weekday afternoons',
          estimatedDuration: '1 hour',
          latitude: 6.9269,
          longitude: 79.8584,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/St._Lucia%27s_Cathedral%2C_Kotahena%2C_Sri_Lanka.jpg/800px-St._Lucia%27s_Cathedral%2C_Kotahena%2C_Sri_Lanka.jpg',
        ),
        PilgrimageRecommendation(
          name: 'St. Anthony\'s Shrine',
          description:
              'A Roman Catholic church dedicated to St. Anthony of Padua, known for its Portuguese-influenced architecture and as a place of miracles.',
          historicalSignificance:
              'Founded in the early 19th century, it has become one of the most visited churches in Colombo, known for granting wishes.',
          bestTimeToVisit:
              'Tuesday mornings or during the annual feast in June',
          estimatedDuration: '1 hour',
          latitude: 6.9342,
          longitude: 79.8602,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/St._Anthony%27s_Shrine%2C_Kochchikade.jpg/800px-St._Anthony%27s_Shrine%2C_Kochchikade.jpg',
        ),
        PilgrimageRecommendation(
          name: 'Wolvendaal Church',
          description:
              'One of the oldest Protestant churches in Sri Lanka, built in Dutch colonial style with thick walls and large windows.',
          historicalSignificance:
              'Built in 1749 during the Dutch colonial period, it\'s one of the most important Dutch colonial buildings in Sri Lanka.',
          bestTimeToVisit: 'Weekday mornings',
          estimatedDuration: '45 minutes',
          latitude: 6.9375,
          longitude: 79.8619,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Wolvendaal_Church.jpg/800px-Wolvendaal_Church.jpg',
        ),
      ];
    } else if (religion == 'Islam') {
      return [
        PilgrimageRecommendation(
          name: 'Jami Ul-Alfar Mosque (Red Mosque)',
          description:
              'One of the oldest mosques in Colombo, known for its striking red and white striped pattern and unique architectural style.',
          historicalSignificance:
              'Built in 1909, it has been a landmark in Colombo and an important center for Islamic worship and education.',
          bestTimeToVisit: 'Outside of prayer times, with permission',
          estimatedDuration: '30-45 minutes',
          latitude: 6.9375,
          longitude: 79.8583,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Jami-Ul-Alfar_Mosque_%28Red_Masjid%29.jpg/800px-Jami-Ul-Alfar_Mosque_%28Red_Masjid%29.jpg',
        ),
        PilgrimageRecommendation(
          name: 'Dewatagaha Mosque',
          description:
              'A significant mosque in Colombo known for its beautiful architecture and spiritual importance to local Muslims.',
          historicalSignificance:
              'Built at the site of a Sufi saint\'s shrine, it has become an important place for spiritual healing and prayers.',
          bestTimeToVisit: 'Non-prayer times, with permission',
          estimatedDuration: '30 minutes',
          latitude: 6.9103,
          longitude: 79.8567,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Dawatagaha_Jumma_Masjid_%26_Shrine_of_Saint.jpg/800px-Dawatagaha_Jumma_Masjid_%26_Shrine_of_Saint.jpg',
        ),
        PilgrimageRecommendation(
          name: 'Grand Mosque (Colombo Grand Mosque)',
          description:
              'The headquarters of the All Ceylon Jamiyyathul Ulama, this mosque serves as a center for Islamic religious activities in Sri Lanka.',
          historicalSignificance:
              'Established in the mid-20th century, it has played a crucial role in Islamic education and community leadership.',
          bestTimeToVisit: 'Weekday mornings, outside prayer times',
          estimatedDuration: '30 minutes',
          latitude: 6.9314,
          longitude: 79.8578,
          imageUrl:
              'https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/Grand_Mosque_Colombo.jpg/800px-Grand_Mosque_Colombo.jpg',
        ),
      ];
    } else {
      // Fallback default
      return [
        PilgrimageRecommendation(
          name: 'Sample Religious Site',
          description:
              'This is a sample description for a religious site when the selected religion does not match any predefined categories.',
          historicalSignificance: 'Sample historical significance information.',
          bestTimeToVisit: 'Anytime',
          estimatedDuration: '1-2 hours',
          latitude: 6.9271,
          longitude: 79.8612,
          imageUrl: 'https://via.placeholder.com/600x400',
        ),
      ];
    }
  }
}

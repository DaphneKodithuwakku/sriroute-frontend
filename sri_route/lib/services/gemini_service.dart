class GeminiService {
  // Singleton pattern
  static final GeminiService _instance = GeminiService._internal();
  factory GeminiService() => _instance;
  GeminiService._internal();

  // Replace with your actual API key from Google AI Studio
  // Get your API key from: https://aistudio.google.com/app/apikey
  static const String apiKey = 'AIzaSyA1JtAqzYbKowykveCHis1WALBU_tsMUg4';
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  /// Get pilgrimage recommendations based on user preferences
  Future<List<PilgrimageRecommendation>> getPilgrimageRecommendations({
    required String religion,
    required String dateRange,
    required String region,
    required String locationName,  // Add this parameter
    required double userLatitude,  // Add this parameter
    required double userLongitude, 
  }) async {
    try {
      // Check if API key is the placeholder value
      if (apiKey == 'YOUR_GEMINI_API_KEY') {
        debugPrint('Error: Please replace the placeholder API key with your actual Gemini API key');
        return _getSampleRecommendations(religion, region, locationName, userLatitude, userLongitude);
      }
      
      // Construct a more detailed prompt for better results
      final prompt = """Recommend 3 pilgrimage sites in $region for $religion followers. 
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

        // Verify the expected structure exists before accessing nested keys
        if (data['candidates'] is List &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content']?['parts'] is List &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          final String generatedText = data['candidates'][0]['content']['parts'][0]['text'] as String;

          // Extract the JSON part from the response using a regular expression
          final jsonRegExp = RegExp(r'\[\s*\{.\}\s\]', dotAll: true);
          final match = jsonRegExp.firstMatch(generatedText);

          if (match != null) {
            final String? jsonStr = match.group(0);
            if (jsonStr != null) {
              final List<dynamic> recommendationsJson = jsonDecode(jsonStr);
              return recommendationsJson
                  .map<PilgrimageRecommendation>((json) => PilgrimageRecommendation.fromJson(json))
                  .toList();
            }
          }
        }
        debugPrint('Failed to extract JSON from Gemini response. Using sample data.');
        return _getSampleRecommendations(religion, region, locationName, userLatitude, userLongitude);
      } else {
        debugPrint('API request failed with status: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        // Return sample data as fallback
        return _getSampleRecommendations(religion, region, locationName, userLatitude, userLongitude);
      }
    } catch (e) {
      debugPrint('Error getting recommendations: $e');
      // Return sample data as fallback
      return _getSampleRecommendations(religion, region, locationName, userLatitude, userLongitude);
    }
  }
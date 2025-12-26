import 'dart:convert';
import 'package:movies/app/config/app_security.dart';
import 'package:http/http.dart' as http;

import '../model/movie_model.dart';

class ApiServices {
  static const Duration _timeout = Duration(seconds: 12);
  static const Map<String, String> headers = {"Content-Type": "application/json"};

  Future<List<Search>> searchMovies(String query) async {
    final uri = Uri.parse('${AppSecurity.baseUrl}s=$query${AppSecurity.apiKey}');

    final response = await http.get(uri, headers: headers).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch movies');
    }

    final Map<String, dynamic> jsonData = json.decode(response.body);

    if (jsonData['Response'] == 'False' || jsonData['Search'] == null) {
      return [];
    }

    return (jsonData['Search'] as List).map((e) => Search.fromJson(e)).toList();
  }

  Future<Map<String, dynamic>> fetchMovieDetails(String imdbId) async {
    final uri = Uri.parse('${AppSecurity.baseUrl}i=$imdbId${AppSecurity.apiKey}');

    final response = await http.get(uri, headers: headers).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception('Failed to load movie details');
    }

    return json.decode(response.body) as Map<String, dynamic>;
  }
}

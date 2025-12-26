import 'package:flutter/material.dart';
import 'package:movies/app/services/api_services.dart';
import 'package:state_extended/state_extended.dart';

import '../../../model/movie_model.dart';
import '../../../services/db_helper.dart';

class HomeController extends StateXController {
  final ApiServices _apiService = ApiServices();
  final DbHelper _dbHelper = DbHelper();

  List<Search> movies = [];
  bool loading = false;

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) return;

    loading = true;
    notifyClients();

    try {
      final List<Search> result = await _apiService.searchMovies(query);

      movies = result;
      await _dbHelper.saveSearch(movies);
    } catch (e) {
      debugPrint('Movie search error: $e');
      movies = [];
    } finally {
      loading = false;
      notifyClients();
    }
  }

  Future<void> loadCache() async {
    movies = await _dbHelper.getCachedSearch();
    notifyClients();
  }
}

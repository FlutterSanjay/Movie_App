import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies/app/services/api_services.dart';
import 'package:state_extended/state_extended.dart';

import '../../../services/db_helper.dart';

class MovieDetailController extends StateXController {
  final DbHelper _dbHelper = DbHelper();
  final ApiServices _apiService = ApiServices();

  Map<String, dynamic>? movieData;
  bool loading = true;

  Future<void> fetchMovieDetails(String imdbId) async {
    loading = true;
    notifyClients();

    try {
      final cachedJson = await _dbHelper.getCachedMovieDetails(imdbId);

      if (cachedJson != null) {
        movieData = Map<String, dynamic>.from(jsonDecode(cachedJson));
      } else {
        final result = await _apiService.fetchMovieDetails(imdbId);

        movieData = result;

        await _dbHelper.saveMovieDetails(imdbId, jsonEncode(result));
      }
    } catch (e) {
      debugPrint('Detail error: $e');
    } finally {
      loading = false;
      notifyClients();
    }
  }
}

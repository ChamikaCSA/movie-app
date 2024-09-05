import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/actor.dart';
import '../models/movie.dart';

class MovieService {
  final String apiKey = dotenv.env['API_KEY']!;
  final String baseUrl = dotenv.env['BASE_URL']!;
  final cacheManager = DefaultCacheManager();

  Future<List<int>> fetchTopRatedMovies(int page) async {
    return _fetchMovies('/movie/top_rated', page: page);
  }

  Future<List<int>> fetchPopularMovies(int page) async {
    return _fetchMovies('/movie/popular', page: page);
  }

  Future<List<int>> searchMovies(String query) async {
    return _fetchMovies('/search/movie', query: query);
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    final url =
        '$baseUrl/movie/$movieId?api_key=$apiKey&append_to_response=credits';
    final data = await _fetchData(url);

    final cast = (data['credits']['cast'] as List<dynamic>)
        .map<Actor>((actor) => Actor.fromJson(actor))
        .toList();

    return Movie.fromJson(data, cast);
  }

  Future<List<int>> _fetchMovies(String endpoint,
      {int page = 1, String? query}) async {
    final url = query != null
        ? '$baseUrl$endpoint?query=$query&api_key=$apiKey'
        : '$baseUrl$endpoint?page=$page&api_key=$apiKey';
    final data = await _fetchData(url);
    return (data['results'] as List<dynamic>)
        .map<int>((movie) => movie['id'] as int)
        .toList();
  }

  Future<Map<String, dynamic>> _fetchData(String url) async {
    var file = await cacheManager.getSingleFile(url);

    if (file.existsSync()) {
      final content = await file.readAsString();
      return json.decode(content);
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch data from $url');
    }
  }
}

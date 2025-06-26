import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String _apiKey = '31b4d43809c564308f250b88e1f850d8';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchPopularMovies() async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-BR&page=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['results'] as List).map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar filmes populares: ${response.statusCode}');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&language=pt-BR&query=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return (body['results'] as List).map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar filmes: ${response.statusCode}');
    }
  }

  Future<Movie> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&language=pt-BR');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      print('Erro na API ao carregar detalhes do filme $movieId: ${response.statusCode} - ${response.body}');
      throw Exception('Erro ao carregar detalhes do filme $movieId: ${response.statusCode}');
    }
  }
}
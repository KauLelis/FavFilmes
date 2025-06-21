import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class ApiService {
  static const String _apiKey = 'SUA_API_KEY_AQUI'; // ← Substitua aqui
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> getPopularMovies() async {
    final url = Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=pt-BR');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List results = jsonDecode(response.body)['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar filmes');
    }
  }
}

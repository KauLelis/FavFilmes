import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../widgets/movie_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiService = ApiService();
  final favoriteService = FavoriteService();
  late Future<List<Movie>> popularMovies;
  List<Movie> favoriteMovies = [];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    popularMovies = apiService.getPopularMovies();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final all = await apiService.getPopularMovies();
    final favIds = await favoriteService.getFavoriteIds();
    setState(() {
      favoriteMovies = all.where((m) => favIds.contains(m.id)).toList();
    });
  }

  void _toggleFavorite(Movie movie) async {
    await favoriteService.toggleFavorite(movie.id);
    _loadFavorites();
    setState(() {});
  }

  Widget _buildMovieList(List<Movie> movies) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return FutureBuilder<bool>(
          future: favoriteService.isFavorite(movie.id),
          builder: (context, snapshot) {
            final isFav = snapshot.data ?? false;
            return MovieTile(
              movie: movie,
              isFavorite: isFav,
              onFavoriteToggle: () => _toggleFavorite(movie),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentIndex == 0 ? 'Filmes Populares' : 'Favoritos'),
      ),
      body: currentIndex == 0
          ? FutureBuilder<List<Movie>>(
              future: popularMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else {
                  return _buildMovieList(snapshot.data!);
                }
              },
            )
          : _buildMovieList(favoriteMovies),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Populares'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
      ),
    );
  }
}

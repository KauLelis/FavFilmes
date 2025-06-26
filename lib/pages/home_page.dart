import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../services/watch_later_service.dart';
import '../widgets/movie_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  final FavoriteService favoriteService = FavoriteService();
  final WatchLaterService watchLaterService = WatchLaterService();

  int currentIndex = 0;
  late Future<List<Movie>> currentDisplayedMoviesFuture;

  List<Movie> favoriteMovies = [];
  List<Movie> watchLaterMovies = [];

  String currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    currentDisplayedMoviesFuture = apiService.fetchPopularMovies();
    loadFavorites();
    loadWatchLater();
  }

  Future<void> loadFavorites() async {
    final favoriteIds = await favoriteService.getFavoriteIds();
    List<Movie> fetchedFavorites = [];
    for (int id in favoriteIds) {
      try {
        final movie = await apiService.fetchMovieDetails(id);
        fetchedFavorites.add(movie);
      } catch (e) {
        print('Erro ao carregar filme favorito $id: $e');
      }
    }
    if (mounted) {
      setState(() {
        favoriteMovies = fetchedFavorites;
      });
    }
  }

  Future<void> loadWatchLater() async {
    final watchLaterIds = await watchLaterService.getWatchLaterIds();
    List<Movie> fetchedWatchLater = [];
    for (int id in watchLaterIds) {
      try {
        final movie = await apiService.fetchMovieDetails(id);
        fetchedWatchLater.add(movie);
      } catch (e) {
        print('Erro ao carregar filme para assistir depois $id: $e');
      }
    }
    if (mounted) {
      setState(() {
        watchLaterMovies = fetchedWatchLater;
      });
    }
  }

  void toggleFavoriteAndUpdateLists(int movieId) async {
    await favoriteService.toggleFavorite(movieId);
    await loadFavorites();
    if (mounted) {
      setState(() {});
    }
  }

  Widget buildMovieList(Future<List<Movie>> moviesFuture) {
    return FutureBuilder<List<Movie>>(
      future: moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final movies = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return FutureBuilder<bool>(
                future: favoriteService.isFavorite(movie.id),
                builder: (context, favSnapshot) {
                  final isFavorite = favSnapshot.data ?? false;
                  return MovieTile(
                    movie: movie,
                    isFavorite: isFavorite,
                    onFavoriteToggle: () => toggleFavoriteAndUpdateLists(movie.id),
                  );
                },
              );
            },
          );
        } else {
          return Center(
            child: Text(currentSearchQuery.isEmpty
                ? 'Nenhum filme popular encontrado.'
                : 'Nenhum filme encontrado para "${currentSearchQuery}".'),
          );
        }
      },
    );
  }

  Widget buildListFromMovies(List<Movie> movies) {
    if (movies.isEmpty) {
      return Center(
        child: Text(currentIndex == 1
            ? 'Nenhum filme favorito encontrado.'
            : 'Nenhum filme para assistir depois encontrado.'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return FutureBuilder<bool>(
          future: favoriteService.isFavorite(movie.id),
          builder: (context, snapshot) {
            final isFavorite = snapshot.data ?? false;
            return MovieTile(
              movie: movie,
              isFavorite: isFavorite,
              onFavoriteToggle: () => toggleFavoriteAndUpdateLists(movie.id),
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
        title: currentIndex == 0
            ? TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar filmes...',
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 18),
                cursorColor: Colors.black,
                onSubmitted: (query) {
                  setState(() {
                    currentSearchQuery = query;
                    currentDisplayedMoviesFuture = apiService.searchMovies(query);
                  });
                },
              )
            : currentIndex == 1
                ? const Text('Favoritos')
                : const Text('Assistir depois'),
      ),
      body: currentIndex == 0
          ? buildMovieList(currentDisplayedMoviesFuture)
          : currentIndex == 1
              ? buildListFromMovies(favoriteMovies)
              : buildListFromMovies(watchLaterMovies),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            if (index == 0) {
              currentDisplayedMoviesFuture = apiService.fetchPopularMovies();
              currentSearchQuery = '';
            } else if (index == 1) {
              loadFavorites();
            } else if (index == 2) {
              loadWatchLater();
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Populares',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            label: 'Assistir depois',
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../pages/movie_detail_page.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const MovieTile({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(movie: movie),
          ),
        );
      },
      leading: movie.posterPath.isNotEmpty
          ? Image.network('https://image.tmdb.org/t/p/w92${movie.posterPath}')
          : const Icon(Icons.movie),
      title: Text(movie.title),
      subtitle: Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: onFavoriteToggle,
      ),
    );
  }
}

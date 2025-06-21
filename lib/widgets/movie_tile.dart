import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;

  const MovieTile({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: movie.posterPath.isNotEmpty
          ? Image.network('https://image.tmdb.org/t/p/w92${movie.posterPath}')
          : const Icon(Icons.movie),
      title: Text(movie.title),
      subtitle: Text(movie.overview, maxLines: 2, overflow: TextOverflow.ellipsis),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/watch_later_service.dart';
import '../pages/movie_detail_page.dart';

class MovieTile extends StatefulWidget {
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
  State<MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  final watchLaterService = WatchLaterService();
  bool isInWatchLater = false;

  @override
  void initState() {
    super.initState();
    checkWatchLater();
  }

  void checkWatchLater() async {
    final result = await watchLaterService.isInWatchLater(widget.movie.id);
    if (mounted) {
      setState(() {
        isInWatchLater = result;
      });
    }
  }

  void toggleWatchLater() async {
    await watchLaterService.toggleWatchLater(widget.movie.id);
    checkWatchLater();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MovieDetailPage(movie: widget.movie),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.movie.posterPath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w185${widget.movie.posterPath}',
                    fit: BoxFit.cover,
                    height: 120,
                    width: 80,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          height: 120,
                          width: 80,
                          color: Colors.grey[300],
                          child: const Center(child: Icon(Icons.movie, size: 40, color: Colors.grey)),
                        ),
                  ),
                )
              else
                Container(
                  height: 120,
                  width: 80,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.movie, size: 40, color: Colors.grey)),
                ),
              
              const SizedBox(width: 12.0),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.movie.overview.isNotEmpty
                          ? widget.movie.overview
                          : 'Descrição não disponível.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.redAccent,
                            size: 26,
                          ),
                          onPressed: widget.onFavoriteToggle,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          icon: Icon(
                            isInWatchLater ? Icons.watch_later : Icons.watch_later_outlined,
                            color: isInWatchLater ? Colors.blueAccent : Colors.grey,
                            size: 26,
                          ),
                          onPressed: toggleWatchLater,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
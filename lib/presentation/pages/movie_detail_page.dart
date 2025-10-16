import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/api_constants.dart';
import '../bloc/movie_detail/movie_detail_bloc.dart';
import '../bloc/movie_detail/movie_detail_event.dart';
import '../bloc/movie_detail/movie_detail_state.dart';
import '../widgets/error_message.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    // Cargar los detalles de la película
    context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.movieId));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailInitial || state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieDetailError) {
            return ErrorMessage(
              message: state.message,
              onRetry: () {
                context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.movieId));
              },
            );
          }

          if (state is MovieDetailLoaded) {
            final movieDetail = state.movieDetail;
            return CustomScrollView(
              slivers: [
                // AppBar con imagen de fondo
                SliverAppBar(
                  expandedHeight: 250,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: '${ApiConstants.imageBaseUrl}${ApiConstants.backdropSize}${movieDetail.backdropPath}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[900],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Contenido
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título y puntuación
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Poster
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: '${ApiConstants.imageBaseUrl}${ApiConstants.posterSize}${movieDetail.posterPath}',
                                    width: 120,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 120,
                                      height: 180,
                                      color: Colors.grey[850],
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 120,
                                      height: 180,
                                      color: Colors.grey[900],
                                      child: const Center(
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Información
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movieDetail.title,
                                        style: Theme.of(context).textTheme.displayMedium,
                                      ),
                                      const SizedBox(height: 8),
                                      // Fecha de estreno
                                      if (movieDetail.releaseDate.isNotEmpty)
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _formatDate(movieDetail.releaseDate),
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(height: 8),
                                      // Puntuación
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            initialRating: movieDetail.voteAverage / 2,
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 20,
                                            ignoreGestures: true,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (_) {},
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${movieDetail.voteAverage.toStringAsFixed(1)}/10',
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // Géneros
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: movieDetail.genres.map((genre) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                            child: Text(
                                              genre.name,
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Descripción
                            Text(
                              'Sinopsis',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movieDetail.overview.isEmpty
                                  ? 'No hay descripción disponible.'
                                  : movieDetail.overview,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),

                            const SizedBox(height: 24),

                            // Botón para ver trailer
                            if (movieDetail.trailerKey != null)
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: () => _openYoutubeVideo(movieDetail.trailerKey!),
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Ver Trailer'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  Future<void> _openYoutubeVideo(String videoKey) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoKey');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el video'),
          ),
        );
      }
    }
  }
}

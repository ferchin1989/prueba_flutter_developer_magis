import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../bloc/movies/movies_bloc.dart';
import '../bloc/movies/movies_event.dart';
import '../bloc/movies/movies_state.dart';
import '../widgets/error_message.dart';
import '../widgets/filter_section.dart';
import '../widgets/horizontal_movie_list.dart';
import '../widgets/movie_grid.dart';
import 'movie_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() {
    context.read<MoviesBloc>().add(const FetchUpcomingMovies());
    context.read<MoviesBloc>().add(const FetchTrendingMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TMDb Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMovies,
          ),
        ],
      ),
      body: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          if (state is MoviesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoviesError) {
            return ErrorMessage(
              message: state.message,
              onRetry: _loadMovies,
            );
          }

          if (state is MoviesLoaded) {
            return _buildContent(state);
          }

          // Estado de carga
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(MoviesLoaded state) {
    // Extraer idiomas y años únicos de las películas en tendencia
    final Set<String> languages = state.trendingMovies
        .map((movie) => movie.originalLanguage)
        .toSet();

    final Set<String> years = state.trendingMovies
        .where((movie) => movie.releaseDate.isNotEmpty)
        .map((movie) => movie.releaseDate.substring(0, 4))
        .toSet();

    return RefreshIndicator(
      onRefresh: () async {
        _loadMovies();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de Próximos Estrenos
            HorizontalMovieList(
              title: 'Próximos Estrenos',
              movies: state.upcomingMovies,
              onMovieTap: (movie) => _navigateToMovieDetail(movie),
              isLoading: state is MoviesLoading,
            ),

            const SizedBox(height: 24),

            // Sección de Tendencia
            HorizontalMovieList(
              title: 'Tendencia',
              movies: state.trendingMovies,
              onMovieTap: (movie) => _navigateToMovieDetail(movie),
              isLoading: state is MoviesLoading,
            ),

            const SizedBox(height: 24),

            // Sección de Recomendados para ti
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recomendados para ti',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),

            const SizedBox(height: 16),

            // Filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FilterSection(
                selectedLanguage: state.selectedLanguage,
                selectedYear: state.selectedReleaseYear,
                onLanguageChanged: (language) {
                  context.read<MoviesBloc>().add(
                        FilterRecommendedMovies(
                          language: language,
                          releaseYear: state.selectedReleaseYear,
                        ),
                      );
                },
                onYearChanged: (year) {
                  context.read<MoviesBloc>().add(
                        FilterRecommendedMovies(
                          language: state.selectedLanguage,
                          releaseYear: year,
                        ),
                      );
                },
                availableLanguages: languages.toList(),
                availableYears: years.toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Grid de películas recomendadas
            MovieGrid(
              movies: state.recommendedMovies,
              onMovieTap: (movie) => _navigateToMovieDetail(movie),
              isLoading: state is MoviesLoading,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _navigateToMovieDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movieId: movie.id),
      ),
    );
  }
}

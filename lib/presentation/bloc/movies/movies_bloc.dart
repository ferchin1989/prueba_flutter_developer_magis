import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/filter_movies.dart';
import '../../../domain/usecases/get_trending_movies.dart';
import '../../../domain/usecases/get_upcoming_movies.dart';
import 'movies_event.dart';
import 'movies_state.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetUpcomingMovies getUpcomingMovies;
  final GetTrendingMovies getTrendingMovies;
  final FilterMovies filterMovies;

  MoviesBloc({
    required this.getUpcomingMovies,
    required this.getTrendingMovies,
    required this.filterMovies,
  }) : super(const MoviesInitial()) {
    on<FetchUpcomingMovies>(_onFetchUpcomingMovies);
    on<FetchTrendingMovies>(_onFetchTrendingMovies);
    on<FilterRecommendedMovies>(_onFilterRecommendedMovies);
  }

  Future<void> _onFetchUpcomingMovies(
    FetchUpcomingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is MoviesLoaded) {
      final currentState = state as MoviesLoaded;
      if (currentState.upcomingMovies.isNotEmpty) {
        return; // Ya tenemos películas, no necesitamos cargarlas de nuevo
      }
    }

    emit(const MoviesLoading());
    try {
      final movies = await getUpcomingMovies();
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;
        emit(currentState.copyWith(upcomingMovies: movies));
      } else {
        emit(MoviesLoaded(upcomingMovies: movies));
      }
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  Future<void> _onFetchTrendingMovies(
    FetchTrendingMovies event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is MoviesLoaded) {
      final currentState = state as MoviesLoaded;
      if (currentState.trendingMovies.isNotEmpty) {
        return; // Ya tenemos películas, no necesitamos cargarlas de nuevo
      }
    }

    emit(const MoviesLoading());
    try {
      final movies = await getTrendingMovies();
      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;
        emit(currentState.copyWith(
          trendingMovies: movies,
          recommendedMovies: filterMovies(
            movies: movies,
            language: currentState.selectedLanguage,
            releaseYear: currentState.selectedReleaseYear,
          ),
        ));
      } else {
        emit(MoviesLoaded(
          trendingMovies: movies,
          recommendedMovies: filterMovies(movies: movies),
        ));
      }
    } catch (e) {
      emit(MoviesError(e.toString()));
    }
  }

  void _onFilterRecommendedMovies(
    FilterRecommendedMovies event,
    Emitter<MoviesState> emit,
  ) {
    if (state is MoviesLoaded) {
      final currentState = state as MoviesLoaded;
      final filteredMovies = filterMovies(
        movies: currentState.trendingMovies,
        language: event.language,
        releaseYear: event.releaseYear,
      );
      emit(currentState.copyWith(
        recommendedMovies: filteredMovies,
        selectedLanguage: event.language,
        selectedReleaseYear: event.releaseYear,
      ));
    }
  }
}

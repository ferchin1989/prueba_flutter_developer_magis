import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object?> get props => [];
}

class MoviesInitial extends MoviesState {
  const MoviesInitial();
}

class MoviesLoading extends MoviesState {
  const MoviesLoading();
}

class MoviesLoaded extends MoviesState {
  final List<Movie> upcomingMovies;
  final List<Movie> trendingMovies;
  final List<Movie> recommendedMovies;
  final String? selectedLanguage;
  final String? selectedReleaseYear;

  const MoviesLoaded({
    this.upcomingMovies = const [],
    this.trendingMovies = const [],
    this.recommendedMovies = const [],
    this.selectedLanguage,
    this.selectedReleaseYear,
  });

  MoviesLoaded copyWith({
    List<Movie>? upcomingMovies,
    List<Movie>? trendingMovies,
    List<Movie>? recommendedMovies,
    String? selectedLanguage,
    String? selectedReleaseYear,
  }) {
    return MoviesLoaded(
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      trendingMovies: trendingMovies ?? this.trendingMovies,
      recommendedMovies: recommendedMovies ?? this.recommendedMovies,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedReleaseYear: selectedReleaseYear ?? this.selectedReleaseYear,
    );
  }

  @override
  List<Object?> get props => [
        upcomingMovies,
        trendingMovies,
        recommendedMovies,
        selectedLanguage,
        selectedReleaseYear,
      ];
}

class MoviesError extends MoviesState {
  final String message;

  const MoviesError(this.message);

  @override
  List<Object> get props => [message];
}

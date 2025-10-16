import 'package:equatable/equatable.dart';

abstract class MoviesEvent extends Equatable {
  const MoviesEvent();

  @override
  List<Object?> get props => [];
}

class FetchUpcomingMovies extends MoviesEvent {
  const FetchUpcomingMovies();
}

class FetchTrendingMovies extends MoviesEvent {
  const FetchTrendingMovies();
}

class FilterRecommendedMovies extends MoviesEvent {
  final String? language;
  final String? releaseYear;

  const FilterRecommendedMovies({
    this.language,
    this.releaseYear,
  });

  @override
  List<Object?> get props => [language, releaseYear];
}

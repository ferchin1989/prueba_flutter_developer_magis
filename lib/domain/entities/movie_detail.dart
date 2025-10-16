import 'package:equatable/equatable.dart';
import 'genre.dart';
import 'movie.dart';

class MovieDetail extends Equatable {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<Genre> genres;
  final String originalLanguage;
  final String? trailerKey;

  const MovieDetail({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    required this.originalLanguage,
    this.trailerKey,
  });

  // Factory constructor para crear un MovieDetail a partir de un Movie
  factory MovieDetail.fromMovie(Movie movie, List<Genre> genres, {String? trailerKey}) {
    return MovieDetail(
      id: movie.id,
      title: movie.title,
      overview: movie.overview,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      genres: genres,
      originalLanguage: movie.originalLanguage,
      trailerKey: trailerKey,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        posterPath,
        backdropPath,
        voteAverage,
        releaseDate,
        genres,
        originalLanguage,
        trailerKey,
      ];
}

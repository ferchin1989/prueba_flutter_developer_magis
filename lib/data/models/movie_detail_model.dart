import '../../domain/entities/genre.dart';
import '../../domain/entities/movie_detail.dart';
import 'genre_model.dart';

class MovieDetailModel extends MovieDetail {
  const MovieDetailModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.backdropPath,
    required super.voteAverage,
    required super.releaseDate,
    required super.genres,
    required super.originalLanguage,
    super.trailerKey,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'],
      title: json['title'],
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres: (json['genres'] as List)
          .map((genre) => GenreModel.fromJson(genre))
          .toList(),
      originalLanguage: json['original_language'] ?? '',
      trailerKey: null, // Se asigna después con los videos
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'genres': genres.map((genre) => {
            'id': genre.id,
            'name': genre.name,
          }).toList(),
      'original_language': originalLanguage,
    };
  }

  MovieDetailModel copyWith({
    int? id,
    String? title,
    String? overview,
    String? posterPath,
    String? backdropPath,
    double? voteAverage,
    String? releaseDate,
    List<Genre>? genres,
    String? originalLanguage,
    String? trailerKey,
  }) {
    return MovieDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      trailerKey: trailerKey ?? this.trailerKey,
    );
  }
}

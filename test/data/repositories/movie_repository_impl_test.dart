import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_flutter_developer_magis/data/models/movie_model.dart';
import 'package:prueba_flutter_developer_magis/domain/entities/movie.dart';

void main() {
  group('MovieModel', () {
    final tMovieModel = const MovieModel(
      id: 1,
      title: 'Test Movie',
      overview: 'Test Overview',
      posterPath: '/testPath.jpg',
      backdropPath: '/backdropPath.jpg',
      voteAverage: 7.5,
      releaseDate: '2023-01-01',
      genreIds: [1, 2, 3],
      originalLanguage: 'en',
    );

    test('should be a subclass of Movie entity', () {
      // Assert
      expect(tMovieModel, isA<Movie>());
    });

    test('should convert from JSON correctly', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'id': 1,
        'title': 'Test Movie',
        'overview': 'Test Overview',
        'poster_path': '/testPath.jpg',
        'backdrop_path': '/backdropPath.jpg',
        'vote_average': 7.5,
        'release_date': '2023-01-01',
        'genre_ids': [1, 2, 3],
        'original_language': 'en',
      };

      // Act
      final result = MovieModel.fromJson(jsonMap);

      // Assert
      expect(result, equals(tMovieModel));
    });

    test('should convert to JSON correctly', () {
      // Act
      final result = tMovieModel.toJson();

      // Assert
      final expectedJsonMap = {
        'id': 1,
        'title': 'Test Movie',
        'overview': 'Test Overview',
        'poster_path': '/testPath.jpg',
        'backdrop_path': '/backdropPath.jpg',
        'vote_average': 7.5,
        'release_date': '2023-01-01',
        'genre_ids': [1, 2, 3],
        'original_language': 'en',
      };
      expect(result, equals(expectedJsonMap));
    });
  });
}

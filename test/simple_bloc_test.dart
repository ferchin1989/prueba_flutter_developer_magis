import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_flutter_developer_magis/domain/entities/movie.dart';
import 'package:prueba_flutter_developer_magis/domain/usecases/filter_movies.dart';

void main() {
  group('FilterMovies', () {
    late FilterMovies filterMovies;
    late List<Movie> testMovies;

    setUp(() {
      filterMovies = FilterMovies();
      testMovies = [
        const Movie(
          id: 1,
          title: 'Test Movie 1',
          overview: 'Overview 1',
          posterPath: '/poster1.jpg',
          backdropPath: '/backdrop1.jpg',
          voteAverage: 7.5,
          releaseDate: '2023-01-15',
          genreIds: [28, 12],
          originalLanguage: 'en',
        ),
        const Movie(
          id: 2,
          title: 'Test Movie 2',
          overview: 'Overview 2',
          posterPath: '/poster2.jpg',
          backdropPath: '/backdrop2.jpg',
          voteAverage: 8.0,
          releaseDate: '2023-05-20',
          genreIds: [16, 10751],
          originalLanguage: 'es',
        ),
      ];
    });

    test('should filter movies by language', () {
      // Act
      final result = filterMovies(
        movies: testMovies,
        language: 'en',
      );

      // Assert
      expect(result.length, 1);
      expect(result.first.id, 1);
    });

    test('should filter movies by release year', () {
      // Act
      final result = filterMovies(
        movies: testMovies,
        releaseYear: '2023',
      );

      // Assert
      expect(result.length, 2);
    });
  });
}

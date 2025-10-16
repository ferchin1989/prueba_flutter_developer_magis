import 'package:flutter_test/flutter_test.dart';
import 'package:prueba_flutter_developer_magis/domain/entities/movie.dart';
import 'package:prueba_flutter_developer_magis/domain/usecases/filter_movies.dart';

void main() {
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
      const Movie(
        id: 3,
        title: 'Test Movie 3',
        overview: 'Overview 3',
        posterPath: '/poster3.jpg',
        backdropPath: '/backdrop3.jpg',
        voteAverage: 6.5,
        releaseDate: '2022-11-10',
        genreIds: [28, 878],
        originalLanguage: 'en',
      ),
      const Movie(
        id: 4,
        title: 'Test Movie 4',
        overview: 'Overview 4',
        posterPath: '/poster4.jpg',
        backdropPath: '/backdrop4.jpg',
        voteAverage: 7.0,
        releaseDate: '2022-08-05',
        genreIds: [35, 10749],
        originalLanguage: 'fr',
      ),
      const Movie(
        id: 5,
        title: 'Test Movie 5',
        overview: 'Overview 5',
        posterPath: '/poster5.jpg',
        backdropPath: '/backdrop5.jpg',
        voteAverage: 8.5,
        releaseDate: '2023-02-28',
        genreIds: [18, 36],
        originalLanguage: 'en',
      ),
      const Movie(
        id: 6,
        title: 'Test Movie 6',
        overview: 'Overview 6',
        posterPath: '/poster6.jpg',
        backdropPath: '/backdrop6.jpg',
        voteAverage: 7.8,
        releaseDate: '2022-12-15',
        genreIds: [27, 53],
        originalLanguage: 'es',
      ),
      const Movie(
        id: 7,
        title: 'Test Movie 7',
        overview: 'Overview 7',
        posterPath: '/poster7.jpg',
        backdropPath: '/backdrop7.jpg',
        voteAverage: 6.9,
        releaseDate: '2023-03-10',
        genreIds: [28, 12, 878],
        originalLanguage: 'ja',
      ),
    ];
  });

  group('FilterMovies', () {
    test('should return all movies when no filters are applied', () {
      // Act
      final result = filterMovies(movies: testMovies);

      // Assert
      expect(result.length, 6); // Limitado a 6 por defecto
      expect(result, testMovies.sublist(0, 6));
    });

    test('should filter movies by language', () {
      // Act
      final result = filterMovies(
        movies: testMovies,
        language: 'en',
      );

      // Assert
      expect(result.length, 3);
      expect(result.every((movie) => movie.originalLanguage == 'en'), true);
    });

    test('should filter movies by release year', () {
      // Act
      final result = filterMovies(
        movies: testMovies,
        releaseYear: '2023',
      );

      // Assert
      expect(result.length, 4);
      expect(result.every((movie) => movie.releaseDate.startsWith('2023')), true);
    });

    test('should filter movies by both language and release year', () {
      // Act
      final result = filterMovies(
        movies: testMovies,
        language: 'en',
        releaseYear: '2023',
      );

      // Assert
      expect(result.length, 2);
      expect(
        result.every(
          (movie) =>
              movie.originalLanguage == 'en' && movie.releaseDate.startsWith('2023'),
        ),
        true,
      );
    });

    test('should limit the number of movies returned', () {
      // Act
      final result = filterMovies(
        movies: testMovies,
        limit: 3,
      );

      // Assert
      expect(result.length, 3);
      expect(result, testMovies.sublist(0, 3));
    });

    test('should return empty list when no movies match the filters', () {
      // Act
      final result = filterMovies(
        movies: testMovies,
        language: 'de', // No hay películas en alemán
      );

      // Assert
      expect(result.length, 0);
      expect(result, isEmpty);
    });
  });
}

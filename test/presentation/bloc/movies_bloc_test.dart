import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prueba_flutter_developer_magis/domain/entities/movie.dart';
import 'package:prueba_flutter_developer_magis/domain/usecases/filter_movies.dart';
import 'package:prueba_flutter_developer_magis/domain/usecases/get_trending_movies.dart';
import 'package:prueba_flutter_developer_magis/domain/usecases/get_upcoming_movies.dart';
import 'package:prueba_flutter_developer_magis/presentation/bloc/movies/movies_bloc.dart';
import 'package:prueba_flutter_developer_magis/presentation/bloc/movies/movies_event.dart';
import 'package:prueba_flutter_developer_magis/presentation/bloc/movies/movies_state.dart';

// Mock classes
class MockGetUpcomingMovies extends Mock implements GetUpcomingMovies {}
class MockGetTrendingMovies extends Mock implements GetTrendingMovies {}
// Implementación real en lugar de mock para simplificar las pruebas
class TestFilterMovies extends FilterMovies {}

void main() {
  late MoviesBloc moviesBloc;
  late MockGetUpcomingMovies mockGetUpcomingMovies;
  late MockGetTrendingMovies mockGetTrendingMovies;
  late FilterMovies filterMovies;

  setUp(() {
    mockGetUpcomingMovies = MockGetUpcomingMovies();
    mockGetTrendingMovies = MockGetTrendingMovies();
    filterMovies = TestFilterMovies();
    moviesBloc = MoviesBloc(
      getUpcomingMovies: mockGetUpcomingMovies,
      getTrendingMovies: mockGetTrendingMovies,
      filterMovies: filterMovies,
    );
  });

  tearDown(() {
    moviesBloc.close();
  });

  final tMovies = [
    const Movie(
      id: 1,
      title: 'Test Movie',
      overview: 'Test Overview',
      posterPath: '/testPath.jpg',
      backdropPath: '/backdropPath.jpg',
      voteAverage: 7.5,
      releaseDate: '2023-01-01',
      genreIds: [1, 2, 3],
      originalLanguage: 'en',
    ),
  ];

  group('MoviesBloc', () {
    test('initial state should be MoviesInitial', () {
      // Assert
      expect(moviesBloc.state, const MoviesInitial());
    });

    blocTest<MoviesBloc, MoviesState>(
      'should emit [MoviesLoading, MoviesLoaded] when FetchUpcomingMovies is added',
      build: () {
        when(mockGetUpcomingMovies())
            .thenAnswer((_) async => tMovies);
        return moviesBloc;
      },
      act: (bloc) => bloc.add(const FetchUpcomingMovies()),
      expect: () => [
        const MoviesLoading(),
        MoviesLoaded(upcomingMovies: tMovies),
      ],
      verify: (_) {
        verify(mockGetUpcomingMovies());
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'should emit [MoviesLoading, MoviesLoaded] when FetchTrendingMovies is added',
      build: () {
        when(mockGetTrendingMovies())
            .thenAnswer((_) async => tMovies);
        // No necesitamos mockear filterMovies porque usamos la implementación real
        return moviesBloc;
      },
      act: (bloc) => bloc.add(const FetchTrendingMovies()),
      expect: () => [
        const MoviesLoading(),
        isA<MoviesLoaded>(),
      ],
      verify: (_) {
        verify(mockGetTrendingMovies());
      },
    );

    blocTest<MoviesBloc, MoviesState>(
      'should emit [MoviesLoaded] with filtered movies when FilterRecommendedMovies is added',
      build: () {
        // No necesitamos mockear filterMovies porque usamos la implementación real
        return moviesBloc;
      },
      seed: () => MoviesLoaded(trendingMovies: tMovies),
      act: (bloc) => bloc.add(const FilterRecommendedMovies(
        language: 'en',
        releaseYear: '2023',
      )),
      expect: () => [
        isA<MoviesLoaded>(),
      ],
    );

    blocTest<MoviesBloc, MoviesState>(
      'should emit [MoviesError] when an error occurs',
      build: () {
        when(mockGetUpcomingMovies())
            .thenThrow(Exception('Test error'));
        return moviesBloc;
      },
      act: (bloc) => bloc.add(const FetchUpcomingMovies()),
      expect: () => [
        const MoviesLoading(),
        const MoviesError('Exception: Test error'),
      ],
      verify: (_) {
        verify(mockGetUpcomingMovies());
      },
    );
  });
}

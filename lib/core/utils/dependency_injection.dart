import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/datasources/movie_local_data_source.dart';
import '../../data/datasources/movie_local_data_source_impl.dart';
import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/datasources/movie_remote_data_source_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../domain/repositories/movie_repository.dart';
import '../../domain/usecases/filter_movies.dart';
import '../../domain/usecases/get_genres.dart';
import '../../domain/usecases/get_movie_details.dart';
import '../../domain/usecases/get_movie_videos.dart';
import '../../domain/usecases/get_trending_movies.dart';
import '../../domain/usecases/get_upcoming_movies.dart';
import '../../presentation/bloc/movie_detail/movie_detail_bloc.dart';
import '../../presentation/bloc/movies/movies_bloc.dart';
import '../network/api_client.dart';
import '../network/network_info.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Inicializar Hive para almacenamiento local
  await Hive.initFlutter();

  // Core
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt()),
  );
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton(() => ApiClient());
  getIt.registerLazySingleton<HiveInterface>(() => Hive);

  // Data sources
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(getIt()),
  );
  getIt.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use cases
  getIt.registerLazySingleton(() => GetUpcomingMovies(getIt()));
  getIt.registerLazySingleton(() => GetTrendingMovies(getIt()));
  getIt.registerLazySingleton(() => GetMovieDetails(getIt()));
  getIt.registerLazySingleton(() => GetMovieVideos(getIt()));
  getIt.registerLazySingleton(() => GetGenres(getIt()));
  getIt.registerLazySingleton(() => FilterMovies());

  // BLoCs
  getIt.registerFactory(
    () => MoviesBloc(
      getUpcomingMovies: getIt(),
      getTrendingMovies: getIt(),
      filterMovies: getIt(),
    ),
  );
  getIt.registerFactory(
    () => MovieDetailBloc(
      getMovieDetails: getIt(),
      getMovieVideos: getIt(),
    ),
  );
}

List<BlocProvider> getProviders() {
  return [
    BlocProvider<MoviesBloc>(
      create: (context) => getIt<MoviesBloc>(),
    ),
    BlocProvider<MovieDetailBloc>(
      create: (context) => getIt<MovieDetailBloc>(),
    ),
  ];
}

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/constants/hive_constants.dart';
import '../models/genre_model.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/video_model.dart';
import 'movie_local_data_source.dart';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final HiveInterface _hive;

  MovieLocalDataSourceImpl(this._hive);

  @override
  Future<List<MovieModel>> getUpcomingMovies() async {
    final box = await _hive.openBox(HiveConstants.upcomingMoviesBox);
    final moviesJson = box.get(HiveConstants.upcomingMoviesKey);
    
    if (moviesJson != null) {
      final List<dynamic> moviesList = jsonDecode(moviesJson);
      return moviesList.map((movie) => MovieModel.fromJson(movie)).toList();
    }
    
    return [];
  }

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final box = await _hive.openBox(HiveConstants.trendingMoviesBox);
    final moviesJson = box.get(HiveConstants.trendingMoviesKey);
    
    if (moviesJson != null) {
      final List<dynamic> moviesList = jsonDecode(moviesJson);
      return moviesList.map((movie) => MovieModel.fromJson(movie)).toList();
    }
    
    return [];
  }

  @override
  Future<MovieDetailModel?> getMovieDetails(int movieId) async {
    final box = await _hive.openBox(HiveConstants.movieDetailsBox);
    final movieJson = box.get(movieId.toString());
    
    if (movieJson != null) {
      return MovieDetailModel.fromJson(jsonDecode(movieJson));
    }
    
    return null;
  }

  @override
  Future<List<VideoModel>> getMovieVideos(int movieId) async {
    final box = await _hive.openBox(HiveConstants.movieVideosBox);
    final videosJson = box.get(movieId.toString());
    
    if (videosJson != null) {
      final List<dynamic> videosList = jsonDecode(videosJson);
      return videosList.map((video) => VideoModel.fromJson(video)).toList();
    }
    
    return [];
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final box = await _hive.openBox(HiveConstants.genresBox);
    final genresJson = box.get(HiveConstants.genresKey);
    
    if (genresJson != null) {
      final List<dynamic> genresList = jsonDecode(genresJson);
      return genresList.map((genre) => GenreModel.fromJson(genre)).toList();
    }
    
    return [];
  }

  @override
  Future<void> cacheUpcomingMovies(List<MovieModel> movies) async {
    final box = await _hive.openBox(HiveConstants.upcomingMoviesBox);
    final moviesJson = jsonEncode(movies.map((movie) => movie.toJson()).toList());
    await box.put(HiveConstants.upcomingMoviesKey, moviesJson);
  }

  @override
  Future<void> cacheTrendingMovies(List<MovieModel> movies) async {
    final box = await _hive.openBox(HiveConstants.trendingMoviesBox);
    final moviesJson = jsonEncode(movies.map((movie) => movie.toJson()).toList());
    await box.put(HiveConstants.trendingMoviesKey, moviesJson);
  }

  @override
  Future<void> cacheMovieDetails(MovieDetailModel movieDetail) async {
    final box = await _hive.openBox(HiveConstants.movieDetailsBox);
    final movieJson = jsonEncode(movieDetail.toJson());
    await box.put(movieDetail.id.toString(), movieJson);
  }

  @override
  Future<void> cacheMovieVideos(int movieId, List<VideoModel> videos) async {
    final box = await _hive.openBox(HiveConstants.movieVideosBox);
    final videosJson = jsonEncode(videos.map((video) => video.toJson()).toList());
    await box.put(movieId.toString(), videosJson);
  }

  @override
  Future<void> cacheGenres(List<GenreModel> genres) async {
    final box = await _hive.openBox(HiveConstants.genresBox);
    final genresJson = jsonEncode(genres.map((genre) => genre.toJson()).toList());
    await box.put(HiveConstants.genresKey, genresJson);
  }
}

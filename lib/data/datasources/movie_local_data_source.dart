import '../models/genre_model.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/video_model.dart';

abstract class MovieLocalDataSource {
  /// Obtiene la lista de películas próximas a estrenarse desde el almacenamiento local
  Future<List<MovieModel>> getUpcomingMovies();

  /// Obtiene la lista de películas en tendencia desde el almacenamiento local
  Future<List<MovieModel>> getTrendingMovies();

  /// Obtiene los detalles de una película por su ID desde el almacenamiento local
  Future<MovieDetailModel?> getMovieDetails(int movieId);

  /// Obtiene los videos (trailers) de una película por su ID desde el almacenamiento local
  Future<List<VideoModel>> getMovieVideos(int movieId);

  /// Obtiene la lista de géneros de películas desde el almacenamiento local
  Future<List<GenreModel>> getGenres();

  /// Guarda la lista de películas próximas a estrenarse en el almacenamiento local
  Future<void> cacheUpcomingMovies(List<MovieModel> movies);

  /// Guarda la lista de películas en tendencia en el almacenamiento local
  Future<void> cacheTrendingMovies(List<MovieModel> movies);

  /// Guarda los detalles de una película en el almacenamiento local
  Future<void> cacheMovieDetails(MovieDetailModel movieDetail);

  /// Guarda los videos (trailers) de una película en el almacenamiento local
  Future<void> cacheMovieVideos(int movieId, List<VideoModel> videos);

  /// Guarda la lista de géneros de películas en el almacenamiento local
  Future<void> cacheGenres(List<GenreModel> genres);
}

import '../models/genre_model.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/video_model.dart';

abstract class MovieRemoteDataSource {
  /// Obtiene la lista de películas próximas a estrenarse desde la API
  Future<List<MovieModel>> getUpcomingMovies();

  /// Obtiene la lista de películas en tendencia desde la API
  Future<List<MovieModel>> getTrendingMovies();

  /// Obtiene los detalles de una película por su ID desde la API
  Future<MovieDetailModel> getMovieDetails(int movieId);

  /// Obtiene los videos (trailers) de una película por su ID desde la API
  Future<List<VideoModel>> getMovieVideos(int movieId);

  /// Obtiene la lista de géneros de películas desde la API
  Future<List<GenreModel>> getGenres();
}

import '../entities/genre.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';
import '../entities/video.dart';

abstract class MovieRepository {
  /// Obtiene la lista de películas próximas a estrenarse
  Future<List<Movie>> getUpcomingMovies();

  /// Obtiene la lista de películas en tendencia
  Future<List<Movie>> getTrendingMovies();

  /// Obtiene los detalles de una película por su ID
  Future<MovieDetail> getMovieDetails(int movieId);

  /// Obtiene los videos (trailers) de una película por su ID
  Future<List<Video>> getMovieVideos(int movieId);

  /// Obtiene la lista de géneros de películas
  Future<List<Genre>> getGenres();
}

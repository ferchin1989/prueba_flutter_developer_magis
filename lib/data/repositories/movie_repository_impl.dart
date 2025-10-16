import '../../core/network/network_info.dart';
import '../../domain/entities/genre.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/entities/video.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_detail_model.dart';
import '../models/video_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Movie>> getUpcomingMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getUpcomingMovies();
        await localDataSource.cacheUpcomingMovies(remoteMovies);
        return remoteMovies;
      } catch (_) {
        return await localDataSource.getUpcomingMovies();
      }
    } else {
      return await localDataSource.getUpcomingMovies();
    }
  }

  @override
  Future<List<Movie>> getTrendingMovies() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovies = await remoteDataSource.getTrendingMovies();
        await localDataSource.cacheTrendingMovies(remoteMovies);
        return remoteMovies;
      } catch (_) {
        return await localDataSource.getTrendingMovies();
      }
    } else {
      return await localDataSource.getTrendingMovies();
    }
  }

  @override
  Future<MovieDetail> getMovieDetails(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteMovieDetail = await remoteDataSource.getMovieDetails(movieId);
        
        // Obtener los videos para el trailer
        final videos = await remoteDataSource.getMovieVideos(movieId);
        
        // Buscar un trailer de YouTube
        VideoModel? trailerVideo;
        
        // Primero buscar un trailer oficial
        try {
          trailerVideo = videos.firstWhere(
            (video) => video.site.toLowerCase() == 'youtube' && 
                      video.type.toLowerCase() == 'trailer',
          );
        } catch (_) {
          // Si no hay trailer oficial, buscar cualquier video de YouTube
          if (videos.isNotEmpty) {
            try {
              trailerVideo = videos.firstWhere(
                (video) => video.site.toLowerCase() == 'youtube',
              );
            } catch (_) {
              // Si no hay videos de YouTube, usar el primer video disponible
              if (videos.isNotEmpty) {
                trailerVideo = videos.first;
              }
            }
          }
        }
        
        // Crear una copia del modelo con el key del trailer
        final movieDetailWithTrailer = remoteMovieDetail.copyWith(
          trailerKey: trailerVideo?.key,
        );
        
        await localDataSource.cacheMovieDetails(movieDetailWithTrailer);
        await localDataSource.cacheMovieVideos(movieId, videos);
        
        return movieDetailWithTrailer;
      } catch (_) {
        final cachedMovieDetail = await localDataSource.getMovieDetails(movieId);
        if (cachedMovieDetail != null) {
          return cachedMovieDetail;
        }
        throw Exception('No se pudo obtener los detalles de la película');
      }
    } else {
      final cachedMovieDetail = await localDataSource.getMovieDetails(movieId);
      if (cachedMovieDetail != null) {
        return cachedMovieDetail;
      }
      throw Exception('No hay conexión a internet y no hay datos en caché');
    }
  }

  @override
  Future<List<Video>> getMovieVideos(int movieId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteVideos = await remoteDataSource.getMovieVideos(movieId);
        await localDataSource.cacheMovieVideos(movieId, remoteVideos);
        return remoteVideos;
      } catch (_) {
        return await localDataSource.getMovieVideos(movieId);
      }
    } else {
      return await localDataSource.getMovieVideos(movieId);
    }
  }

  @override
  Future<List<Genre>> getGenres() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteGenres = await remoteDataSource.getGenres();
        await localDataSource.cacheGenres(remoteGenres);
        return remoteGenres;
      } catch (_) {
        return await localDataSource.getGenres();
      }
    } else {
      return await localDataSource.getGenres();
    }
  }
}

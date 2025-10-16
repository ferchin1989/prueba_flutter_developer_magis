import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/genre_model.dart';
import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/video_model.dart';
import 'movie_remote_data_source.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient _apiClient;

  MovieRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<MovieModel>> getUpcomingMovies() async {
    final response = await _apiClient.get(ApiConstants.upcomingMoviesEndpoint);
    return (response['results'] as List)
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
  }

  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    final response = await _apiClient.get(ApiConstants.trendingMoviesEndpoint);
    return (response['results'] as List)
        .map((movie) => MovieModel.fromJson(movie))
        .toList();
  }

  @override
  Future<MovieDetailModel> getMovieDetails(int movieId) async {
    final response = await _apiClient.get('${ApiConstants.movieDetailsEndpoint}$movieId');
    return MovieDetailModel.fromJson(response);
  }

  @override
  Future<List<VideoModel>> getMovieVideos(int movieId) async {
    final endpoint = ApiConstants.movieVideosEndpoint.replaceFirst('{movie_id}', movieId.toString());
    final response = await _apiClient.get(endpoint);
    return (response['results'] as List)
        .map((video) => VideoModel.fromJson(video))
        .toList();
  }

  @override
  Future<List<GenreModel>> getGenres() async {
    final response = await _apiClient.get(ApiConstants.genresEndpoint);
    return (response['genres'] as List)
        .map((genre) => GenreModel.fromJson(genre))
        .toList();
  }
}

import '../entities/video.dart';
import '../repositories/movie_repository.dart';

class GetMovieVideos {
  final MovieRepository repository;

  GetMovieVideos(this.repository);

  Future<List<Video>> call(int movieId) async {
    return await repository.getMovieVideos(movieId);
  }
}

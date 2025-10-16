import '../entities/genre.dart';
import '../repositories/movie_repository.dart';

class GetGenres {
  final MovieRepository repository;

  GetGenres(this.repository);

  Future<List<Genre>> call() async {
    return await repository.getGenres();
  }
}

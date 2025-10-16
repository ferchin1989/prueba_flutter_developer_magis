import '../entities/movie.dart';

class FilterMovies {
  List<Movie> call({
    required List<Movie> movies,
    String? language,
    String? releaseYear,
    int limit = 6,
  }) {
    List<Movie> filteredMovies = List.from(movies);

    if (language != null && language.isNotEmpty) {
      filteredMovies = filteredMovies
          .where((movie) => movie.originalLanguage == language)
          .toList();
    }

    if (releaseYear != null && releaseYear.isNotEmpty) {
      filteredMovies = filteredMovies
          .where((movie) => movie.releaseDate.startsWith(releaseYear))
          .toList();
    }

    // Limitar a un máximo de 'limit' películas
    if (filteredMovies.length > limit) {
      filteredMovies = filteredMovies.sublist(0, limit);
    }

    return filteredMovies;
  }
}

class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/';
  static const String apiKey = '2fa782cd18c51cae0b516f776bcc2d3a'; // API key de TMDb
  
  // Tamaños de imágenes
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';
  static const String profileSize = 'w185';
  
  // Endpoints
  static const String upcomingMoviesEndpoint = '/movie/upcoming';
  static const String trendingMoviesEndpoint = '/trending/movie/day';
  static const String movieDetailsEndpoint = '/movie/';
  static const String movieVideosEndpoint = '/movie/{movie_id}/videos';
  static const String genresEndpoint = '/genre/movie/list';
  
  // Parámetros
  static const String apiKeyParam = 'api_key';
  static const String languageParam = 'language';
  static const String pageParam = 'page';
  static const String regionParam = 'region';
  
  // Valores por defecto
  static const String defaultLanguage = 'es-ES';
  static const String defaultRegion = 'ES';
  static const int defaultPage = 1;
}

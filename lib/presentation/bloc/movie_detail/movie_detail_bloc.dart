import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_movie_details.dart';
import '../../../domain/usecases/get_movie_videos.dart';
import 'movie_detail_event.dart';
import 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetails getMovieDetails;
  final GetMovieVideos getMovieVideos;

  MovieDetailBloc({
    required this.getMovieDetails,
    required this.getMovieVideos,
  }) : super(const MovieDetailInitial()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<FetchMovieVideos>(_onFetchMovieVideos);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(const MovieDetailLoading());
    try {
      final movieDetail = await getMovieDetails(event.movieId);
      emit(MovieDetailLoaded(movieDetail: movieDetail));
      add(FetchMovieVideos(event.movieId));
    } catch (e) {
      emit(MovieDetailError(e.toString()));
    }
  }

  Future<void> _onFetchMovieVideos(
    FetchMovieVideos event,
    Emitter<MovieDetailState> emit,
  ) async {
    try {
      if (state is MovieDetailLoaded) {
        final currentState = state as MovieDetailLoaded;
        final videos = await getMovieVideos(event.movieId);
        emit(currentState.copyWith(videos: videos));
      }
    } catch (_) {
      // Si falla la carga de videos, mantenemos el estado actual
      // ya que los videos son opcionales
    }
  }
}

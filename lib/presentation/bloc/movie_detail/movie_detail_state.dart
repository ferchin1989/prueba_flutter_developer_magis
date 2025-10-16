import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../domain/entities/video.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movieDetail;
  final List<Video> videos;

  const MovieDetailLoaded({
    required this.movieDetail,
    this.videos = const [],
  });

  MovieDetailLoaded copyWith({
    MovieDetail? movieDetail,
    List<Video>? videos,
  }) {
    return MovieDetailLoaded(
      movieDetail: movieDetail ?? this.movieDetail,
      videos: videos ?? this.videos,
    );
  }

  @override
  List<Object> get props => [movieDetail, videos];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

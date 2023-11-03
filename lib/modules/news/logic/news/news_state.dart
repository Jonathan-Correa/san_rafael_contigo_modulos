part of 'news_bloc.dart';

@immutable
abstract class NewsState {
  final ServerError? error;
  const NewsState(this.error);
}

class NewsLoading extends NewsState {
  const NewsLoading() : super(null);
}

class NewsLoadedState extends NewsState {
  final List<New> newsList;
  const NewsLoadedState(this.newsList) : super(null);
}

class NewsSliderLoadedState extends NewsState {
  final List<ImageCarouselItem<New>> news;
  const NewsSliderLoadedState(this.news) : super(null);
}

class NewLoadedState extends NewsState {
  final New news;
  const NewLoadedState(this.news) : super(null);
}

class NewsErrorState extends NewsState {
  const NewsErrorState(ServerError error) : super(error);
}

part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {
  const NewsEvent();
}

class GetNews extends NewsEvent {
  const GetNews();
}

class GetNewById extends NewsEvent {
  final int newId;

  const GetNewById(this.newId);
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../models/server_error.dart';
import '../../../../widgets/image_carousel.dart';
import '/modules/news/models/new.dart';
import '/modules/news/services/news_service.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final String _userToken;
  final NewsService _newsService;

  NewsBloc({
    required String userToken,
    required NewsService newsService,
  })  : _newsService = newsService,
        _userToken = userToken,
        super(const NewsLoading()) {
    on<NewsEvent>((event, emit) async {
      try {
        if (event is GetNews) {
          final response = await _newsService.getNews(
            page: newsListPage,
            token: _userToken,
          );

          newsListTotalPages = response.lastPage;
          currentNewsList = [...currentNewsList, ...response.results];
          emit(NewsLoadedState(currentNewsList));
        } else if (event is GetNewById) {
          emit(const NewsLoading());
          final news = await _newsService.getNewById(
            event.newId,
            _userToken,
          );

          emit(NewLoadedState(news));
        }
      } catch (e) {
        final error = e as ServerError;
        emit(NewsErrorState(error));
      }
    });
  }

  List<New> currentNewsList = [];
  int newsListPage = 1;
  int newsListTotalPages = 1;

  void listNextPage() {
    if (newsListPage < newsListTotalPages) {
      newsListPage++;
      add(const GetNews());
    }
  }
}

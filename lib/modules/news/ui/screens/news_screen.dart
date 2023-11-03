import 'package:csr_design_system/widgets/csr_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/error_message_widget.dart';
import '/modules/news/logic/news/news_bloc.dart';
import '/modules/news/services/news_service.dart';
import '/modules/news/ui/widgets/small_card_news.dart';
import '/modules/news/ui/widgets/large_card_news.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({
    super.key,
    required this.apiToken,
    required this.loadingScreen,
    required this.onSessionExpired,
    required this.onRedirectToDetailScreen,
  });

  final String apiToken;
  final Widget loadingScreen;
  final Function(BuildContext context) onSessionExpired;
  final Function(int newId) onRedirectToDetailScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CsrAppBar(),
      body: BlocProvider(
        create: (context) {
          return NewsBloc(
            newsService: NewsService(apiToken: apiToken),
          )..add(const GetNews());
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: _NewsView(
            loadingScreen: loadingScreen,
            onSessionExpired: onSessionExpired,
            onRedirectToDetailScreen: onRedirectToDetailScreen,
          ),
        ),
      ),
    );
  }
}

class _NewsView extends StatefulWidget {
  const _NewsView({
    Key? key,
    required this.loadingScreen,
    required this.onSessionExpired,
    required this.onRedirectToDetailScreen,
  }) : super(key: key);

  final Widget loadingScreen;
  final Function(BuildContext context) onSessionExpired;
  final Function(int newId) onRedirectToDetailScreen;

  @override
  State<_NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<_NewsView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const spaceHeight = SizedBox(height: 20);
    final screenSize = MediaQuery.of(context).size;

    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, NewsState state) {
        if (state is NewsLoading) {
          return widget.loadingScreen;
        } else if (state is NewsLoadedState) {
          if (state.newsList.isEmpty) {
            return const ErrorMessageWidget(
              message: 'No hay noticias para mostrar',
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.only(
              bottom: screenSize.height * 0.1,
              left: 27,
              right: 27,
            ),
            separatorBuilder: (context, index) => spaceHeight,
            itemCount: state.newsList.length,
            itemBuilder: (context, i) {
              if (state.newsList[i].typeNewId == 1) {
                return LargeCardNews(
                  title: state.newsList[i].title,
                  image: state.newsList[i].picturePath,
                  content: state.newsList[i].description,
                  publishDate: state.newsList[i].date,
                  onPress: () =>
                      widget.onRedirectToDetailScreen(state.newsList[i].id),
                );
              }

              return SmallCardNews(
                title: state.newsList[i].title,
                image: state.newsList[i].picturePath,
                content: state.newsList[i].description,
                publishDate: state.newsList[i].date,
                press: () =>
                    widget.onRedirectToDetailScreen(state.newsList[i].id),
              );
            },
          );
        } else {
          final error = state.error;

          if (error!.shouldLogout) {
            widget.onSessionExpired(context);
          }

          return ErrorMessageWidget(
            message: error.message,
            onRefresh: error.shouldRetry
                ? () => context.read<NewsBloc>().add(const GetNews())
                : null,
          );
        }
      },
    );
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      context.read<NewsBloc>().listNextPage();
    }
  }
}

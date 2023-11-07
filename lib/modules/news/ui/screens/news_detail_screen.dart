import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/widgets/error_message_widget.dart';
import '/modules/news/logic/news/news_bloc.dart';
import '/modules/news/services/news_service.dart';
import '/modules/news/ui/widgets/news_detail_header.dart';
import '/modules/news/ui/widgets/news_detail_content.dart';
import '/modules/news/models/new_detail_screen_params.dart';

class NewsDetailScreen extends StatelessWidget {
  static const routeName = 'news_detail_screen';

  const NewsDetailScreen({
    Key? key,
    required this.params,
    required this.loadingScreen,
    required this.onTapDetailUrl,
    required this.onSessionExpired,
  }) : super(key: key);

  final Widget loadingScreen;
  final NewDetailScreenParams params;
  final Function(String url) onTapDetailUrl;
  final Function(BuildContext context) onSessionExpired;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return NewsBloc(
            newsService: NewsService(
              apiToken: params.apiToken,
              apiUrl: params.apiUrl,
            ),
          )..add(GetNewById(params.newId, params.userToken));
        },
        child: _NewsDetailView(
          params: params,
          loadingScreen: loadingScreen,
          onTapDetailUrl: onTapDetailUrl,
          onSessionExpired: onSessionExpired,
        ),
      ),
    );
  }
}

class _NewsDetailView extends StatelessWidget {
  const _NewsDetailView({
    Key? key,
    required this.params,
    required this.loadingScreen,
    required this.onTapDetailUrl,
    required this.onSessionExpired,
  }) : super(key: key);

  final Widget loadingScreen;
  final NewDetailScreenParams params;
  final Function(String url) onTapDetailUrl;
  final Function(BuildContext context) onSessionExpired;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, NewsState state) {
        if (state is NewsLoading) {
          return loadingScreen;
        } else if (state is NewLoadedState) {
          return CustomScrollView(
            slivers: [
              NewsDetailHeader(news: state.news),
              NewsDetailContent(
                data: state.news,
                onTapUrl: onTapDetailUrl,
              )
            ],
          );
        } else {
          final error = state.error;

          if (error!.shouldLogout) {
            onSessionExpired(context);
          }

          return ErrorMessageWidget(
            message: error.message,
            onRefresh: error.shouldRetry
                ? () => context
                    .read<NewsBloc>()
                    .add(GetNewById(params.newId, params.userToken))
                : null,
          );
        }
      },
    );
  }
}

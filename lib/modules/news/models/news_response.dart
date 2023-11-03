import '/modules/news/models/new.dart';

class NewsResponse {
  const NewsResponse({
    required this.results,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  final List<New> results;
  final int currentPage;
  final int lastPage;
  final int total;

  factory NewsResponse.fromMap(Map<String, dynamic> json) {
    return NewsResponse(
      results: List<New>.from(
        json['results'].map((x) => New.fromMap(x)),
      ),
      currentPage: int.parse('${json['current_page']}'),
      lastPage: int.parse('${json['last_page']}'),
      total: int.parse('${json['total']}'),
    );
  }
}

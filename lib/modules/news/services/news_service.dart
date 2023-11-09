import 'package:csr_shared_modules/config/csr_preferences.dart';
import 'package:http/http.dart' as http;

import '/modules/news/models/new.dart';
import '/services/server_service.dart';
import '/modules/news/models/news_response.dart';

class NewsService {
  final String _apiUrl;
  final String _apiToken;
  final CsrPreferences _preferences;

  const NewsService({
    required String apiUrl,
    required String apiToken,
    required CsrPreferences preferences,
  })  : _apiToken = apiToken,
        _apiUrl = apiUrl,
        _preferences = preferences;

  Future<NewsResponse> getNews({
    int? roleId,
    String filter = '',
    int page = 1,
    int count = 20,
  }) async {
    final customerRoleId = roleId != null ? '$roleId' : '';
    final userToken = await _preferences.getToken();

    final headers = {
      'token': userToken,
      'Content-Type': 'application/json',
      'Authorization': _apiToken
    };

    final query = Uri(
      queryParameters: {
        'filter': filter,
        'page': '$page',
        'count': '$count',
        'customerRoleId': customerRoleId,
      },
    ).query;

    final uri = Uri.parse('$_apiUrl/news?$query');
    final response = http.get(uri, headers: headers);

    final body = await ServerService.processResponse(response);
    return NewsResponse.fromMap(body.data);
  }

  Future<New> getNewById(int newId) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': _apiToken,
      'token': await _preferences.getToken()
    };

    final uri = Uri.parse('$_apiUrl/news/$newId');

    final response = http.get(uri, headers: headers);
    final body = await ServerService.processResponse(response);
    return New.fromMap(body.data);
  }
}

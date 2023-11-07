class NewDetailScreenParams {
  final int newId;
  final String apiToken;
  final String apiUrl;
  final String userToken;

  const NewDetailScreenParams({
    required this.newId,
    required this.apiToken,
    required this.userToken,
    required this.apiUrl,
  });

  factory NewDetailScreenParams.fromMap(
    Map<String, dynamic> data,
  ) {
    return NewDetailScreenParams(
      newId: data['id'],
      apiUrl: data['apiUrl'],
      apiToken: data['apiToken'],
      userToken: data['userToken'],
    );
  }
}

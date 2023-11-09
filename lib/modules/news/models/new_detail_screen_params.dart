class NewDetailScreenParams {
  final int newId;
  final String apiToken;
  final String apiUrl;

  const NewDetailScreenParams({
    required this.newId,
    required this.apiToken,
    required this.apiUrl,
  });

  factory NewDetailScreenParams.fromMap(
    Map<String, dynamic> data,
  ) {
    return NewDetailScreenParams(
      newId: data['id'],
      apiUrl: data['apiUrl'],
      apiToken: data['apiToken'],
    );
  }
}

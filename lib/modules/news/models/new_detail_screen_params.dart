class NewDetailScreenParams {
  final int newId;
  final String userToken;

  const NewDetailScreenParams({
    required this.newId,
    required this.userToken,
  });

  factory NewDetailScreenParams.fromMap(
    Map<String, dynamic> data,
  ) {
    return NewDetailScreenParams(
      newId: data['id'],
      userToken: data['userToken'],
    );
  }
}

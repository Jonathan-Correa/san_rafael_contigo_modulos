import '/config/constants.dart';

abstract class BlogOrNew {
  final int id;
  final String title;
  final String body;
  final String date;
  final String picture;
  final String description;

  String get picturePath => '${Constants.apiDomain}$picture';

  const BlogOrNew({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
    required this.picture,
    required this.description,
  });
}

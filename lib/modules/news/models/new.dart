import 'dart:convert';

import '/models/blog_or_new.dart';

class New extends BlogOrNew {
  final int typeNewId;

  const New({
    required id,
    required title,
    required body,
    required date,
    required picture,
    required this.typeNewId,
    required description,
  }) : super(
          id: id,
          title: title,
          body: body,
          date: date,
          picture: picture,
          description: description,
        );

  factory New.fromJson(String str) => New.fromMap(json.decode(str));

  factory New.fromMap(Map<String, dynamic> map) {
    return New(
      id: map['id'],
      title: map['title'],
      body: map['body'] ?? '',
      description: map['description'] ?? '',
      date: map['date'],
      picture: map['picture'] ?? '',
      typeNewId: map['news_type_id'],
    );
  }
}

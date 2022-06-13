import 'dart:convert';

class CastNameSpaces {
  final String name;
  CastNameSpaces({
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory CastNameSpaces.fromMap(Map<String, dynamic> map) {
    return CastNameSpaces(
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CastNameSpaces.fromJson(String source) =>
      CastNameSpaces.fromMap(json.decode(source));
}

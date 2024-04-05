
class Bustype {
  String name;

  Bustype({
    required this.name,
  });

  Bustype.fromJson(Map<String, dynamic> json)
      : this(name: json['name']! as String);

  Bustype copyWith({
    String? name,
  }) {
    return Bustype(name: name ?? this.name);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}

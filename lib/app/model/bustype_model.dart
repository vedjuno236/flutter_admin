import 'package:cloud_firestore/cloud_firestore.dart';

class Bustype {
  String nume;

  Bustype({
   required this.nume,
  });

  Bustype.fromJson(Map<String, Object?> json)
      : this(nume: json['name']! as String);

  

  Bustype copyWith({
    String? nume,
  }) {
    return Bustype(nume: nume ?? this.nume);
  }
  Map<String, Object > toJson() {
    return {
      'nume': nume,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Bustype {
  String? nume;

  Bustype({
    this.nume,
  });

  Bustype.fromJson(Map<String, dynamic>? json)
      : nume = json?['nume'] as String?;

  Map<String, dynamic> toJson() {
    return {
      'nume': nume,
    };
  }

  Bustype copyWith({
    String? nume,
  }) {
    return Bustype(nume: nume ?? this.nume);
  }
}

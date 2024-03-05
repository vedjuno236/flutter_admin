import 'package:cloud_firestore/cloud_firestore.dart';

class Stations {
  String nume;

  Stations({
   required this.nume,
  });

  Stations.fromJson(Map<String, Object?> json)
      : this(nume: json['name']! as String);

  

  Stations copyWith({
    String? nume,
  }) {
    return Stations(nume: nume ?? this.nume);
  }
  Map<String, Object > toJson() {
    return {
      'nume': nume,
    };
  }
}

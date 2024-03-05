import 'package:cloud_firestore/cloud_firestore.dart';

class Departures {
  String busId;
  String routeId;


  Departures({
   required this.busId,
   required this.routeId,

  });

  Departures.fromJson(Map<String, Object?> json)
      : this(busId: json['busId']! as String,
      routeId: json['routeId']! as String,
      );

  

  Departures copyWith({
    String? busId,
  }) {
    return Departures(busId: busId ?? this.busId, routeId:routeId ?? this.routeId);
  }
  Map<String, Object > toJson() {
    return {
      'busId': busId,
      'routeId': routeId,

    };
  }
}

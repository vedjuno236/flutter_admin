import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/stations_model.dart';
class Routes {
  String id;
  Stations arrival_station_id;
  Timestamp arrival_time;
  Stations departure_station_id;
  Timestamp departure_time;
  Routes({
    required this.id,
    required this.arrival_station_id,
    required this.arrival_time,
    required this.departure_station_id,
    required this.departure_time,
  });
  Routes.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String? ?? '',
        arrival_station_id = _parseStations(json['arrival_station_id']),
        arrival_time = json['arrival_time'] as Timestamp? ?? Timestamp.now(),
        departure_station_id = _parseStations(json['departure_station_id']),
        departure_time =
            json['departure_time'] as Timestamp? ?? Timestamp.now();
  static Stations _parseStations(dynamic json) {
    if (json is String) {
      return Stations(id: '', name: '');
    } else if (json is Map<String, dynamic>) {
      return Stations.fromJson(json);
    } else {
      return Stations(id: '', name: '');
    }
  }
  Map<String, Object> toJson() {
    return {
      'id': id,
      'arrival_station_id': arrival_station_id.toJson(),
      'arrival_time': arrival_time,
      'departure_station_id': departure_station_id.toJson(),
      'departure_time': departure_time,
    };
  }
  Routes copyWith({
    String? id,
    Stations? arrival_station_id,
    Timestamp? arrival_time,
    Stations? departure_station_id,
    Timestamp? departure_time,
  }) {
    return Routes(
        id: id ?? this.id,
        arrival_station_id: arrival_station_id ?? this.arrival_station_id,
        arrival_time: arrival_time ?? this.arrival_time,
        departure_station_id: departure_station_id ?? this.departure_station_id,
        departure_time: departure_time ?? this.departure_time);
  }
}

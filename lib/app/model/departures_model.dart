import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/bus_model.dart';
import 'package:flutter_admin/app/model/bustype_model.dart';
import 'package:flutter_admin/app/model/routes_model.dart';
import 'package:flutter_admin/app/model/stations_model.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';

class Departures {
  String id;
  Buses bus_id;
  Routes route_id;

  Departures({
    required this.id,
    required this.bus_id,
    required this.route_id,
  });

  Departures.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String? ?? '',
        bus_id = json['bus_id'] != null
            ? Buses(
                id: json['bus_id']['id'] as String? ?? '',
                name: json['bus_id']['name'] as String? ?? '',
                bus_type_id:
                    Bustype(name: json['bus_id']['bustype'] as String? ?? ''),
                carnamber: json['bus_id']['carnamber'] as String? ?? '',
                capacity: json['bus_id']['capacity'] is String
                    ? int.tryParse(json['bus_id']['capacity']) ?? 0
                    : json['bus_id']['capacity'] ?? 0,
                capacityVip: json['bus_id']['capacityVip'] is String
                    ? int.tryParse(json['bus_id']['capacityVip']) ?? 0
                    : json['bus_id']['capacityVip'] ?? 0,
                ticketId: (json['bus_id']['ticket'] as List<dynamic>?)
                        ?.whereType<Map<String, dynamic>>()
                        ?.map<Tickets>((e) => Tickets.fromJson(e))
                        .toList() ??
                    [],
              )
            : Buses(
                id: '',
                name: '',
                bus_type_id: Bustype(name: ''),
                carnamber: '',
                capacity: 0,
                capacityVip: 0,
                ticketId: [],
              ),
        route_id = json['route'] != null
            ? Routes(
                id: json['route']['id'] as String? ?? '',
                arrival_station_id: Stations(
                  id: json['route']['arrival_station_id'] as String? ?? '',
// Default name is empty string
                  name: '',
                ),
                arrival_time:
                    Timestamp.now(), // Set arrival_time to current time
                departure_station_id: Stations(
                  id: json['route']['departure_station_id'] as String? ?? '',
// Default name is empty string
                  name: '',
                ),
                departure_time:
                    Timestamp.now(), // Set departure_time to current time
              )
            : json['route_id'] != null
                ? Routes(
                    id: json['route_id']['id'] as String? ?? '',
                    arrival_station_id: Stations(
                      id: json['route_id']['arrival_station_id']['id']
                              as String? ??
                          '',
// Default name is empty string
                      name: '',
                    ),
                    arrival_time:
                        Timestamp.now(), // Set arrival_time to current time
                    departure_station_id: Stations(
                      id: json['route_id']['departure_station_id']['id']
                              as String? ??
                          '',
// Default name is empty string
                      name: '',
                    ),
                    departure_time:
                        Timestamp.now(), // Set departure_time to current time
                  )
                : Routes(
                    id: '',
                    arrival_station_id: Stations(id: '', name: ''),
                    arrival_time:
                        Timestamp.now(), // Set arrival_time to current time
                    departure_station_id: Stations(id: '', name: ''),
                    departure_time:
                        Timestamp.now(), // Set departure_time to current time
                  );

  // Static method to create Departures instance from JSON
  static Future<Departures> fromJsonWithStationNames(
      Map<String, dynamic> json) async {
    // Fetch station names asynchronously
    String arrivalStationName =
        await fetchStationName(json['route_id']['arrival_station_id']);
    String departureStationName =
        await fetchStationName(json['route_id']['departure_station_id']);

    // Create Departures instance with station names
    return Departures.fromJson({
      ...json,
      'route': {
        ...json['route'],
        'arrival_station_id': {
          ...json['route']['arrival_station_id'],
          'name': arrivalStationName,
        },
        'departure_station_id': {
          ...json['route']['departure_station_id'],
          'name': departureStationName,
        },
      },
    });
  }

  // Static method to fetch station name from Firestore
  static Future<String> fetchStationName(String stationId) async {
    DocumentSnapshot stationSnapshot = await FirebaseFirestore.instance
        .collection('Stations')
        .doc(stationId)
        .get();
    return stationSnapshot.exists ? stationSnapshot.get('name') : '';
  }

  Departures copyWith({
    String? id,
    Buses? bus_id,
    Routes? route_id,
  }) {
    return Departures(
      id: id ?? this.id,
      bus_id: bus_id ?? this.bus_id,
      route_id: route_id ?? this.route_id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_id': bus_id.toJson(),
      'route_id': route_id.toJson(), // Change to toJson() method of Bustype
    };
  }
}

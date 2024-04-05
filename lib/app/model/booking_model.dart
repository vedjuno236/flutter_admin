// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_admin/app/model/passengers_model.dart';
// import 'package:flutter_admin/app/model/tickets_model.dart';

// class Booking {
//   String id;
//   Timestamp book_date;
//   String departure_id;
//   Timestamp expired_time;
//   Passengers passenger_id;
//   String seat;
//   String status;
//   Tickets ticket_id;
//   Timestamp time;
//   String user_id;

//   Booking({
//     required this.id,
//     required this.book_date,
//     required this.departure_id,
//     required this.expired_time,
//     required this.passenger_id,
//     required this.seat,
//     required this.status,
//     required this.ticket_id,
//     required this.time,
//     required this.user_id,
//   });

//   Booking.fromJson(Map<String, dynamic> json)
//       : id = json['id']! as String,
//         book_date = json['book_date']! as Timestamp,
//         departure_id = json['departure_id']! as String,
//         expired_time = json['expired_time']! as Timestamp,
//         passenger_id = json['passenger_id'] != null
//             ? Passengers(
//                 id: json['passenger_id']['id'] ?? '',
//                 name: json['passenger_id']['name'] ?? '',
//                 email: json['passenger_id']['email'] ?? '',
//                 dob: json['passenger_id']['dob'] ?? Timestamp.now(),
//                 idCard: json['passenger_id']['idCard'] ?? 0,
//                 idCardImageUrl: json['passenger_id']['idCardImageUrl'] ?? '',
//                 userId: json['passenger_id']['userId'] ?? '',
//                 phoneNumber: json['passenger_id']['phone_number'] ?? '',
//                 profileImageUrl: json['passenger_id']['profileImageUrl'] ?? '',
//               )
//             : Passengers(
//                 id: '',
//                 name: '',
//                 email: '',
//                 dob: Timestamp.now(),
//                 idCard: 0,
//                 idCardImageUrl: '',
//                 userId: '',
//                 phoneNumber: '',
//                 profileImageUrl: '',
//               ),
//         seat = json['seat'] as String? ?? '',
//         status = json['status'] as String? ?? '',
//         time = json['time']! as Timestamp,
//         user_id = json['user_id'] as String? ?? '',
//         ticket_id = json['ticket_id'] != null
//             ? Tickets(
//                 name: json['ticket_id']['name'],
//                 booking_price:
//                     (json['ticket_id']['booking_price'] as num?)?.toInt() ?? 0,
//                 price: (json['ticket_id']['price'] as num?)?.toInt() ?? 0,
//               )
//             : Tickets(
//                 name: '',
//                 booking_price: 0,
//                 price:
//                     0); // Provide default values for name, booking_price, and price if ticket_id is null

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'book_date': book_date,
//       'departure_id': departure_id,
//       'expired_time': expired_time,
//       'passenger_id': passenger_id.toJson(),
//       'seat': seat,
//       'status': status,
//       'ticket_id': ticket_id.toJson(),
//       'time': time,
//       'user_id': user_id,
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/bus_model.dart';
import 'package:flutter_admin/app/model/bustype_model.dart';
import 'package:flutter_admin/app/model/departures_model.dart';
import 'package:flutter_admin/app/model/passengers_model.dart';
import 'package:flutter_admin/app/model/routes_model.dart';
import 'package:flutter_admin/app/model/stations_model.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';

class Booking {
  final String id;
  final Timestamp book_date;
  final Departures departure_id;
  final Timestamp expired_time;
  final Passengers passenger_id;
  final String seat;
  final String status;
  final Tickets ticket_id;
  final Timestamp time;
  final String user_id;
  Booking({
    required this.id,
    required this.book_date,
    required this.departure_id,
    required this.expired_time,
    required this.passenger_id,
    required this.seat,
    required this.status,
    required this.ticket_id,
    required this.time,
    required this.user_id,
  });

  Booking.fromJson(Map<String, dynamic> json)
      : id = json['id']! as String? ?? '',
        book_date = json['book_date']! as Timestamp,
        expired_time = json['expired_time']! as Timestamp,
        passenger_id = json['passenger_id'] != null
            ? Passengers(
                id: json['passenger_id']['id'] as String? ?? '',
                name: json['passenger_id']['name'] as String? ?? '',
                email: json['passenger_id']['email'] as String? ?? '',
                dob: json['passenger_id']['dob'] ?? Timestamp.now(),
                idCard: json['passenger_id']['idCard'] as int? ?? 0,
                idCardImageUrl:
                    json['passenger_id']['idCardImageUrl'] as String? ?? '',
                userId: json['passenger_id']['userId'] as String? ?? '',
                phoneNumber:
                    json['passenger_id']['phone_number'] as String? ?? '',
                profileImageUrl:
                    json['passenger_id']['profileImageUrl'] as String? ?? '',
              )
            : Passengers(
                id: '',
                name: '',
                email: '',
                dob: Timestamp.now(),
                idCard: 0,
                idCardImageUrl: '',
                userId: '',
                phoneNumber: '',
                profileImageUrl: '',
              ),
        seat = json['seat'] as String? ?? '',
        status = json['status'] as String? ?? '',
        time = json['time']! as Timestamp,
        user_id = json['user_id'] as String? ?? '',
        ticket_id = json['ticket_id'] != null
            ? Tickets(
                name: json['ticket_id']['name'] as String? ??'',
                booking_price:
                    (json['ticket_id']['booking_price'] as num?)?.toInt() ?? 0,
                price: (json['ticket_id']['price'] as num?)?.toInt() ?? 0,
              )
            : Tickets(name: '', booking_price: 0, price: 0),
        departure_id = json['departure_id'] != null
            ? Departures(
                id: json['departure_id']['id'] as String? ?? '',
                bus_id: Buses(
                  id: json['departure_id']['bus_id']['id'] as String? ?? '',
                  name: json['departure_id']['bus_id']['name'] as String? ?? '',
                  bus_type_id:
                      json['departure_id']['bus_id']['bus_type_id'] != null
                          ? Bustype(
                              name: json['departure_id']['bus_id']
                                  ['bus_type_id'] as String)
                          : Bustype(name: ''),
                  carnamber:
                      json['departure_id']['bus_id']['carnamber'] as String? ??
                          '',
                  capacity: json['departure_id']['bus_id']['capacity'] is String
                      ? int.tryParse(
                              json['departure_id']['bus_id']['capacity']) ??
                          0
                      : json['departure_id']['bus_id']['capacity'] ?? 0,
                  capacityVip: json['departure_id']['bus_id']['capacityVip']
                          is String
                      ? int.tryParse(
                              json['departure_id']['bus_id']['capacityVip']) ??
                          0
                      : json['departure_id']['bus_id']['capacityVip'] ?? 0,
                  ticketId: (json['departure_id']['bus_id']['ticketId']
                              as List<dynamic>?)
                          ?.whereType<Map<String, dynamic>>()
                          ?.map<Tickets>((e) =>
                              Tickets.fromJson(e as Map<String, dynamic>))
                          .toList() ??
                      [],
                ),
                route_id: json['departure_id']['route_id'] != null
                    ? Routes(
                        id: json['departure_id']['route_id']['id'] as String? ??
                            '',
                        arrival_station_id: Stations.fromJson(
                            json['departure_id']['route_id']
                                ['arrival_station_id']),
                        arrival_time: json['departure_id']['route_id']
                                    ['arrival_time'] !=
                                null
                            ? (json['departure_id']['route_id']['arrival_time']
                                as Timestamp)
                            : Timestamp.now(),
                        departure_station_id: Stations.fromJson(
                            json['departure_id']['route_id']
                                ['departure_station_id']),
                        departure_time: json['departure_id']['route_id']
                                    ['departure_time'] !=
                                null
                            ? (json['departure_id']['route_id']
                                ['departure_time'] as Timestamp)
                            : Timestamp.now(),
                      )
                    : Routes(
                        id: '',
                        arrival_station_id: Stations(id: '', name: ''),
                        arrival_time: Timestamp.now(),
                        departure_station_id: Stations(id: '', name: ''),
                        departure_time: Timestamp.now(),
                      ),
              )
            : Departures(
                id: '',
                bus_id: Buses(
                  id: '',
                  name: '',
                  bus_type_id: Bustype(name: ''),
                  carnamber: '',
                  capacity: 0,
                  capacityVip: 0,
                  ticketId: [],
                ),
                route_id: Routes(
                  id: '',
                  arrival_station_id: Stations(id: '', name: ''),
                  arrival_time: Timestamp.now(),
                  departure_station_id: Stations(id: '', name: ''),
                  departure_time: Timestamp.now(),
                ),
              );

  static Future<Departures> fromJsonWithStationNames(
      Map<String, dynamic> json) async {
    String arrivalStationName =
        await fetchStationName(json['route']['arrival_station_id'] as String);
    String departureStationName =
        await fetchStationName(json['route']['departure_station_id'] as String);

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_date': book_date,
      'departure_id': departure_id
          .toJson(), // Assuming toJson() returns a Map<String, dynamic>
      'expired_time': expired_time,
      'passenger_id': passenger_id.toJson(),
      'seat': seat,
      'status': status,
      'ticket_id': ticket_id.toJson(),
      'time': time,
      'user_id': user_id,
    };
  }
}

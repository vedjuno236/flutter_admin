
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
            ? Passengers.fromJson(json['passenger_id'])
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
            ? Tickets.fromJson(json['ticket_id'])
            : Tickets(name: '', booking_price: 0, price: 0),
        departure_id = json['departure_id'] != null
            ? Departures.fromJson(json['departure_id'])
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

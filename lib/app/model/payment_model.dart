import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/booking_model.dart';
import 'package:flutter_admin/app/model/bus_model.dart';
import 'package:flutter_admin/app/model/bustype_model.dart';
import 'package:flutter_admin/app/model/departures_model.dart';
import 'package:flutter_admin/app/model/passengers_model.dart';
import 'package:flutter_admin/app/model/routes_model.dart';
import 'package:flutter_admin/app/model/stations_model.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';

class Payment {
  String id;
  List<Booking> booking_id;
  String description;
  Timestamp pay_date;
  String payment_method;
  int total;
  String user_id;

  Payment({
    required this.id,
    required this.booking_id,
    required this.description,
    required this.pay_date,
    required this.payment_method,
    required this.total,
    required this.user_id,
  });

  Payment.fromJson(Map<String, dynamic>? json)
      : description = json?['description'] as String? ?? '',
        pay_date = (json?['pay_date'] as Timestamp?) ?? Timestamp.now(),
        payment_method = json?['payment_method'] as String? ?? '',
        total = int.parse(json?['total'] as String? ?? '0'),
        user_id = json?['user_id'] as String? ?? '',
        id = json?['id'] as String? ?? '',
        booking_id =
            (json?['booking_id'] as List<dynamic>?)?.map((bookingJson) {
                 
                  return Booking.fromJson(bookingJson as Map<String, dynamic>);
                }).toList() ??
                [
                  Booking(
                      id:json!['id']! as String? ?? '',
                      book_date: json['book_date']! as Timestamp,
                      expired_time: json['expired_time']! as Timestamp,
                    
                      seat:json['seat'] as String? ?? '',
                      status:json['status'] as String? ?? '',
                  
                      time: json['time']! as Timestamp,
                      user_id: json['user_id'] as String? ?? '',
                      ticket_id:  json['ticket_id'] != null
            ? Tickets.fromJson(json['ticket_id'])
            : Tickets(name: '', booking_price: 0, price: 0),
                      departure_id:json['departure_id'] != null
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
                
              ),
                      passenger_id: json['passenger_id'] != null
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
                      )
                ];
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
    
       'booking_id': booking_id.map((booking) => booking.toJson()).toList(),
      'description': description,
      'pay_date': pay_date,
      'payment_method': payment_method,
      'total': total.toString(),
      'user_id': user_id,
      'id': id,
    };
  }
}


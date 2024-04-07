import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_admin/app/model/booking_model.dart';

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
      booking_id = (json?['booking_id'] as List<dynamic>?)
              ?.map((bookingJson) {
                print('bookingJson: $bookingJson');
                return Booking.fromJson(bookingJson as Map<String, dynamic>);
              })
              .toList() ?? [];

  Map<String, dynamic> toJson() {
    return {
      'booking_id': booking_id,
      'description': description,
      'pay_date': pay_date,
      'payment_method': payment_method,
      'total': total.toString(), 
      'user_id': user_id,
      'id': id,
    };
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_admin/app/model/booking_model.dart';
// import 'package:flutter_admin/app/model/departures_model.dart';

// class Payment {
//   String id;
//   List<Booking> booking_id;
//   String description;
//   Timestamp payDate;
//   String paymentMethod;
//   int total;
//   String userId;

//   Payment({
//     required this.id,
//     required this.booking_id,
//     required this.description,
//     required this.payDate,
//     required this.paymentMethod,
//     required this.total,
//     required this.userId,
//   });

//   Payment.fromJson(Map<String, dynamic> json)
//       : id = json['id'] as String? ?? '',
//         booking_id = (json['booking_id'] as List<dynamic>?)
//             ?.map((bookingJson) => Booking.fromJson(bookingJson as Map<String, dynamic>))
//             .toList() ?? [],
//         description = json['description'] as String? ?? '',
//         payDate = json['pay_date'] as Timestamp? ?? Timestamp.now(),
//         paymentMethod = json['payment_method'] as String? ?? '',
//         total = json['total'] as int? ?? 0,
//         userId = json['user_id'] as String? ?? '';

//   static Future<Departures> fromJsonWithStationNames(
//       Map<String, dynamic> json) async {
//     String arrivalStationName =
//         await fetchStationName(json['route']['arrival_station_id'] as String);
//     String departureStationName =
//         await fetchStationName(json['route']['departure_station_id'] as String);

//     return Departures.fromJson({
//       'id': json['departure_id']['id'],
//       'bus_id': {
//         'id': json['departure_id']['bus_id']['id'],
//         'name': json['departure_id']['bus_id']['name'],
//         'bus_type_id': {'name': json['departure_id']['bus_id']['bus_type_id']['name']},
//         'carnamber': json['departure_id']['bus_id']['carnamber'],
//         'capacity': json['departure_id']['bus_id']['capacity'],
//         'capacityVip': json['departure_id']['bus_id']['capacityVip'],
//         'ticketId': json['departure_id']['bus_id']['ticketId'],
//       },
//       'route_id': {
//         'id': json['departure_id']['route_id']['id'],
//         'arrival_station_id': {
//           'id': json['departure_id']['route_id']['arrival_station_id'],
//           'name': arrivalStationName,
//         },
//         'arrival_time': json['departure_id']['route_id']['arrival_time'],
//         'departure_station_id': {
//           'id': json['departure_id']['route_id']['departure_station_id'],
//           'name': departureStationName,
//         },
//         'departure_time': json['departure_id']['route_id']['departure_time'],
//       },
//     });
//   }

//   // Static method to fetch station name from Firestore
//   static Future<String> fetchStationName(String stationId) async {
//     DocumentSnapshot stationSnapshot = await FirebaseFirestore.instance
//         .collection('Stations')
//         .doc(stationId)
//         .get();
//     return stationSnapshot.exists ? stationSnapshot.get('name') : '';
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'booking_id': booking_id.map((booking) => booking.toJson()).toList(),
//       'description': description,
//       'pay_date': payDate,
//       'payment_method': paymentMethod,
//       'total': total.toString(),
//       'user_id': userId,
//       'id': id,
//     };
//   }
// }

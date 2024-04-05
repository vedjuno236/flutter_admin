// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_admin/app/model/booking_model.dart';

// class Payment {
//   String id;
//   String description;
//   Timestamp pay_date;
//   String payment_method;
//   double total;
//   String user_id;
//   List<Booking> booking_id;

//   Payment({
//     required this.id,

//     required this.booking_id,
//     required this.description,
//     required this.pay_date,
//     required this.payment_method,
//     required this.total,
//     required this.user_id,
//   });

// Payment.fromJson(Map<String, dynamic>? json)
//     : id = json?['id'] as String? ?? '',
//       description = json?['description'] as String? ?? '',
//       pay_date = json?['pay_date'] as Timestamp? ?? Timestamp.now(),
//       payment_method = json?['payment_method'] as String? ?? '',
//       total = (json?['total'] is num) ? (json?['total'] as num).toDouble() : 0.0,
//       user_id = json?['user_id'] as String? ?? '',
//       booking_id = (json?['booking_id'] as List<dynamic>?)
//               ?.map<Booking>((e) => Booking.fromJson(e))
//               .toList() ?? [];
//   Map<String, dynamic> toJson() {
//     return {
//       'booking_id': booking_id.map((booking) => booking.toJson()).toList(),
//       'description': description,
//       'pay_date': pay_date,
//       'payment_method': payment_method,
//       'total': total.toString(),
//       'user_id': user_id,
//       'id': id,

//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  String id;
  List<String> booking_id;
  String description;
  Timestamp pay_date;
  String payment_method;
  int total; // เปลี่ยนจาก String เป็น double
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

  Payment.fromJson(Map<String, dynamic> json)
      : booking_id = (json['booking_id'] as List<dynamic>?)
                ?.map((id) => id as String)
                .toList() ??
            [],
        description = json['description'] as String? ?? '',
        pay_date = json['pay_date'] as Timestamp? ?? Timestamp.now(),
        payment_method = json['payment_method'] as String? ?? '',
        total = int.parse(
            json['total'] as String? ?? '0'), // แปลงจาก String เป็น double
        user_id = json['user_id'] as String? ?? '',
        id = json['id'] as String? ?? '';


  Map<String, dynamic> toJson() {
    return {
      'booking_id': booking_id,
      'description': description,
      'pay_date': pay_date,
      'payment_method': payment_method,
      'total': total.toString(), // แปลง double เป็น String ก่อนเก็บใน Firebase
      'user_id': user_id,
      'id': id,

    };
  }
}

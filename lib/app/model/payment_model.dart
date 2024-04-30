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
        booking_id = (json?['booking_id'] as List<Map<String, dynamic>>?)
                ?.map((bookingJson) {
              return Booking.fromJson(bookingJson as Map<String, dynamic>);
            }).toList() ??
            [];

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

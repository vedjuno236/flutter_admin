import 'package:cloud_firestore/cloud_firestore.dart';

class Tickets {
  String name;
  double booking_price; // Changed to double
  double price; // Changed to double

  Tickets({
    required this.name,
    required this.booking_price,
    required this.price,
  });
  Tickets.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'] as String? ?? '',
          booking_price: (json['booking_price'] as num?)?.toDouble() ?? 0.0,
          price: (json['price'] as num?)?.toDouble() ?? 0.0,
        );

  Tickets copyWith({
    String? name,
    double? booking_price, // Changed to double
    double? price, // Changed to double
  }) {
    return Tickets(
      name: name ?? this.name,
      booking_price: booking_price ?? this.booking_price,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'booking_price': booking_price,
      'price': price,
    };
  }
}

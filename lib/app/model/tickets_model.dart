class Tickets {
  String name;
  int booking_price;
  int price;
  Tickets({
    required this.name,
    required this.booking_price,
    required this.price,
  });
  Tickets.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name'] as String? ?? '',
          booking_price: (json['booking_price'] as num?)?.toInt() ?? 0,
          price: (json['price'] as num?)?.toInt() ?? 0,
        );

  Tickets copyWith({
    String? name,
    int? booking_price,
    int? price,
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

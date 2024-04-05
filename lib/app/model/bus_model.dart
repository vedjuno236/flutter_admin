import 'package:flutter_admin/app/model/bustype_model.dart';
import 'package:flutter_admin/app/model/tickets_model.dart';

class Buses {
  String id;
  String name;
  Bustype bus_type_id;
  String carnamber;
  int capacity;
  int capacityVip;
  List<Tickets> ticketId;
  String get bustypeName => bus_type_id.name;
  Buses({
    required this.id,
    required this.name,
    required this.bus_type_id, // corrected parameter name
    required this.carnamber,
    required this.capacity,
    required this.capacityVip,
    required this.ticketId,
  });
 Buses.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String? ?? '', // Include parsing of the id field
      name = json['name'] as String? ?? '',
      bus_type_id = json['bus_type_id'] != null
          ? Bustype.fromJson(json['bus_type_id'] as Map<String, dynamic>)
          : Bustype(name: ''),
      carnamber = json['carnamber'] as String? ?? '',
      capacity = (json['capacity'] as num?)?.toInt() ?? 0,
      capacityVip = (json['capacity_vip'] as num?)?.toInt() ?? 0,
      ticketId = (json['ticket'] as List<dynamic>?)
              ?.whereType<
                  Map<String, dynamic>>() // Filter out non-map elements
              ?.map<Tickets>((e) => Tickets.fromJson(e))
              .toList() ??
          [];
Buses copyWith({
  String? name,
  Bustype? bus_type_id,
  String? carnamber,
  int? capacity,
  int? capacity_vip,
  List<Tickets>? ticketId,
}) {
  return Buses(
    id: this.id, // Include id in the copy
    name: name ?? this.name,
    bus_type_id: bus_type_id ?? this.bus_type_id,
    carnamber: carnamber ?? this.carnamber,
    capacity: capacity ?? this.capacity,
    capacityVip: capacity_vip ?? this.capacityVip,
    ticketId: ticketId ?? this.ticketId,
  );
}


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'bus_type_id': bus_type_id.toJson(), // Change to toJson() method of Bustype
      'carnamber': carnamber,
      'capacity': capacity,
      'capacity_vip': capacityVip,
      'ticket_id': ticketId.map((ticket) => ticket.toJson()).toList(),
    };
  }
}


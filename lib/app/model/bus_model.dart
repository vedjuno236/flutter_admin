import 'package:cloud_firestore/cloud_firestore.dart';

class Buses {
  String nume;
  String busTypeId; 
  String carnamber;
  double capacity;
  double capacityVip; 
  List<String> ticketId; 

  Buses({
    required this.nume,
    required this.capacity,
    required this.busTypeId,
    required this.carnamber,
    required this.capacityVip,
    required this.ticketId,
  });

Buses.fromJson(Map<String, dynamic> json)
    : nume = json['name'] as String? ?? '', 
      busTypeId = json['bus_type_id'] as String? ?? '', 
      carnamber = json['car_namber'] as String? ?? '', 
      capacity = (json['capacity'] as num?)?.toDouble() ?? 0.0, 
      capacityVip = (json['capacity_vip'] as num?)?.toDouble() ?? 0.0, 
      ticketId = (json['ticket_id'] as List<dynamic>?)?.map<String>((e) => e.toString()).toList() ?? []; 


  Map<String, dynamic> toJson() {
    return {
      'name': nume,
      'capacity': capacity,
      'bus_type_id': busTypeId,
      'car_namber': carnamber,
      'capacit_vip': capacityVip,
      'ticket_id': ticketId,
    };
  }
  
}

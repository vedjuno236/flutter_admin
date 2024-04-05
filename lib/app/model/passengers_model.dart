import 'package:cloud_firestore/cloud_firestore.dart';

class Passengers {
  String id;
  String email;
  Timestamp dob;
  int idCard;
  String idCardImageUrl;
  String name;
  String userId;
  String phoneNumber;
  String profileImageUrl;

  Passengers({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.idCard,
    required this.idCardImageUrl,
    required this.userId,
    required this.phoneNumber, // Added required parameter
    required this.profileImageUrl, // Added required parameter
  });

Passengers.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String? ?? '',
        name = json['name'] as String? ?? '',
        email = json['email'] as String,
        dob = json['dob'] as Timestamp? ?? Timestamp.now(),
        idCard = json['id_card'] as int? ?? 0,
        idCardImageUrl = json['id_card_image_url'] as String? ?? '',
        userId = json['user_id'] as String,
        phoneNumber = json['phone_number'] as String,
        profileImageUrl = json['profile_image_url'] as String? ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'name': name,
      'email': email,
      'dob': dob,
      'id_card': idCard,
      'id_card_image_url': idCardImageUrl.toString(),
      'user_id': userId,
      'phone_number': phoneNumber, // Added parameter
      'profile_image_url': profileImageUrl.toString(), // Added parameter
    };
  }
}

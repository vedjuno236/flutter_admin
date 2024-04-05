class Stations {
  String id;
  String name;

  Stations({
    required this.id,
    required this.name,
  });

 Stations.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String? ?? '', // Provide default value if 'id' is null
      name = json['name'] as String? ?? ''; // Provide default value if 'name' is null

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
  
    Stations copyWith({
    String? id,
    String? name,
  }) {
    return Stations(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

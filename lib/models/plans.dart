import 'package:postgres/postgres.dart';

class Plans {
  final int id;
  final String name;
  final String description;
  final int price;
  final String icon;
  final DateTime created_at;
  final DateTime updated_at;

  Plans({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.created_at,
    required this.updated_at,
  });

  factory Plans.fromPostgres(PostgreSQLResultRow row) {
    return Plans(
      id: row[0],
      name: row[1],
      description: row[2],
      price: row[3],
      icon: row[4],
      created_at: row[5],
      updated_at: row[6],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'icon': icon,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Plans{id: $id, name: $name, description: $description, price: $price, icon: $icon, created_at: $created_at, updated_at: $updated_at}';
  }
}

import 'package:postgres/postgres.dart';

class Transactions {
  final int id;
  final int subscriptionId;
  final String method;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transactions({
    required this.id,
    required this.subscriptionId,
    required this.method,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });


  factory Transactions.fromPostgres(PostgreSQLResultRow result) {
    return Transactions(
        id: result[0],
        subscriptionId: result[1],
        method: result[2],
        status: result[3],
        createdAt: result[4],
        updatedAt: result[5]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_id': subscriptionId,
      'method': method,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Transactions(id: $id, subscriptionId: $subscriptionId, method: $method, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

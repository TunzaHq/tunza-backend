class Transactions {
  final int id;
  final int subscriptionId;
  final String method;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  Transactions({
    required this.id,
    required this.subscriptionId,
    required this.method,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  factory Transactions.fromPostgres(List result) {
    return Transactions(
        id: result[0],
        subscriptionId: result[1],
        method: result[2],
        createdAt: result[3],
        updatedAt: result[4],
        status: result[5]);
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

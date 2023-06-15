
class Subscriptions {
  final int id;
  final int planId;
  final int userId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subscriptions({
    required this.id,
    required this.planId,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subscriptions.fromPostgres(List result) {
    return Subscriptions(
        id: result[0],
        planId: result[1],
        userId: result[2],
        status: result[3],
        createdAt: result[4],
        updatedAt: result[5]);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Subscriptions(id: $id, planId: $planId, userId: $userId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

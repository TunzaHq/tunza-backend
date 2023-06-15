class Claims {
  final int id;
  final String description;
  final int subscriptionId;
  final String location;
  final int amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final int userId;

  Claims(
      {required this.id,
      required this.description,
      required this.subscriptionId,
      required this.location,
      required this.amount,
      required this.createdAt,
      required this.updatedAt,
      required this.status,
      required this.userId});

  factory Claims.fromPostgres(List row) => Claims(
        id: row[0],
        description: row[1],
        subscriptionId: row[2],
        location: row[3],
        amount: row[4],
        createdAt: row[5],
        updatedAt: row[6],
        status: row[7],
        userId: row[8] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "subscriptionId": subscriptionId,
        "location": location,
        "amount": amount,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "status": status
      };

  @override
  String toString() {
    return 'Claims{id: $id, description: $description, subscriptionId: $subscriptionId, location: $location, amount: $amount, createdAt: $createdAt, updatedAt: $updatedAt, status: $status}';
  }
}

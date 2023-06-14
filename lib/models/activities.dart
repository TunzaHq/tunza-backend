import 'package:postgres/postgres.dart';

class Acitivities {
  final int id;
  final int user_id;
  final String userAgent;
  final String ipAdress;
  final String location;
  final String activityType;
  final String activity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Acitivities({
    required this.id,
    required this.user_id,
    required this.userAgent,
    required this.ipAdress,
    required this.location,
    required this.activityType,
    required this.activity,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Acitivities.fromPostgres(PostgreSQLResultRow row) => Acitivities(
        id: row[0],
        user_id: row[1],
        userAgent: row[2] ?? "",
        ipAdress: row[3] ?? "",
        location: row[4] ?? "",
        activityType: row[5],
        activity: row[6],
        createdAt: row[7],
        updatedAt: row[8],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "userAgent": userAgent,
        "ipAdress": ipAdress,
        "location": location,
        "activityType": activityType,
        "activity": activity,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };

  @override
  String toString() {
    return 'Acitivities(id: $id, user_id: $user_id, userAgent: $userAgent, ipAdress: $ipAdress, location: $location, activityType: $activityType, activity: $activity, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

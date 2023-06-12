import 'package:postgres/postgres.dart';

class Media {
  final int id;
  final String type;
  final String fileName;
  final int fileSize;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? url;

  Media({
    required this.id,
    required this.type,
    required this.fileName,
    required this.fileSize,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
  });

  factory Media.fromPostgres(PostgreSQLResultRow row) => Media(
        id: row[0],
        type: row[1],
        fileName: row[2],
        fileSize: row[3],
        userId: row[4],
        createdAt: row[5],
        updatedAt: row[6],
        url: row[7],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "file_name": fileName,
        "file_size": fileSize,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "url": url,
      };
  

  @override
  String toString() {
    return 'Media(id: $id, type: $type, fileName: $fileName, fileSize: $fileSize, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

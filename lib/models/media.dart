
class Media {
  final int id;
  final String fileName;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? url;
  final String type;

  Media({
    required this.id,
    required this.type,
    required this.fileName,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
  });

  factory Media.fromPostgres(List row) => Media(
        id: row[0],
        fileName: row[1],
        userId: row[2],
        createdAt: row[3],
        updatedAt: row[4],
        url: row[5],
        type: row[6],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "file_name": fileName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "url": url,
      };

  @override
  String toString() {
    return 'Media(id: $id, type: $type, fileName: $fileName, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class User {
  final int id;
  final String? full_name;
  final String? avatar;
  final String? email;
  final String? location;
  final DateTime? createdAt;
  final String? role;
  final String? password;

  User({
    required this.id,
    this.full_name,
    this.avatar,
    this.email,
    this.location,
    this.createdAt,
    this.role,
    this.password,
  });

  factory User.fromPostgres(List<dynamic> result) => User(
        id: result[0],
        full_name: result[1],
        avatar: result[3],
        email: result[2],
        location: result[4],
        createdAt: result[7],
        role: result[6],
        password: result[5],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': full_name,
      'avatar': avatar,
      'email': email,
      'role': role,
      'location': location,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'User{id: $id, full_name: $full_name, avatar: $avatar, email: $email, location: $location, createdAt: $createdAt}';
  }
}

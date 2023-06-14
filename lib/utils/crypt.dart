import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:postgres/postgres.dart';
import 'package:tunza/models/user.dart';
import 'package:zero/utils/meta.dart';

String token(PostgreSQLResult result) {
  final user = User.fromPostgres(result.first);

  final jwt = JWT(
      {
        'id': user.id,
        'name': user.full_name,
        'email': user.email,
        'role': user.role,
      },
      issuer: 'tunza',
      subject: 'auth',
      header: {
        'typ': 'JWT',
      });

  return jwt.sign(SecretKey(
    meta.env['JWT_SECRET']!,
  ));
}

JWT verify(String token) =>
    JWT.verify(token, SecretKey(meta.env['JWT_SECRET']!));

String hashPassword(String password) {
  var bytes = utf8.encode(password + meta.env['SALT']!);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

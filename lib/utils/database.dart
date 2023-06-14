import 'package:postgres/postgres.dart';
import 'package:zero/zero.dart';

class Database {
  static final Database _instance = Database._internal();
  factory Database() => _instance;
  Database._internal();

  PostgreSQLConnection? conn;

  Future<void> connect() async {
    print("Connecting to database...");
    conn = PostgreSQLConnection(
        meta.env['HOST'], int.parse(meta.env['PORT']), meta.env['DB'],
        username: meta.env['USER'], password: meta.env['PASS']);
    await conn!.open();
  }

  Future<void> disconnect() async {
    await conn!.close();
  }

  
}

mixin DbMixin {
  final Database _db = Database();
  PostgreSQLConnection? get conn => _db.conn;
}

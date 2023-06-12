import 'package:postgres/postgres.dart';
import 'package:tunza/utils/crypt.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class AuthController extends Controller with DbMixin {
  final Request request;

  AuthController(this.request) : super(request);

  @Path("/login", method: "POST")
  @Body([
    Field("email", isRequired: true, type: String),
    Field("password", isRequired: true, type: String),
  ])
  Future<Response> login() async {
    final body = request.body!;

    final result = await conn?.query(
      'SELECT * FROM users WHERE email = @email AND password = @password',
      substitutionValues: {
        'email': body['email'],
        'password': hashPassword(body['password'])
      },
    );

    if (result?.isEmpty ?? true) {
      return Response.unauthorized({
        'message': 'Invalid credentials',
      });
    }

    return Response.ok({
      'token': token(result!),
    });
  }

  @Path("/register", method: "POST")
  @Body([
    Field("full_name", isRequired: true, type: String),
    Field("email", isRequired: true, type: String),
    Field("password", isRequired: true, type: String),
  ])
  Future<Response> register() async {
    try {
      final body = request.body!;

      await conn?.query(
        'INSERT INTO users (full_name, avatar, email, location, password, role)'
        'VALUES (@full_name,@avatar, @email, null,  @password, @role)',
        substitutionValues: {
          'full_name': body['full_name'],
          'avatar': "",
          'email': body['email'],
          'password': hashPassword(body['password']),
          'role': 'user',
        },
      );

      return Response.ok(
        {...body},
      );
    } catch (e) {
      switch (e) {
        case PostgreSQLException:
          return Response.badRequest({
            'message': 'Email already exists',
          });
        default:
          return Response.internalServerError({
            'message': 'Something went wrong',
          });
      }
    }
  }
}

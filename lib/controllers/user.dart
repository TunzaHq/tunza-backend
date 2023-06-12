import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/user.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class UserController extends Controller with DbMixin {
  final Request request;
  UserController(this.request) : super(request);

  @Path("/me")
  @Auth()
  Future<Response> me() async {
    try {
      final user = await conn
          ?.query('SELECT * FROM users WHERE id = @id', substitutionValues: {
        'id': request.headers?['id'],
      }).then((value) {
        final row = value.sublist(0, value.length);
        return User.fromPostgres(row);
      });

      return Response.ok(user?.toJson());
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  @Path("/me", method: "PUT")
  @Auth()
  @Body([
    Field("avatar"),
    Field("location"),
  ])
  Future<Response> updateCurrentUser() async {
    try {
      final body = request.body!;
      final result = await conn?.query(
        'SELECT * FROM users WHERE id = @id',
        substitutionValues: {
          'id': request.headers?['id'],
        },
      ).then((value) {
        return User.fromPostgres(value.sublist(0, value.length));
      });

      await conn?.query("""
        UPDATE users SET avatar = @avatar,location = @location WHERE id = @id
      """, substitutionValues: {
        'avatar': body['avatar'] ?? result?.avatar,
        'location': body['location'] ?? result?.location,
        'id': result?.id,
      });

      return Response.ok({...body});
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  @Path("/")
  @Auth()
  Future<Response> getAllUsers() async {
    try {
      final users = await conn?.query('SELECT * FROM users').then((value) {
        final rows = value.sublist(0, value.length);
        return rows.map((e) => User.fromPostgres(e)).toList();
      });

      return Response.ok(users?.map((e) => e.toJson()).toList());
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  @Path("/:id")
  @Auth()
  @Param(["id"])
  Future<Response> getUser() async {
    final String? id = request.params?["id"];
    try {
      final user = await conn
          ?.query('SELECT * FROM users WHERE id = @id', substitutionValues: {
        'id': id,
      }).then((value) {
        final row = value.sublist(0, value.length);
        return User.fromPostgres(row);
      });

      return Response.ok(user?.toJson());
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  @Path("/:id", method: "PUT")
  @Auth()
  @Param(["id"])
  @Body([
    Field("avatar"),
    Field("location"),
    Field("email"),
  ])
  Future<Response> updateUser() async {
    final String? id = request.params?["id"];
    final body = request.body!;

    final result = await conn?.query(
      'SELECT * FROM users WHERE id = @id',
      substitutionValues: {
        'id': id,
      },
    ).then((value) {
      if (value.isEmpty) {
        Response.notFound({"message": "No user found"});
      }
      return User.fromPostgres(value.sublist(0, value.length));
    });

    await conn?.query("""
        UPDATE users SET avatar = @avatar,location = @location,email = @email,
        password = @password WHERE id = @id
      """, substitutionValues: {
      'avatar': body['avatar'] ?? result?.avatar,
      'location': body['location'] ?? result?.location,
      'email': body['email'] ?? result?.email,
      'id': result?.id,
    });

    return Response.ok({...body});
  }

  @Path("/:id", method: "DELETE")
  @Auth()
  @Param(["id"])
  Future<Response> deleteUser() async {
    try {
      final String? id = request.params?["id"];

      await conn?.query("""
        DELETE FROM users WHERE id = @id
      """, substitutionValues: {
        'id': id,
      });

      return Response.ok({
        'message': 'User deleted successfully',
      });
    } catch (e) {
      return Response.internalServerError({
        'message': "Error deleting user",
      });
    }
  }
}

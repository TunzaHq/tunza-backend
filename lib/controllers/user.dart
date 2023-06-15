import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/claims.dart';
import 'package:tunza/models/media.dart';
import 'package:tunza/models/plans.dart';
import 'package:tunza/models/question_answer.dart';
import 'package:tunza/models/subscriptions.dart';
import 'package:tunza/models/transactions.dart';
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
        return User.fromPostgres(row.first);
      });

      return Response.ok(user?.toJson());
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  @Path("/me", method: "PATCH")
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
        return User.fromPostgres(value.first);
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
  @Admin()
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
  @Admin()
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

  @Path("/:id", method: "PATCH")
  @Admin()
  @Param(["id"])
  @Body([
    Field("avatar"),
    Field("location"),
    Field("email"),
    Field("password"),
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
      return User.fromPostgres(value.first);
    });

    await conn?.query("""
        UPDATE users SET avatar = @avatar,location = @location,email = @email,
        password = @password WHERE id = @id
      """, substitutionValues: {
      'avatar': body['avatar'] ?? result?.avatar,
      'location': body['location'] ?? result?.location,
      'email': body['email'] ?? result?.email,
      'password': hashPassword(body['password'] ?? result?.password),
      'id': result?.id,
    });

    return Response.ok({...body});
  }

  @Path("/:id", method: "DELETE")
  @Admin()
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

  // User: {claims, media, covers, transactions, activities}
  // works only for Auth users

  // Claims

  /// Get all claims for a user
  ///
  /// Queries: `[status]`-> `pending`, `approved`, `rejected`
  @Path("/me/claims")
  @Auth()
  Future<Response> getClaims() async {
    try {
      final status = request.query?['status'];

      final claims = await conn?.query("""
        SELECT * FROM claims WHERE user_id = @id ${status != null ? 'AND status = @status' : ''}
      """, substitutionValues: {
        'id': request.headers?['id'],
      }).then((value) {
        final rows = value.sublist(0, value.length);
        return rows.map((e) => Claims.fromPostgres(e)).toList();
      });

      return Response.ok(claims?.map((e) => e.toJson()).toList());
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  /// Get a claim for a user
  ///
  /// Params: `id`
  @Path("/me/claims/:id")
  @Auth()
  @Param(["id"])
  Future<Response> getClaim() async {
    try {
      final id = request.params!["id"];

      print(id);

      final claim = await conn?.query(
          "SELECT * FROM claims where id=@id AND user_id=@user_id",
          substitutionValues: {
            "id": id,
            "user_id": request.headers?['id'],
          }).then((value) =>
          value.isNotEmpty ? Claims.fromPostgres(value.first) : null);

      if (claim == null) {
        return Response.notFound({"message": "Claim not found"});
      }

      final covers = await conn?.query("""
          SELECT * FROM subscriptions AS s INNER JOIN 
          plans ON s.plan_id = plans.id WHERE s.user_id = @userId
          """, substitutionValues: {
        "userId": request.headers?['id']
      }).then((value) => value.map((e) => {
            ...Subscriptions.fromPostgres(e.take(6).toList()).toJson(),
            "plan": Plans.fromPostgres(e.skip(6).toList()).toJson()
          }));

      final answers = await conn?.query("""
          SELECT * FROM answers INNER JOIN questions ON answers.question_id = questions.id WHERE answers.claim_id=@id
          """, substitutionValues: {
        "id": id
      }).then((value) => value.map((e) => {
            ...Answers.fromPostgres(e.take(6).toList()).toJson(),
            "question": Questions.fromPostgres(e.skip(6).toList()).toJson()
          }));

      return Response.ok({
        ...claim.toJson(),
        "answers": answers?.toList() ?? [],
        "covers": covers?.toList() ?? [],
      });
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  /// Get User Covers
  ///
  /// Queries: `[status]`-> `pending`, `approved`, `rejected`
  @Path("/me/covers")
  @Auth()
  Future<Response> getCovers() async {
    try {
      final status = request.query?['status'];

      final covers = await conn?.query("""
        SELECT * FROM subscriptions AS s INNER JOIN 
        plans ON s.plan_id = plans.id WHERE s.user_id = @userId ${status != null ? 'AND s.status = @status' : ''}
      """, substitutionValues: {
        "userId": request.headers?['id'],
        "status": status,
      }).then((value) => value.map((e) => {
            ...Subscriptions.fromPostgres(e.take(6).toList()).toJson(),
            "plan": Plans.fromPostgres(e.skip(6).toList()).toJson()
          }));

      return Response.ok(covers?.toList());
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  /// Get User Cover
  /// Params: `id`
  @Path("/me/covers/:id")
  @Auth()
  @Param(["id"])
  Future<Response> getCover() async {
    try {
      final id = request.params!["id"];

      final cover = await conn?.query("""
        SELECT * FROM subscriptions AS s INNER JOIN 
        plans ON s.plan_id = plans.id WHERE s.user_id = @userId AND s.id = @id
      """, substitutionValues: {
        "userId": request.headers?['id'],
        "id": id,
      }).then((value) => value.map((e) => {
            ...Subscriptions.fromPostgres(e.take(6).toList()).toJson(),
            "plan": Plans.fromPostgres(e.skip(6).toList()).toJson()
          }));

      if (cover == null) {
        return Response.notFound({"message": "Cover not found"});
      }

      print(cover.first);
      final claims = await conn?.query("""
          SELECT * FROM claims WHERE claims.subscription_id=@subId
          """, substitutionValues: {
        "subId": cover.first['id']
      }).then((value) => value.map((e) => Claims.fromPostgres(e).toJson()));

      return Response.ok({
        ...cover.first,
        "claims": claims?.toList() ?? [],
      });
    } catch (e) {
      return Response.internalServerError({
        'message': e.toString(),
      });
    }
  }

  // Media

  /// Get User Media
  ///
  /// Queries: `[type]`-> `ICON`, `PASSPORT`, `ID_FRONT`, `ID_BACK`, `OTHER`
  @Path("/me/media")
  @Auth()
  Future<Response> getMedia() async {
    try {
      final type = request.query?['type'];

      final media = await conn?.query("""
        SELECT * FROM media WHERE user_id = @userId ${type != null ? 'AND type = @type' : ''}
      """, substitutionValues: {
        "userId": request.headers?['id'],
        "type": type.toString().toUpperCase(),
      }).then((value) => value.map((e) => Media.fromPostgres(e).toJson()));

      return Response.ok(media?.toList());
    } catch (e) {
      return Response.badRequest({
        'message': "Invalid type",
      });
    }
  }

  // Transactions

  /// Get User Transactions
  ///
  /// Queries:
  ///
  /// `[status]`-> `pending`, `approved`, `rejected`
  ///
  /// `[method]`-> `card`, `bank`, `ussd`, `wallet`, `mpesa`
  ///
  /// `[op]` -> `and`, `or`: Default `and`
  @Path("/me/transactions")
  @Auth()
  Future<Response> getTransactions() async {
    try {
      final status = request.query?['status'];
      final method = request.query?['method'];
      final op = request.query?['op'] ?? 'and';

      final transactions = await conn?.query(
        """
        SELECT * FROM transactions AS t
        INNER JOIN subscriptions as s ON t.subscription_id = s.id
        WHERE s.user_id = @userId  ${status != null ? 'AND t.status = @status' : ''} 
        ${method != null ? '${op.toString().toUpperCase()} t.method = @method' : ''}
        """,
        substitutionValues: {
          "userId": request.headers?['id'],
          "status": status.toString().toUpperCase(),
          "method": method.toString().toUpperCase(),
        },
      ).then((value) => value.map((e) => {
            ...Transactions.fromPostgres(e.take(6).toList()).toJson(),
            "subscription":
                Subscriptions.fromPostgres(e.skip(6).toList()).toJson(),
          }));

      return Response.ok(transactions?.toList());
    } catch (e) {
      print(e);
      return Response.badRequest({
        'message': "Invalid type",
      });
    }
  }


}

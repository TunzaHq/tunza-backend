import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/subscriptions.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class SubscriptionsController extends Controller with DbMixin {
  final Request request;
  SubscriptionsController(this.request) : super(request);

  @Path("/")
  @Admin()
  Future<Response> getAllSubscriptions() async {
    return await conn?.query('SELECT * FROM subscriptions').then((value) {
          if (value.isEmpty)
            return Response.notFound({
              'message': "No subscriptions found",
            });
          var subscriptions = <Subscriptions>[];

          for (var row in value.sublist(0, value.length)) {
            subscriptions.add(Subscriptions.fromPostgres(row));
          }

          return Response.ok(subscriptions.map((e) => e.toJson()).toList());
        }) ??
        Response.internalServerError({
          'message': "Error getting subscriptions",
        });
  }

  @Path("/", method: "POST")
  @Auth()
  @Body([
    Field("plan_id", type: int),
    Field("user_id", type: int),
    Field("status", type: String),
  ])
  Future<Response> createSubscription() async {
    final body = request.body!;

    return await conn?.query(
            'INSERT INTO subscriptions (plan_id, user_id, status)'
            'VALUES (@plan_id, @user_id, @status)',
            substitutionValues: {
              'plan_id': body['plan_id'],
              'user_id': body['user_id'],
              'status': body['status'],
            }).then((value) {
          return Response.ok({
            'message': "Subscription created successfully",
          });
        }) ??
        Response.internalServerError({
          'message': "Error creating subscription",
        });
  }

  @Path("/:id")
  @Auth()
  @Param(["id"])
  Future<Response> getSubscription() async {
    final String? id = request.params?["id"];

    return await conn?.query('SELECT * FROM subscriptions WHERE id = @id',
            substitutionValues: {
              'id': id,
            }).then((value) {
          if (value.isEmpty)
            return Response.notFound({
              'message': "Subscription not found",
            });
          return Response.ok(Subscriptions.fromPostgres(value.first).toJson());
        }) ??
        Response.internalServerError({
          'message': "Error getting subscription",
        });
  }

  @Path("/:id", method: "PUT")
  @Auth()
  @Param(["id"])
  @Body([
    Field("status", type: String),
  ])
  Future<Response> updateSubscription() async {
    final String? id = request.params?["id"];
    final body = request.body!;

    return await conn?.query(
            'UPDATE subscriptions SET status = @status WHERE id = @id RETURNING *',
            substitutionValues: {
              'id': id,
              'status': body["status"],
            }).then((value) {
          if (value.isEmpty)
            return Response.notFound({
              'message': "Subscription not found",
            });
          return Response.ok(Subscriptions.fromPostgres(value.first).toJson());
        }) ??
        Response.internalServerError({
          'message': "Error updating subscription",
        });
  }

  @Path("/:id", method: "DELETE")
  @Auth()
  @Param(["id"])
  Future<Response> deleteSubscription() async {
    final String? id = request.params?["id"];

    return await conn?.query('DELETE FROM subscriptions WHERE id = @id',
            substitutionValues: {
              'id': id,
            }).then((value) {
          if (value.isEmpty)
            return Response.notFound({
              'message': "Subscription not found",
            });
          return Response.ok({
            'message': "Subscription deleted successfully",
          });
        }) ??
        Response.internalServerError({
          'message': "Error deleting subscription",
        });
  }
}

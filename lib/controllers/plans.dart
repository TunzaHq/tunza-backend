import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/plans.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class PlansController extends Controller with DbMixin {
  final Request request;
  PlansController(this.request) : super(request);

  @Path("/")
  Future<Response> getAllPlans() async {
    return await conn?.query('SELECT * FROM plans').then((value) {
          if (value.isEmpty)
            return Response.notFound({
              'message': "No plans found",
            });

          var plans = value.map((e) => Plans.fromPostgres(e)).toList();
          return Response.ok(plans.map((e) => e.toJson()).toList());
        }) ??
        Response.internalServerError({
          'message': "Error getting plans",
        });
  }

  @Path("/", method: "POST")
  @Auth()
  @Body([
    Field("name", type: String),
    Field("description", type: String),
    Field("price", type: int),
    Field("icon", type: String),
  ])
  Future<Response> createPlan() async {
    final body = request.body!;

    return await conn?.query(
            'INSERT INTO plans (name, description, price, icon)'
            'VALUES (@name, @description, @price, @icon)',
            substitutionValues: {
              'name': body['name'],
              'description': body['description'],
              'price': body['price'],
              'icon': body['icon'],
            }).then((value) {
          return Response.ok({
            'message': "Plan created successfully",
          });
        }) ??
        Response.internalServerError({
          'message': "Error creating plan",
        });
  }

  @Path("/:id")
  @Param(["id"])
  Future<Response> getPlan() async {
    final String? id = request.params?["id"];

    return await conn
            ?.query('SELECT * FROM plans WHERE id = @id', substitutionValues: {
          'id': id,
        }).then((value) {
          if (value.isEmpty)
            return Response.notFound({
              'message': "Plan not found",
            });
          return Response.ok(Plans.fromPostgres(value.first).toJson());
        }) ??
        Response.internalServerError({
          'message': "Error getting plan",
        });
  }

  @Path("/:id", method: "PUT")
  @Param(["id"])
  @Auth()
  Future<Response> updatePlan() async {
    final String? id = request.params?["id"];
    final body = request.body!;

    final plan = await conn
        ?.query('SELECT * FROM plans WHERE id = @id', substitutionValues: {
      'id': id,
    }).then((value) {
      return Plans.fromPostgres(value.first);
    });

    return await conn?.query(
            'UPDATE plans SET name = @name, description = @description, price = @price, updated_at = @updated_at WHERE id = @id',
            substitutionValues: {
              'id': id,
              'name': body['name'] ?? plan?.name,
              'description': body['description'] ?? plan?.description,
              'price': body['price'] ?? plan?.price,
              'updated_at': DateTime.now(),
            }).then((value) {
          return Response.ok({
            'message': "Plan updated successfully",
          });
        }) ??
        Response.internalServerError({
          'message': "Error updating plan",
        });
  }

  @Path("/:id", method: "DELETE")
  @Param(["id"])
  @Auth()
  Future<Response> deletePlan() async {
    final String? id = request.params?["id"];

    await conn?.query('DELETE FROM plans WHERE id = @id', substitutionValues: {
      'id': id,
    });

    return Response.ok({
      'message': "Plan deleted successfully",
    });
  }
}

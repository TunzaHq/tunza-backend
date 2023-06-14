import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/plans.dart';
import 'package:tunza/models/question_answer.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class CoversController extends Controller with DbMixin {
  final Request request;
  CoversController(this.request) : super(request);

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
  @Admin()
  @Body([
    Field("name", isRequired: true, type: String),
    Field("description", type: String),
    Field("price", isRequired: true, type: int),
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

  @Path("/:id", method: "PATCH")
  @Param(["id"])
  @Admin()
  @Body([
    Field("name", type: String),
    Field("description", type: String),
    Field("price", type: int),
  ])
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
  @Admin()
  Future<Response> deletePlan() async {
    final String? id = request.params?["id"];

    await conn?.query('DELETE FROM plans WHERE id = @id', substitutionValues: {
      'id': id,
    });

    return Response.ok({
      'message': "Plan deleted successfully",
    });
  }

  @Path("/:id/questions")
  @Auth()
  Future<Response> getQuestions() async {
    final String? id = request.params?["id"];

    return await conn?.query('SELECT * FROM questions WHERE plan_id = @id',
            substitutionValues: {
              'id': id,
            }).then((value) {
          return Response.ok(
              value.map((e) => Questions.fromPostgres(e).toJson()).toList());
        }) ??
        Response.internalServerError({
          'message': "Error getting questions",
        });
  }

  @Path("/:id/questions", method: "POST")
  @Param(["id"])
  @Admin()
  @Body([
    Field("question", type: String),
    Field("expects", type: String),
  ])
  Future<Response> createQuestion() async {
    final String? id = request.params?["id"];
    final body = request.body!;

    return await conn?.query(
            'INSERT INTO questions (plan_id, question, expects)'
            'VALUES (@plan_id, @question, @expects)',
            substitutionValues: {
              'plan_id': id,
              'question': body['question'],
              'expects': body['expects'],
            }).then((value) {
          return Response.ok({
            'message': "Question created successfully",
          });
        }) ??
        Response.internalServerError({
          'message': "Error creating question",
        });
  }

}

import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/claims.dart';
import 'package:tunza/models/question_answer.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class ClaimsController extends Controller with DbMixin {
  final Request request;
  ClaimsController(this.request) : super(request);

  @Path("/")
  @Auth()
  Future<Response> getAllClaims() async {
    return await conn?.query("select * from claims").then(
              (value) => Response.ok(
                  value.map((e) => Claims.fromPostgres(e).toJson()).toList()),
            ) ??
        Response.internalServerError({"message": "Something went wrong"});
  }

  @Path("/", method: "POST")
  @Auth()
  @Body([
    Field("description", isRequired: true, type: String),
    Field("subscription_id", isRequired: true, type: int),
    Field("location", isRequired: true, type: String),
  ])
  Future<Response> createClaim() async {
    try {
      final body = request.body!;

      await conn?.query(
          "insert into claims(description,subscription_id,location, status, amount)"
          "values(@description,@subscription_id,@location,@status, @amount)",
          substitutionValues: {
            "description": body["description"],
            "subscription_id": body["subscription_id"],
            "location": body["location"],
            "status": "PENDING",
            "amount": 45800, //TODO: Calculate amount
          });

      return Response.created({"message": "Claim created successfully"});
    } catch (e) {
      print(e);
      return Response.internalServerError({"message": "Something went wrong"});
    }
  }

  @Path("/:id")
  @Param(["id"])
  @Auth()
  Future<Response> getClaim() async {
    try {
      final id = request.params!["id"];

      final claim = await conn?.query("SELECT * FROM claims where id=@id",
          substitutionValues: {
            "id": id
          }).then((value) => Claims.fromPostgres(value.first));

      final answers = await conn?.query("""
          SELECT * FROM answers INNER JOIN questions ON answers.question_id = questions.id WHERE answers.claim_id=@id
          """, substitutionValues: {
        "id": id
      }).then((value) => value.map((e) => {
            ...Answers.fromPostgres(e.take(6).toList()).toJson(),
            "question": Questions.fromPostgres(e.skip(6).toList()).toJson()
          }));

      return Response.ok(
          {...claim?.toJson() ?? {}, "answers": answers?.toList() ?? []});
    } catch (e) {
      print(e);
      return Response.badRequest({"message": "Invalid id"});
    }
  }

  @Path("/:id", method: "PATCH")
  @Admin()
  @Body([
    Field("status", isRequired: true, type: String),
  ])
  Future<Response> updateClaim() async {
    try {
      final id = request.params!["id"];
      final body = request.body!;
      await conn?.query("update claims set status=@status where id=@id",
          substitutionValues: {
            "id": id,
            "status": body["status"],
          });

      return Response.ok({"message": "Claim updated successfully"});
    } catch (e) {
      print(e);
      return Response.badRequest({"message": "Invalid id"});
    }
  }

  @Path("/:id/answer", method: "POST")
  @Auth()
  @Param(["id"])
  @Body([
    Field("answers", isRequired: true, type: List),
  ])
  Future<Response> answerClaim() async {
    try {
      final answers = List.from(request.body!["answers"]);
      final id = request.params!["id"];

      for (var answer in answers) {
        await conn?.query(
            "insert into answers(claim_id,question_id,answer) values(@claim_id,@question_id,@answer)",
            substitutionValues: {
              "claim_id": id,
              "question_id": answer["question_id"],
              "answer": answer["answer"],
            });
      }
      return Response.ok({"message": "Claim answered successfully"});
    } catch (e) {
      print(e);
      return Response.internalServerError({"message": "Something went wrong"});
    }
  }
}

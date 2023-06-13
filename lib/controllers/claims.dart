import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/claims.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class ClaimsController extends Controller with DbMixin {
  final Request request;
  ClaimsController(this.request) : super(request);

  @Path("/")
  @Admin()
  Future<Response> getAllClaims() async {
    return await conn?.query("select * from claims").then((value) {
          if (value.isEmpty) {
            return Response.notFound({"message": "No claims found"});
          }
          var claims = value.map((e) => Claims.fromPostgres(e).toJson());
          return Response.ok(claims.toList());
        }) ??
        Response.internalServerError({"message": "Something went wrong"});
  }

  @Path("/", method: "POST")
  @Auth()
  @Body([
    Field("description", type: String),
    Field("subscription_id", type: int),
    Field("location", type: String),
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
      return await conn?.query("select * from claims where id=@id",
              substitutionValues: {"id": id}).then((value) {
            if (value.isEmpty) {
              return Response.notFound({"message": "Claim not found"});
            }
            return Response.ok(Claims.fromPostgres(value.first).toJson());
          }) ??
          Response.internalServerError({"message": "Something went wrong"});
    } catch (e) {
      print(e);
      return Response.badRequest({"message": "Invalid id"});
    }
  }

  @Path("/:id", method: "PUT")
  @Admin()
  @Body([
    Field("status", type: String),
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
      return Response.badRequest({"message": "Invalid id"});
    }
  }
}

import 'package:tunza/middlewares/auth_middleware.dart';
import 'package:zero/zero.dart';

class PlansController extends Controller {
  final Request request;
  PlansController(this.request) : super(request);
  
  @Path("/")
  Future<Response> getAllPlans() async {
    return Response.ok("getAllPlans");
  }

  @Path("/:id")
  @Param(["id"])
  Future<Response> getPlan() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("getPlan");
  }

  @Path("/:id", method: "PUT")
  @Param(["id"])
  @Body([
    Field("name", isRequired: true, type: String),
    Field("description", isRequired: true, type: String),
    Field("amount", isRequired: true, type: String),
    Field("duration", isRequired: true, type: String),
  ])
  @AuthMiddleware()
  Future<Response> updatePlan() async {
    final String? id = request.params?["id"];
    final body = request.body!;

    if (id == null || body["name"] == null || body["description"] == null || body["amount"] == null || body["duration"] == null) {
      return Response.badRequest({"message": "No id/name/description/amount/duration provided"});
    }

    return Response.ok("updatePlan");
  }

  @Path("/:id", method: "DELETE")
  @Param(["id"])
  @AuthMiddleware()
  Future<Response> deletePlan() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("deletePlan");
  }
}
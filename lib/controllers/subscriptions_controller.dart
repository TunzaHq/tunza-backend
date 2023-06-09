import 'package:tunza/middlewares/auth_middleware.dart';
import 'package:zero/zero.dart';

class SubscriptionsController extends Controller {
  final Request request;
  SubscriptionsController(this.request) : super(request);


  @Path("/")
  @AuthMiddleware()
  Future<Response> getAllSubscriptions() async {
    return Response.ok("getAllSubscriptions");
  }

  @Path("/:id")
  @AuthMiddleware()
  @Param(["id"])
  Future<Response> getSubscription() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("getSubscription");
  }

  @Path("/:id", method: "PUT")
  @AuthMiddleware()
  @Param(["id"])
  @Body([
    Field("status", isRequired: true, type: String),
  ])
  Future<Response> updateSubscription() async {
    final String? id = request.params?["id"];
    final body = request.body!;

    if (id == null || body["status"] == null) {
      return Response.badRequest({"message": "No id/status provided"});
    }

    return Response.ok("updateSubscription");
  }

  @Path("/:id", method: "DELETE")
  @AuthMiddleware()
  @Param(["id"])
  Future<Response> deleteSubscription() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("deleteSubscription");
  }
}

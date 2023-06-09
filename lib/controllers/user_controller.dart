import 'package:tunza/middlewares/auth_middleware.dart';
import 'package:zero/zero.dart';

class UserController extends Controller {
  final Request request;
  UserController(this.request) : super(request);

  @Path("/me")
  @AuthMiddleware()
  Future<Response> me() async {
    return Response.ok("me");
  }

  @Path("/")
  @AuthMiddleware()
  Future<Response> getAllUsers() async {
    return Response.ok("getAllUsers");
  }

  @Path("/:id")
  @AuthMiddleware()
  @Param(["id"])
  Future<Response> getUser() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("getUser");
  }

  @Path("/:id", method: "PUT")
  @AuthMiddleware()
  @Param(["id"])
  @Body([
    Field("avatar", isRequired: true, type: String),
  ])
  Future<Response> updateUser() async {
    final String? id = request.params?["id"];
    final body = request.body!;

    if (id == null || body["avatar"] == null) {
      return Response.badRequest({"message": "No id/avatar provided"});
    }

    return Response.ok("getUser");
  }

  @Path("/:id", method: "DELETE")
  @AuthMiddleware()
  @Param(["id"])
  Future<Response> deleteUser() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("deleteUser");
  }
}

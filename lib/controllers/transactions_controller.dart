import 'package:tunza/middlewares/auth_middleware.dart';
import 'package:zero/zero.dart';

class TransactionsController extends Controller {
  final Request request;
  TransactionsController(this.request) : super(request);

  @Path("/")
  @AuthMiddleware()
  Future<Response> getAllTransactions() async {
    return Response.ok("getAllTransactions");
  }

  @Path("/:id")
  @AuthMiddleware()
  @Param(["id"])
  Future<Response> getTransaction() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("getTransaction");
  }

  @Path("/:id", method: "PUT")
  @AuthMiddleware()
  @Param(["id"])
  @Body([
    Field("status", isRequired: true, type: String),
  ])
  Future<Response> updateTransaction() async {
    final String? id = request.params?["id"];
    final body = request.body!;

    if (id == null || body["status"] == null) {
      return Response.badRequest({"message": "No id/status provided"});
    }

    return Response.ok("updateTransaction");
  }

  @Path("/:id", method: "DELETE")
  @AuthMiddleware()
  @Param(["id"])
  Future<Response> deleteTransaction() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("deleteTransaction");
  }
}

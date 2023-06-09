import 'dart:io';

import 'package:tunza/middlewares/auth_middleware.dart';
import 'package:zero/zero.dart';

class MediaController extends Controller {
  final Request request;
  MediaController(this.request) : super(request);

  @Path("/")
  @AuthMiddleware()
  Future<Response> getAllMedia() async {
    return Response.ok("getAllMedia");
  }

  @Path("/:id")
  @AuthMiddleware()
  @Param(["id"])
  Future<Response> getMedia() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("getMedia");
  }

  @Path("/", method: "POST")
  @Body([
    Field("file_name", isRequired: true, type: String),
    Field(
      "type",
      isRequired: true,
    ),
    Field("file_size", isRequired: true, type: int),
    Field("user_id", isRequired: true, type: String),
  ])
  @AuthMiddleware()
  Future<Response> createMedia() async {
    final body = request.body!;

    if (body["name"] == null) {
      return Response.badRequest({"message": "No name provided"});
    }

    return Response.ok("createMedia");
  }

  @Path("/id_doc", method: "POST")
  @Body([
    Field("front_side", isRequired: true, type: File),
    Field("back_side", isRequired: true, type: File),
    Field("file_size", isRequired: true, type: int),
    Field("user_id", isRequired: true, type: String),
  ])
  @AuthMiddleware()
  Future<Response> createIdDocs() async {
    final body = request.body!;

    if (body["name"] == null) {
      return Response.badRequest({"message": "No name provided"});
    }

    return Response.ok("createMedia");
  }

  @Path("/:id", method: "DELETE")
  @AuthMiddleware()
  @Param(["id"])
  Future<Response> deleteMedia() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("deleteMedia");
  }
}

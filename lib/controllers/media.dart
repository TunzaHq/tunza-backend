import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/media.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class MediaController extends Controller with DbMixin {
  final Request request;
  MediaController(this.request) : super(request);

  @Path("/")
  @Admin()
  Future<Response> getAllMedia() async {
    return await conn!.query("SELECT * FROM media").then((value) {
      if (value.isEmpty) {
        return Response.notFound({"message": "No media found"});
      }
      return Response.ok(Media.fromPostgres(value.first));
    }).catchError((err) {
      return Response.internalServerError({"message": err.toString()});
    });
  }

  @Path("/:id")
  @Auth()
  @Param(["id"])
  Future<Response> getMedia() async {
    final String? id = request.params?["id"];

    return await conn!
        .query("SELECT * FROM media WHERE id = @id", substitutionValues: {
      "id": id,
    }).then((value) {
      if (value.isEmpty) {
        return Response.notFound({"message": "File not found"});
      }
      return Response.ok(Media.fromPostgres(value.first));
    }).catchError((err) {
      return Response.internalServerError({"message": err.toString()});
    });
  }

  @Path("/", method: "POST")
  @Body([
    Field("type", isRequired: true),
    Field("file_name", type: String),
    Field("file_size", type: int),
    Field("user_id", type: int),
    Field("url", type: String),
  ])
  @Auth()
  Future<Response> createMedia() async {
    final body = request.body!;
    return await conn!
        .query(
            "INSERT INTO media (type, file_name, file_size, user_id, url) VALUES (@type, @file_name, @file_size, @user_id, @url) RETURNING *",
            substitutionValues: {
              "type": body["type"],
              "file_name": body["file_name"],
              "file_size": body["file_size"],
              "user_id": body["user_id"],
              "url": body["url"],
            })
        .then((value) {
      return Response.ok(Media.fromPostgres(value.first));
    }).catchError((err) {
      return Response.internalServerError({"message": err.toString()});
    });
  }

  @Path("/:id", method: "DELETE")
  @Admin()
  @Param(["id"])
  Future<Response> deleteMedia() async {
    final String? id = request.params?["id"];

    if (id == null) {
      return Response.badRequest({"message": "No id provided"});
    }

    return Response.ok("deleteMedia");
  }
}

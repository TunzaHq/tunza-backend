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
      print(value.first);
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
    Field("file_name", isRequired: true, type: String),
    Field("url", isRequired: true, type: String),
  ])
  @Auth()
  Future<Response> createMedia() async {
    final body = request.body!;
    return await conn!.query(
        "INSERT INTO media (type, file_name,  user_id, url) VALUES (@type, @file_name, @user_id, @url)",
        substitutionValues: {
          "type": body["type"],
          "file_name": body["file_name"],
          "user_id": int.parse(request.headers?['id'] ?? "0"),
          "url": body["url"],
        }).then((value) {
      return Response.ok({
        "message": "Media file created successfully",
      });
    }).catchError((err) {
      return Response.internalServerError({"message": err.toString()});
    });
  }

  @Path("/:id", method: "DELETE")
  @Admin()
  @Param(["id"])
  Future<Response> deleteMedia() async {
    final String? id = request.params?["id"];
    return await conn!
        .query("DELETE FROM media WHERE id = @id", substitutionValues: {
      "id": id,
    }).then((value) {
      return Response.ok({"message": "Media file deleted successfully"});
    }).catchError((err) {
      return Response.internalServerError({"message": err.toString()});
    });
  }
}

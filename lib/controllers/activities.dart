import 'package:postgres/postgres.dart';
import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/activities.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class ActivitiesController extends Controller with DbMixin {
  final Request request;
  ActivitiesController(this.request) : super(request);

  @Path("/")
  @Admin()
  Future<Response> getActivities() async {
    return await conn
            ?.query(
                "SELECT * FROM activities AS a INNER JOIN users AS u ON a.user_id = u.id")
            .then((value) {
          final rows = value.sublist(0, value.length);
          var activities = <Map>[];

          for (PostgreSQLResultRow row in rows) {
            activities.add({
              ...Acitivities.fromPostgres(row).toJson(),
              "user": {
                "id": row[9],
                "name": row[10],
                "email": row[11],
              }
            });
          }
          return Response.ok(activities);
        }) ??
        Response.internalServerError();
  }

  @Path("/:id")
  @Auth()
  @Param(["id"])
  Future<Response> getActivity() async {
    final String? id = request.params?["id"];

    return await conn?.query(
            "SELECT * FROM activities AS a INNER JOIN users AS u ON a.user_id = u.id WHERE a.id = @id",
            substitutionValues: {
              "id": id,
            }).then((value) {
          final rows = value.sublist(0, value.length);
          var activities = <Map>[];

          for (PostgreSQLResultRow row in rows) {
            activities.add({
              ...Acitivities.fromPostgres(row).toJson(),
              "user": {
                "id": row[9],
                "name": row[10],
                "email": row[11],
              }
            });
          }
          return Response.ok(activities.first);
        }) ??
        Response.internalServerError();
  }

  @Path("/", method: "POST")
  @Auth()
  @Body([
    Field("type", isRequired: true),
    Field("activity", isRequired: true),
    Field("location")
  ])
  Future<Response> createLog() async {
    try {
      await conn?.query(
          "INSERT INTO activities (user_id, user_agent, ip_address, location, activity_type, activity) VALUES (@userid, @userAgent, @ipAddress, @location, @type, @activity)",
          substitutionValues: {
            "userid": request.headers?["id"],
            "userAgent": request.headers?["user-agent"],
            "ipAddress": request.ip,
            "location": request.body?["location"] ?? "Unknown",
            "type": request.body?["type"],
            "activity": request.body?["activity"],
          });
      return Response.ok({
        "message": "Log created successfully",
      });
    } catch (e) {
      print(e);
      return Response(statusCode: 500, body: {
        "message": "Error creating log",
      });
    }
  }
}

import 'package:zero/zero.dart';

class AuthController extends Controller {
  final Request request;

  AuthController(this.request) : super(request);

  @Path("/login", method: "POST") 
  @Body([
    Field("email", isRequired: true, type: String), 
    Field("password", isRequired: true, type: String),
  ])
  Future<Response> login() async { 
    final body = request.body!;
    //.. use body 
    return Response.ok(
      {
        "token": "eyCDFHJhbdjhbjbjb...",
        "refresh_token": "eyCDFHJhbdjhbjbjb...", 
        "expiry": "2023-09-23"
      }, 
    );
  }
  
  @Path("/register", method: "POST")
  @Body([
    Field("full_name", isRequired: true, type: String),
    Field("email", isRequired: true, type: String),
    Field("password", isRequired: true, type: String), 
  ])
  Future<Response> register() async {
    final body = request.body!;
    //.. use body
    return Response.ok(
      {...body}, 
    );
  }
}

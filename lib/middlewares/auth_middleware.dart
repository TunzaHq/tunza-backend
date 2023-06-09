import 'package:zero/zero.dart';

class AuthMiddleware extends Middleware {
  const AuthMiddleware();

  @override
  Future<RequestOrResponse> handle(Request request) async {
    final String? token = request.headers?['authorization'];
    if (token == null) {
      return RequestOrResponse(
        response: Response.forbidden({"message": "No token provided"}),
      );
    }

    
    return RequestOrResponse(request: request);
  }
}

import 'package:tunza/utils/crypt.dart';
import 'package:zero/zero.dart';

class Auth extends Middleware {
  const Auth();

  @override
  Future<RequestOrResponse> handle(Request request) async {
    try {
      final tkn =
          request.headers?['authorization']?.split('Bearer').last.trim();
      if (tkn == null)
        return RequestOrResponse(
          response: Response.unauthorized({'message': 'Unauthorized'}),
        );

      final jwt = verify(tkn);

      if (jwt.payload['role'] == null) {
        return RequestOrResponse(
          response: Response.unauthorized({'message': 'Unauthorized'}),
        );
      }

      return RequestOrResponse(
          request: request..headers?['id'] = jwt.payload['id'].toString());
    } catch (e) {
      print(e);
      return RequestOrResponse(
        response: Response.unauthorized({'message': 'Unauthorized'}),
      );
    }
  }
}


class Admin extends Middleware {
  const Admin();

  @override
  Future<RequestOrResponse> handle(Request request) async {
    try {
      final tkn =
      request.headers?['authorization']?.split('Bearer').last.trim();
      if (tkn == null)
        return RequestOrResponse(
          response: Response.unauthorized({'message': 'Unauthorized'}),
        );

      final jwt = verify(tkn);


      if (jwt.payload['role'] != 'admin') {
        return RequestOrResponse(
          response: Response.unauthorized({'message': 'Unauthorized'}),
        );
      }

      return RequestOrResponse(
          request: request..headers?['id'] = jwt.payload['id'].toString());
    } catch (e) {
      print(e);
      return RequestOrResponse(
        response: Response.unauthorized({'message': 'Unauthorized'}),
      );
    }
  }
}
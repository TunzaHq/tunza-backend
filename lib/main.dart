import 'dart:io';

import 'package:tunza/controllers/auth_controller.dart';
import 'package:tunza/controllers/media_controller.dart';
import 'package:tunza/controllers/plans_controller.dart';
import 'package:tunza/controllers/subscriptions_controller.dart';
import 'package:tunza/controllers/transactions_controller.dart';
import 'package:tunza/controllers/user_controller.dart';
import 'package:zero/utils/swagger_ui.dart';
import 'package:zero/zero.dart';
 
void main() {
  final zero = Server(routes: [
    // Documentation and Index
    Route(path: "/favicon.ico", controller: (req) => IndexController(req)),
    Route(path: "/docs", controller: (req) => SwaggerController(req)),

  
    Route(path: '/auth', controller: (req) => AuthController(req)),
    Route(path: "/users", controller: (req) => UserController(req)),
    Route(path: '/media', controller: (req) => MediaController(req)),
    Route(path: "/transactions", controller: (req) => TransactionsController(req)),
    Route(path: '/subscriptions', controller: (req) => SubscriptionsController(req)),
    Route(path: "/plans", controller: (req) => PlansController(req)),


  ]);

  zero.run();

  print('Listening on port ${zero.port}');
}

class SwaggerController extends Controller {  SwaggerController(Request request) : super(request);

  @Path('/')
  Future<Response> hello() async {
    //current file path
    final path = Uri.parse(Platform.script.path).toFilePath().split("/lib")[0];

    return await SwaggerUI("$path/swagger/swagger.yaml", deepLink: true)
        .call(request);
  }

  @Path('/swagger.yaml', method: 'GET')
  Future<Response> swagger() async {
    final path = Uri.parse(Platform.script.path).toFilePath().split("/lib")[0];

    return Response.ok(
      File("$path/swagger/swagger.yaml").readAsStringSync(),
      {
        'Content-Type': 'application/yaml',
      },
    );
  }
}

class IndexController extends Controller {
  IndexController(Request request) : super(request);

  @Path('/', method: 'GET')
  Response favicon() {
    return Response.ok(null, {
      'Content-Type': 'image/x-icon',
    });
  }
}

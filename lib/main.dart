import 'package:tunza/controllers/activities.dart';
import 'package:tunza/controllers/auth.dart';
import 'package:tunza/controllers/claims.dart';
import 'package:tunza/controllers/media.dart';
import 'package:tunza/controllers/covers.dart';
import 'package:tunza/controllers/subscriptions.dart';
import 'package:tunza/controllers/transactions.dart';
import 'package:tunza/controllers/user.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

void main() async {
  try {
    await Database()
      ..connect();
    final zero = Server(
      port: 9790,
      routes: [
        Route(path: '/auth', controller: (req) => AuthController(req)),
        Route(path: "/users", controller: (req) => UserController(req)),
        Route(path: '/media', controller: (req) => MediaController(req)),
        Route(
            path: "/transactions",
            controller: (req) => TransactionsController(req)),
        Route(
            path: '/subscriptions',
            controller: (req) => SubscriptionsController(req)),
        Route(path: "/covers", controller: (req) => CoversController(req)),
        Route(path: "/claims", controller: (req) => ClaimsController(req)),
        Route(path: "/404", controller: (req) => IndexController(req)),
        Route(
            path: "/activities", controller: (req) => ActivitiesController(req))
      ],
    );

    zero.run();

    print('Listening on port ${zero.port}');
  } catch (e) {
    print(e);
  }
}

class IndexController extends Controller {
  IndexController(Request request) : super(request);

  @Path("/")
  Response index() {
    final html = """
    <html>
      <head>
        <title>Zero</title>
      </head>
      <body style="padding:0; margin:0;height:100vh; width:100%; display:flex; justify-content:center; align-items:center">
         <p> Status: <span style="color:green">OK</span> </p>
         
       </body>
    </html>
    """;

    return Response.ok(html, {'Content-Type': 'text/html'});
  }
}

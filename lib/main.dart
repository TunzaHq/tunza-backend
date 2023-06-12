import 'package:tunza/controllers/auth.dart';
import 'package:tunza/controllers/claims.dart';
import 'package:tunza/controllers/media.dart';
import 'package:tunza/controllers/plans.dart';
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
        Route(path: "/plans", controller: (req) => PlansController(req)),
        Route(path: "/claims", controller: (req) => ClaimsController(req)),
        Route(path: "/404", controller: (req) => IndexController(req))
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
      <body style="height:100vh; width:100vw; display:flex; justify-content:center; align-items:center">
        <h1>Tunza</h1>
       </body>
    </html>
    """;

    return Response.ok(html, {'Content-Type': 'text/html'});
  }
}

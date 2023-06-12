import 'package:tunza/middlewares/auth.dart';
import 'package:tunza/models/transactions.dart';
import 'package:tunza/utils/database.dart';
import 'package:zero/zero.dart';

class TransactionsController extends Controller with DbMixin {
  final Request request;
  TransactionsController(this.request) : super(request);

  @Path("/")
  @Auth()
  Future<Response> getAllTransactions() async {
    return await conn?.query('SELECT * FROM transactions').then((value) {
          if (value.isEmpty)
            return Response.notFound({
              'message': "No transactions found",
            });

          var transactions = <Transactions>[];
          for (var row in value.sublist(0, value.length)) {
            transactions.add(Transactions.fromPostgres(row));
          }

          return Response.ok(transactions.map((e) => e.toJson()).toList());
        }) ??
        Response.internalServerError({
          'message': "Error getting transactions",
        });
  }

  @Path("/", method: "POST")
  @Auth()
  @Body([
    Field("subscription_id", type: int),
    Field("method", type: String),
    Field("status", type: String),
  ])
  Future<Response> createTransaction() async {
    final body = request.body!;

    return await conn?.query(
            'INSERT INTO transactions (subscription_id, method, status)'
            'VALUES (@subscription_id, @method, @status)',
            substitutionValues: {
              'subscription_id': body['subscription_id'],
              'method': body['method'],
              'status': body['status'],
            }).then((value) {
          return Response.ok({
            'message': "Transaction created successfully",
          });
        }) ??
        Response.internalServerError({
          'message': "Error creating transaction",
        });
  }
  
  @Path("/:id")
  @Auth()
  @Param(["id"])
  Future<Response> getTransaction() async {
    final String? id = request.params?["id"];

    return await conn?.query('SELECT * FROM transactions WHERE id = @id',
            substitutionValues: {
              'id': id,
            }).then((value) {
          if (value.isEmpty)
            return Response.notFound({
              'message': "Transaction not found",
            });
          return Response.ok(Transactions.fromPostgres(value.first).toJson());
        }) ??
        Response.internalServerError({
          'message': "Error getting transaction",
        });
  }

  @Path("/:id", method: "PUT")
  @Auth()
  @Param(["id"])
  @Body([
    Field("status", isRequired: true, type: String),
  ])
  Future<Response> updateTransaction() async {
    try {
      final String? id = request.params?["id"];
      final body = request.body!;

      await conn?.query("""
        UPDATE transactions SET status = @status WHERE id = @id
      """, substitutionValues: {
        'status': body['status'],
        'id': id,
      });

      return Response.ok({
        'message': "Transaction updated successfully",
      });
    } catch (e) {
      return Response.internalServerError({
        'message': "Error updating transaction",
      });
    }
  }

  @Path("/:id", method: "DELETE")
  @Auth()
  @Param(["id"])
  Future<Response> deleteTransaction() async {
    try {
      final String? id = request.params?["id"];

      await conn?.query("""
        DELETE FROM transactions WHERE id = @id
      """, substitutionValues: {
        'id': id,
      });

      return Response.ok({
        'message': "Transaction deleted successfully",
      });
    } catch (e) {
      return Response.internalServerError({
        'message': "Error deleting transaction",
      });
    }
  }
}

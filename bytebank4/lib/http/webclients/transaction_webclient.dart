import 'dart:convert';
import 'package:bytebank2/http/webclient.dart';
import 'package:bytebank2/models/contact.dart';
import 'package:bytebank2/models/transaction.dart';
import 'package:http/http.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final response = await client.get(url);
    List<Transaction> transactions = _toTransactions(response);
    return transactions;
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    
    await Future.delayed(Duration(seconds: 2));


    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(url,
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson,
    ).timeout(Duration(seconds: 2));

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return _toTransaction(response);

      case 401:
        throw HttpException(response.body);

      case 400:
        throw HttpException('there was an error submitting transaction');

      case 409:
        throw HttpException('transaction always exists');

      default:
        throw HttpException(
            'there was an unknown error  while submitting transaction');
    }

    // if(response.statusCode == 200){
    //   return _toTransaction(response);
    // }
    _throwHttpError(response.statusCode);

    return _toTransaction(response);
  }

  void _throwHttpError(int statusCode) {
      throw Exception(_statusCodeResponses[statusCode]);
  }

  List<Transaction> _toTransactions(Response response) {
    final List<dynamic> decodedJson = jsonDecode(response
        .body); //Decodifica o json para poder criar a lista de transações
    final List<Transaction> transactions = []; //criando a lista vazia
    for (Map<String, dynamic> transactionJson in decodedJson) {
    // Varre o Json decodificado extraindo o elemento, que representa o mapa que vai ter a cha String
      final Map<String, dynamic> contactJson = transactionJson['contact'];
      final Transaction transaction = Transaction(
        transactionJson['id'],
    //e valores dinâmicos
        transactionJson['value'],
        Contact(
          0,
          contactJson['name'],
          contactJson['accountNumber'],
        ),
      );
      transactions.add(transaction);
    }
    return transactions;
  }

  Transaction _toTransaction(Response response) {
    Map<String, dynamic> json = jsonDecode(response.body);
    final Map<String, dynamic> contactJson = json['contact'];
    return Transaction(
      json['id'],
      json['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
  }

  static final Map<int, String> _statusCodeResponses = {
    400 : 'Falha na autenticação (400)',
    401 : 'submitting transaction (401)!!'
  };

}

class HttpException implements Exception{
  final String message;

  HttpException(this.message);
}
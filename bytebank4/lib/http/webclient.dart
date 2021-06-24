
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'interceptors/logging_interceptor.dart';



final Client client = InterceptedClient.build(
  interceptors: [
    LoggingInterceptor(),
  ],
);

final url = Uri.http(
  '192.168.0.50:8080',
  'transactions',
);



import 'package:dio/dio.dart';

class DbConnect {
  final String _host = 'http://127.0.0.1:8000/';

  get host => _host;

  DbConnect();

  void connection() async {
    final dio = Dio();

    try {
      await dio.get('$_host');
    } catch (e) {
      print('Error: $e. Failure to connect to the database.');
    }
  }
}

import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'bqunzihmpamaxfbcfiyd-mysql.services.clever-cloud.com',
      user = 'uoavuukfksm7cezg',
      password = '7EVDaJt2lIXo7iZQDLKd',
      db = 'bqunzihmpamaxfbcfiyd';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}

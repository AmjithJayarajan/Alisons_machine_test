import 'globals.dart';

class RemoteServerURL {

  static String _remoteServerUrl = "https://swan.alisonsnewdemo.online/api/";

  static String get AuthLogin {
    return _makeUrl("login?email_phone=${Globals.mobileno}&password=${Globals.password}");
  }

  static String get Homepage {
    return _makeUrl("home?id=bDy&token=LNGmyh68wLz9Lubwsk98fb0CUtN7s7rdlDGBsFe7");
  }

  static String _makeUrl(String endpoint) {
    return _remoteServerUrl + endpoint;
  }
}

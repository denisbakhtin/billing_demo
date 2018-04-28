import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

const String tokenKey = 'token';

bool notNull(Object o) => o != null;

const String notImplemented =
    'This feature is not implemented in the demo version';

Type typeOf<T>() => T;

storeToken(String token) async {
  final storage = new FlutterSecureStorage();
  await storage.write(key: tokenKey, value: token);
}

deleteToken() async {
  final storage = new FlutterSecureStorage();
  await storage.delete(key: tokenKey);
}

Future<String> getToken() async {
  final storage = new FlutterSecureStorage();
  return await storage.read(key: tokenKey);
}

bool stringIsNullOrEmpty(String value) {
  return value == null || value.isEmpty;
}

bool isReleaseMode() {
  return bool.fromEnvironment("dart.vm.product");
}

String getApiDomain() {
  if (isReleaseMode())
    return 'http://192.168.56.1:5000'; //Replace with public api domain
  //use SharpProxy to redirect 192.168.56.1:5000 to :54979
  return 'http://192.168.56.1:5000';
}

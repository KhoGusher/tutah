import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class TokenManager {

   Future getToken() async {
    const storage = FlutterSecureStorage();

    String? token = await storage.read(key: 'token');

    print(token);

    return token;
  }


   Future remoteToken() async {
     const storage = FlutterSecureStorage();

     await storage.deleteAll();
   }

}

import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class Amadeus {
  String? token;

  Future<String?> generateAccessToken() async {
    final String clientId = dotenv.env['CLIENT_ID'] as String;
    final String clientSecret = dotenv.env['CLIENT_SECRET'] as String;
    final Uri authorizationUri =
        Uri.parse("https://test.api.amadeus.com/v1/security/oauth2/token");
    Response? response;

    try {
      response = await post(authorizationUri,
          headers: {"Content-type": "application/x-www-form-urlencoded"},
          body:
              "grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret");
    } catch (e) {
      log(e.toString());
      return null;
    }
    final Map data = jsonDecode(response.body);
    token = data['access_token'];

    return token;
  }
}

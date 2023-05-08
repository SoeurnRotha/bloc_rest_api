import 'dart:convert';

import 'package:bloc_rest_api/model/user_model.dart';
import 'package:http/http.dart' as http;

String url = "https://randomuser.me/api/?results=100";

class ApiRepository {
  Future<List<Welcome>> getUser() async {
    var client = http.Client();
    var uri = Uri.parse(url);
    var res = await client.get(uri);

    if (res.statusCode == 200) {
      var json = res.body;
      var jsonData = jsonDecode(json);
      var user = Welcome.fromJson(jsonData);
      return [user];
    } else {
      throw Exception('Error');
    }
  }
}

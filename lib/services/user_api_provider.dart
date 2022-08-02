import 'dart:convert';

import 'package:user_list/model/user.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  Future<List<User>> getUsers(int page) async {
    final response = await http
        .get(Uri.parse('https://gorest.co.in/public/v2/users?page=$page'));

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      return userJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Error fetching users');
    }
  }
}

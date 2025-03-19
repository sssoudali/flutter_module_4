import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// User Model
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

// FutureProvider for API Call
final userProvider = FutureProvider<List<User>>((ref) async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
  
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((user) => User.fromJson(user)).toList();
  } else {
    throw Exception("Failed to fetch users");
  }
});
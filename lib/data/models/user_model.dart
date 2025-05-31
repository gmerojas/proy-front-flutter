import 'dart:convert';

class UserModel {
  final int id;
  final String username;
  final String name;
  final String lastname;
  final String email;
  final int age;

  UserModel({required this.id, required this.username, required this.name, required this.lastname, required this.email, required this.age});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'name': name,
      'lastname': lastname,
      'email': email,
      'age': age,
    };
  }

  factory UserModel.fromJson(Map<String,dynamic> json){
    return UserModel(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      lastname: json['lastname'],
      email: json['email'],
      age: json['edad'] ?? (json['age']),
    );
  }

  String toJson() => json.encode(toMap());
}

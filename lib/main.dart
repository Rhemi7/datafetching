import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(MyApp());

const baseUrl = "https://jsonplaceholder.typicode.com";

class API {
  static Future getUsers() {
    var url = baseUrl + "/users";
    return http.get(url);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyListScreen(),
    );
  }
}

class MyListScreen extends StatefulWidget {
  @override
  createState() => _MyListScreenState();
}

class _MyListScreenState extends State {
  var users = new List<User>();

  _getUsers() {
    API.getUsers().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        users = list.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getUsers();
  }

  dispose() {
    super.dispose();
  }

  @override
  build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User List"),
        ),
        body: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(users[index].name),
              subtitle: Text(users[index].email),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsScreen(users[index])),
                );
              },
            );
          },
        ));
  }
}

class User {
  int id;
  String name;
  String email;
  String address;
  String username;

  User(int id, String name, String email, String address, String username) {
    this.id = id;
    this.name = name;
    this.email = email;
    this.address = address;
    this.username = username;
  }

  User.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        address = json['address'],
        username = json['username'];

  Map toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'username': username
    };
  }
}

class DetailsScreen extends StatelessWidget {
  final User user;

  DetailsScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(user.name),
          Text(user.address),
          Text(user.username),
          Text(user.email)
        ],
      ),
    );
  }
}

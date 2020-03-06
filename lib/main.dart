import 'dart:convert';
import 'package:flutter/material.dart';
import 'user.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final String url = "http://192.168.0.111:9300/";

  Future<List<User>> getUser() async{
    final response = await http.get(Uri.parse("http://192.168.0.111:9300/"),
        headers: {"Content-type": "application/json"});
    print(response);
    List<Map<String, dynamic>> jsonData =
        jsonDecode(response.body).cast<Map<String, dynamic>>();
    print(jsonData);
    List<User> userList = jsonData.map((json) => User.fromJson(json)).toList();
    return userList;
  }

  //Future<List<User>> userList;
  Future<List<User>> userList;
  @override
  void initState() {
    userList = getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: FutureBuilder(
        future: userList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return MyHomePage(list: snapshot.data);
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({this.list});
  final List<User> list;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserDetails(id: list[index].id)));
            },
            child: ListTile(
              title: Text(list[index].name),
            ),
          );
        });
  }
}

class UserDetails extends StatefulWidget {
  final String id;
  UserDetails({this.id});

  @override
  _UserDetailsState createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {

  
  Future<User> getUser(String id) async {
    final String url = "http://192.168.0.111:9300/user/${widget.id}";
    http.Response response =
        await http.get(url, headers: {"Content-type": "application/json"});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    User user = User.fromJson(jsonData);
    return user;
  }

  Future<User> user;
  @override
  void initState() {
    user = getUser(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
      ),
      body: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(snapshot.data.id),
                  Text(snapshot.data.name),
                  Text(snapshot.data.address),
                  Text(snapshot.data.phoneNo)
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }
}

Future<Post>  fetchPost() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  }
  else {throw Exception('Ошибка загрузки');}}

class NetScreen extends StatefulWidget {
  const NetScreen({Key? key}) : super(key: key);

  @override
  _NetScreenState createState() => _NetScreenState();
}

class _NetScreenState extends State<NetScreen> {

  late Future<Post> futurePost;

  @override
  void initState(){
    super.initState();
    futurePost = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Пример получения данных',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Пример получения данных'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: futurePost,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    const Text('Title:', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('${snapshot.data!.title}'),
                    const SizedBox(height: 10,),
                    const Text('Body:', style: TextStyle(fontWeight: FontWeight.bold),),
                    Text('${snapshot.data!.body}'),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const NetScreen());
}
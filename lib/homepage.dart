import 'dart:convert';
import 'dart:ffi';

import 'package:dsc_sec_5/model/album.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'album.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Album>> getData() async {
    String url = "https://jsonplaceholder.typicode.com/albums";

    var jsonData = await http.get(Uri.parse(url));

    if (jsonData.statusCode == 200) {
      List data = jsonDecode(jsonData.body);
      List<Album> allusers = [];
      for (var u in data) {
        Album album = Album.fromjson(u);
        allusers.add(album);
      }

      return allusers;
    } else {
      throw Exception("error");
    }
  }

  late Future<List<Album>> users;
  @override
  void initState() {
    users = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Albums"),
      ),
      body: FutureBuilder<List<Album>>(
        future: users,
        builder: (context, snapShout) {
          if (snapShout.hasData) {
            return ListView.builder(
              itemCount: snapShout.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Text(
                        "Id : ${snapShout.data![index].id}\nTilte : ${snapShout.data![index].title}"),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

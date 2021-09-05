import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'Post.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _urlBase = "https://jsonplaceholder.typicode.com";


  Future<List<Post>> _recuperarPostagens() async{

    http.Response response = await http.get(Uri.parse(_urlBase + "/posts"));
    var dadosJson = json.decode(response.body);

    List<Post> postagens = [];

    for(var post in dadosJson){
      //print("post: " + post["title"]);
      Post p = Post(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }

    return postagens;
    //print(postagens.toString());

  }

  _post() async {

    var corpo = json.encode(
        {
          "userId": 120,
          "id": null,
          "title": "Titulo",
          "body": "Corpo da postagem"
        }
    );
    http.Response response = await http.post(
      Uri.parse(_urlBase + "/posts"),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: corpo
    );

  print("Resposta: ${response.statusCode}");
  print("resposta: ${response.body}");

  }

  _put(){

  }

  _patch(){

  }

  _delete(){

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviços avançado"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ElevatedButton(
                    onPressed: _post,
                    child: Text("Salvar")
                ),
                ElevatedButton(
                    onPressed: _post,
                    child: Text("Atualizar")
                ),
                ElevatedButton(
                    onPressed: _post,
                    child: Text("Remover")
                )
              ],
            ),
            Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _recuperarPostagens(),
                  builder: (context, snapshot){

                    switch(snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if(snapshot.hasError){
                          print("Lista: Erro ao carregar!");
                        }else{
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index){

                                List<Post>? lista = snapshot.data;
                                Post post  = lista![index];

                                return ListTile(
                                  title: Text(post.title),
                                  subtitle: Text(post.id.toString()),
                                );
                              }
                          );
                        }
                        break;
                    }
                    return Container();
                  },
                ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map> _recuperarPreco() async {
    String url = "https://www.blockchain.com/ticker";
    http.Response response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (contex, sanpshot){

        String resultado = "";

        switch(sanpshot.connectionState){
          case ConnectionState.none:
            print("Conexão NONE");
            break;
          case ConnectionState.waiting:
            print("Conexão WAITING");
            resultado = "Carregando...";
            break;
          case ConnectionState.active:
            print("Conexão ACTIVE");
            break;
          case ConnectionState.done:
            print("Conexão DONE");
            if(sanpshot.hasError){
              resultado = "Erro ao carregar os dados.";
            }else{
              double valor = sanpshot.data!["BRL"]["buy"];
              resultado = "Preço do Bitcoin: ${valor.toString()}";
            }
            break;
        }
        return Center(
          child: Text(resultado),
        );
      },
    );
  }
}

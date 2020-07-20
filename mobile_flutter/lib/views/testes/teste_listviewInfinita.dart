/*
  Esta tela contém um exemplo de lista infinita utilizando Firebase. 
  Fonte feito baseado no vídeo https://www.youtube.com/watch?v=sMKczu6Gqy4
  No vídeo não é utilizado o firebase, desta maneira precisei fazer algumas adaptações.
*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class Pessoa{
  int id;
  String nome;
  String telefone;
}

class Teste extends StatelessWidget {
  // This widget is the root of your application.
  @override
  //_Teste createState() => _Teste();

  Widget build(BuildContext context) {
    return _Teste(title: 'Flutter Demo Home Page');
  }  

  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter Demo',
  //     theme: ThemeData(
  //       primarySwatch: Colors.blue,
  //       visualDensity: VisualDensity.adaptivePlatformDensity,
  //     ),
  //     home: _Teste(title: 'Flutter Demo Home Page'),
  //   );
  // }
}

class _Teste extends StatefulWidget {
  _Teste({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TesteState createState() => _TesteState();
}

class _TesteState extends State<_Teste> {
  int _totalItens = 0;
  List<Pessoa> _listaTela = List();
  int _skip = 0;
  int _take = 2;

  @override
  void initState() {
    _getData();
  }  

  Future<Null> _getData() async{

    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = null;

    if (_listaTela.length == 0) {
      querySnapshot = await db
        .collection("infinitylist_test")
        .orderBy('id')
        .limit(_take)
        .getDocuments();
    }else{
      querySnapshot = await db
        .collection("infinitylist_test")
        .orderBy('id')
        .startAfter([_listaTela[_listaTela.length - 1].id])
        .limit(_take)
        .getDocuments();
    }

    //192.168.0.11:5001/api/skip=$skip&take=$take
    //var response = await http.get('https://jsonplaceholder.typicode.com/todos');
    //var info = jsonDecode(response.body);

    // var info = [
    //   {"id":"1", "nome":"Mateus", "telefone":"111"},
    //   {"id":"2", "nome":"Ana", "telefone":"222"}
    // ];

    bool incluiu = false;

    for(DocumentSnapshot item in querySnapshot.documents) {
      incluiu = true;
      var dados = item.data;

      var p = new Pessoa();
      p.id = dados['id'];
      p.nome = dados['nome'];
      p.telefone = dados['telefone'];
      _listaTela.add(p);
    }

    if (incluiu == true){
      setState((){
        _totalItens = _listaTela.length;
      });
      
    }
  }

  void firebase_DelAll() async{
    Firestore.instance.collection('person_pers').getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      };
    }).then((value) => Firestore.instance.collection("sequence").document('1').setData({"code_pers": 99})
    );
  }

  void firebaseInsertBlock() async{
    // Firestore db = Firestore.instance;
    //await firebase_Delall();
    int code_pers = 100;
      
    Firestore db = Firestore.instance;
    QuerySnapshot querySnapshot = await db
      .collection("sequence")
      .getDocuments();

    for(DocumentSnapshot item in querySnapshot.documents) {//TODO - Tirar do Laço
      var dados = item.data;
      code_pers = dados['code_pers'];
    }

    for(int i=1; i<=151; i++){
      // Firestore.instance.collection("infinitylist_test").document(i.toString()).setData(
      //   {
      //     "id": i,
      //     "nome": "nome-$i",
      //     "telefone": "telefone-$i"
      //   }
      // );

      code_pers++;

      Firestore.instance.collection("person_pers").document(code_pers.toString()).setData(
        {
          "id": code_pers,
          "code_pers": code_pers,
          "name_pers": "Insert Automático - $code_pers",
          "nickname_pers": "Apelido-$code_pers"
        }
      );
    }

    Firestore.instance.collection("sequence").document('1').setData({"code_pers": code_pers});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('$_totalItens'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              firebaseInsertBlock();
            },
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              firebase_DelAll();
            },
          ),
        ],
      ),      
       body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: createListView(),)
            
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget createListView(){
    return ListView.builder(
      itemCount: _totalItens,
      itemBuilder: (BuildContext context, int index) {
       var values = _listaTela;

        if (index >= _listaTela.length-1){
          _skip++;
          _getData();
        }

        return Column(
          children: <Widget>[
            ListTile(
              title: Column(
                children: <Widget>[
                  Text(values[index].nome ?? ""), //fixar tamanho máximo
                  Text(values[index].telefone ?? ""), //fixar tamanho máximo

                ],
              )
            )

          ],
        );
      }  
    );
  }
}


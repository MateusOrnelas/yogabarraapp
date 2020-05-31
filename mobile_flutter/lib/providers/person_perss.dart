import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/utils/constants.dart';
import './person_pers.dart';

class Person_perss with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/person_pers';
  List<Person_pers> _items = [];

  List<Person_pers> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadStudents() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();
    if (data != null) {
      data.forEach((person_persId, person_persData) {
        _items.add(Person_pers(
          id: person_persId,
          code_pers: person_persData['Code_pers'],
          name_pers: person_persData['name_pers'],
          address_pers: person_persData['address_pers']
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addPerson_pers(Person_pers newPerson_pers) async {
    final response = await http.post(
      "$_baseUrl.json",
      body: json.encode({
        'name_pers': newPerson_pers.name_pers,
        'address_pers': newPerson_pers.address_pers
      }),
    );

    _items.add(Person_pers(
      id: json.decode(response.body)['name'],
      name_pers: newPerson_pers.name_pers,
      address_pers: newPerson_pers.address_pers
    ));
    notifyListeners();
  }

  Future<void> updatePerson_pers(Person_pers person_pers) async {
    if (person_pers == null || person_pers.id == null) {
      return;
    }

    final index = _items.indexWhere((person) => person.id == person_pers.id);
    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${person_pers.id}.json",
        body: json.encode({
          'name_pers': person_pers.name_pers,
          'address_pers': person_pers.address_pers,
        }),
      );
      _items[index] = person_pers;
      notifyListeners();
    }
  }

  Future<void> deletePerson(String id) async {
    final index = _items.indexWhere((person) => person.id== id);
    if (index >= 0) {
      final person_pers = _items[index];
      _items.remove(person_pers);
      notifyListeners();

      final response = await http.delete("$_baseUrl/${person_pers.id}.json");

      if (response.statusCode >= 400) {
        _items.insert(index, person_pers);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto.');
      } 
    }
  }
}

// bool _showFavoriteOnly = false;

// void showFavoriteOnly() {
//   _showFavoriteOnly = true;
//   notifyListeners();

// }
// void showAll() {
//   _showFavoriteOnly = false;
//   notifyListeners();
// }
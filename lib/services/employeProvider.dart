 import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:testa/models/employe.dart';


class Employeprovider {

  Future<List<Employe>> getUsers() async {
    String url = "http://127.0.0.1:8086/employee/api/v1/all";
    try {
      final response = await http.get(Uri.parse(url));
      String responsebody = response.body;
      final int statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        final items = json.decode(responsebody);
print(items.toString());
        final employes = Employes.fromJsonList(items);
        return employes.items;
      }
    } catch (e) {
      print("ERORR" + "\n" + e.toString());
    }
    return [];
  }

}


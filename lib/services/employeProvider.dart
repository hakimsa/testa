
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testa/models/employe.dart';

class Employeprovider {
  // ── Reemplaza con tu URL base real ──────────────────────────────
  static const String _baseUrl = 'http://127.0.0.1:8086/employee/api/v1';
  // ───────────────────────────────────────────────────────────────

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept':       'application/json',
  };

  // ── READ ALL ────────────────────────────────────────────────────
  Future<List<Employe>> getUsers() async {
    final res = await http
        .get(Uri.parse('$_baseUrl/all'), headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) {
      final List<dynamic> body = json.decode(res.body);
      return body.map((e) => Employe.fromJson(e)).toList();
    }
    throw Exception('Error ${res.statusCode}');
  }

  // ── READ ONE ────────────────────────────────────────────────────
  Future<Employe> getUserById(int id) async {
    final res = await http
        .get(Uri.parse('$_baseUrl/find/$id'), headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) return Employe.fromJson(json.decode(res.body));
    throw Exception('Empleado no encontrado');
  }

  // ── CREATE ──────────────────────────────────────────────────────
  Future<Employe> createUser(Employe employe) async {
    final res = await http
        .post(
          Uri.parse('$_baseUrl/add'),
          headers: _headers,
          body: json.encode(employe.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200 || res.statusCode == 201) {
      return Employe.fromJson(json.decode(res.body));
    }
    throw Exception('Error al crear: ${res.body}');
  }

  // ── UPDATE ──────────────────────────────────────────────────────
  Future<Employe> updateUser(int id, Employe employe) async {
    final res = await http
        .put(
          Uri.parse('$_baseUrl/update/$id'),
          headers: _headers,
          body: json.encode(employe.toJson()),
        )
        .timeout(const Duration(seconds: 10));

    if (res.statusCode == 200) return Employe.fromJson(json.decode(res.body));
    throw Exception('Error al actualizar: ${res.body}');
  }

  // ── DELETE ──────────────────────────────────────────────────────
  Future<bool> deleteUser(int id) async {
    final res = await http
        .delete(Uri.parse('$_baseUrl/delete/$id'), headers: _headers)
        .timeout(const Duration(seconds: 10));

    return res.statusCode == 200 || res.statusCode == 204;
  }
}
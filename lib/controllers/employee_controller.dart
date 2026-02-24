import 'package:flutter/material.dart';
import 'package:testa/models/employe.dart';
import 'package:testa/services/employeProvider.dart';


class EmployeController extends ChangeNotifier {
  final _service = Employeprovider();

  List<Employe> employees = [];
  bool isLoading = false;
  String? error;

  // ── READ ALL ────────────────────────────────────────────────────
  Future<void> loadEmployees() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      employees = await _service.getUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── CREATE ──────────────────────────────────────────────────────
  Future<bool> addEmployee(Employe emp) async {
    try {
      final created = await _service.createUser(emp);
      employees.add(created);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── UPDATE ──────────────────────────────────────────────────────
  Future<bool> editEmployee(int id, Employe emp) async {
    try {
      final updated = await _service.updateUser(id, emp);
      final idx = employees.indexWhere((e) => e.id == id);
      if (idx != -1) employees[idx] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ── DELETE ──────────────────────────────────────────────────────
  Future<bool> removeEmployee(int id) async {
    try {
      final ok = await _service.deleteUser(id);
      if (ok) {
        employees.removeWhere((e) => e.id == id);
        notifyListeners();
      }
      return ok;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
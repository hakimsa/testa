import 'package:flutter/material.dart';
import 'package:testa/controllers/employee_controller.dart';
import 'package:testa/models/employe.dart';
import 'package:testa/widget/employe_for_widgt.dart';

/// Pass [initial] to enter edit mode; leave null for create mode.
class EmployeFormScreen extends StatelessWidget {
  final EmployeController controller;
  final Employe? initial;

  const EmployeFormScreen({
    super.key,
    required this.controller,
    this.initial,
  });

  bool get _isEditing => initial != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Editar empleado' : 'Nuevo empleado',
          style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A)),
        ),
      ),
      body: EmployeFormWidget(
        initial: initial,
        submitLabel: _isEditing ? 'Actualizar' : 'Crear empleado',
        onSubmit: (emp) => _isEditing
            ? controller.editEmployee(initial!.id, emp)
            : controller.addEmployee(emp),
      ),
    );
  }
}
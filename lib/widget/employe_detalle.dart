import 'package:flutter/material.dart';
import 'package:testa/controllers/employee_controller.dart';
import 'package:testa/models/employe.dart';
import 'package:testa/screens/employe_for_screen.dart';


class EmployeDetailScreen extends StatelessWidget {
  final Employe employee;
  final EmployeController controller;

  const EmployeDetailScreen({
    super.key,
    required this.employee,
    required this.controller,
  });

  // ── Delete confirm dialog ───────────────────────────────────────
  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar empleado',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        content: Text(
          '¿Seguro que deseas eliminar a ${employee.name}? Esta acción no se puede deshacer.',
          style: const TextStyle(color: Color(0xFF616161), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar',
                style: TextStyle(color: Color(0xFF9E9E9E))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar',
                style: TextStyle(color: Color(0xFFC62828))),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final ok = await controller.removeEmployee(employee.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(ok ? 'Empleado eliminado' : 'Error al eliminar'),
          backgroundColor: ok ? const Color(0xFF1A1A1A) : const Color(0xFFC62828),
        ));
        if (ok) Navigator.of(context).pop(true);
      }
    }
  }

  // ── Navigate to edit form ───────────────────────────────────────
  Future<void> _goEdit(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeFormScreen(
          controller: controller,
          initial: employee,
        ),
      ),
    );
  }

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
        title: const Text('Detalles',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A))),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                size: 20, color: Color(0xFF1A1A1A)),
            onPressed: () => _goEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                size: 20, color: Color(0xFFC62828)),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero section ──────────────────────────────────────
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 90,
                      height: 90,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/no-image.png',
                        image: employee.imageUrl.isNotEmpty
                            ? employee.imageUrl
                            : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(employee.name)}&background=1A1A1A&color=fff&size=200',
                        fit: BoxFit.cover,
                        imageErrorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFEEEEEE),
                          child: const Icon(Icons.person_outline,
                              size: 40, color: Color(0xFF9E9E9E)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(employee.name,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A))),
                  const SizedBox(height: 4),
                  Text(employee.jobTitle,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF9E9E9E))),
                  const SizedBox(height: 10),
                  _StatusChip(active: employee.active),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Info cards ────────────────────────────────────────
            _InfoSection(title: 'Información de contacto', rows: [
              _InfoRow(Icons.email_outlined, 'Email', employee.email),
              _InfoRow(Icons.phone_outlined, 'Teléfono', employee.phone),
            ]),

            const SizedBox(height: 16),

            _InfoSection(title: 'Datos laborales', rows: [
              _InfoRow(Icons.badge_outlined, 'Código',
                  employee.employeeCode.isNotEmpty
                      ? employee.employeeCode
                      : '—'),
              _InfoRow(
                Icons.calendar_today_outlined,
                'Contrato',
                employee.dateContract != null
                    ? employee.dateContract.toString()
                    : '—',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

// ── Subwidgets ──────────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final bool active;
  const _StatusChip({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? 'Activo' : 'Inactivo',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: active ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoRow> rows;
  const _InfoSection({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9E9E9E),
                letterSpacing: 0.8)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: rows
                .asMap()
                .entries
                .map((entry) => Column(
                      children: [
                        entry.value,
                        if (entry.key < rows.length - 1)
                          const Divider(
                              height: 1,
                              indent: 52,
                              color: Color(0xFFE0E0E0)),
                      ],
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF9E9E9E)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF9E9E9E))),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF1A1A1A))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
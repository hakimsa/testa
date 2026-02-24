import 'package:flutter/material.dart';
import 'package:testa/models/employe.dart';

class EmployeCard extends StatelessWidget {
  final Employe employee;
  final VoidCallback onTap;

  const EmployeCard({super.key, required this.employee, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 48,
                height: 48,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/images/no-image.png',
                  image: employee.imageUrl.isNotEmpty
                      ? employee.imageUrl
                      : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(employee.name)}&background=1A1A1A&color=fff',
                  fit: BoxFit.cover,
                  imageErrorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFEEEEEE),
                    child: const Icon(Icons.person_outline,
                        color: Color(0xFF9E9E9E)),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    employee.jobTitle,
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF9E9E9E)),
                  ),
                ],
              ),
            ),

            // Status badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: employee.active
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                employee.active ? 'Activo' : 'Inactivo',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: employee.active
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFC62828),
                ),
              ),
            ),

            const SizedBox(width: 8),
            const Icon(Icons.chevron_right,
                color: Color(0xFFBDBDBD), size: 20),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:testa/models/employe.dart';
import 'package:testa/services/employeProvider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Employeprovider _employeprovider = Employeprovider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 30),

            // ── Header ──────────────────────────────────────
            const Text(
              'Empleados',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Lista del equipo',
              style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 24),

            // ── Employee list ────────────────────────────────
            SizedBox(
              height: 320,
              child: FutureBuilder<List<Employe>>(
                future: _employeprovider.getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1A1A1A),
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.error_outline,
                              color: Color(0xFF9E9E9E), size: 40),
                          SizedBox(height: 8),
                          Text(
                            'Error al cargar empleados',
                            style: TextStyle(color: Color(0xFF9E9E9E)),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.people_outline,
                              color: Color(0xFF9E9E9E), size: 40),
                          SizedBox(height: 8),
                          Text(
                            'No hay empleados disponibles',
                            style: TextStyle(color: Color(0xFF9E9E9E)),
                          ),
                        ],
                      ),
                    );
                  }

                  final employees = snapshot.data!;
                  return ListView.separated(
                    itemCount: employees.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) =>
                        _EmployeeCard(employee: employees[index]),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // ── Action buttons ───────────────────────────────
            Row(
              children: [
                _ActionButton(label: 'Agregar', onPressed: () {}),
                const SizedBox(width: 10),
                _ActionButton(label: 'Actualizar', onPressed: () {}),
                const SizedBox(width: 10),
                _ActionButton(label: 'Eliminar', onPressed: () {}, danger: true),
              ],
            ),

            const SizedBox(height: 28),

            // ── Feature cards ────────────────────────────────
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _FeatureCard(
                    text: 'New feature en producción — rama main',
                    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                  ),
                  SizedBox(width: 12),
                  _FeatureCard(
                    text: 'Descripción completa del nuevo feature',
                    colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
                  ),
                  SizedBox(width: 12),
                  _FeatureCard(
                    text: 'Novedades del release en rama main',
                    colors: [Color(0xFF373B44), Color(0xFF4286f4)],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ── Employee card ──────────────────────────────────────────────────────────────
class _EmployeeCard extends StatelessWidget {
  final Employe employee;
  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 44,
          height: 44,
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/no-image.png',
            image: employee.imageUrl.isNotEmpty
                ? employee.imageUrl
                : 'https://via.placeholder.com/44',
            fit: BoxFit.cover,
            imageErrorBuilder: (_, __, ___) => Image.asset(
              'assets/images/no-image.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        employee.name,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
        ),
      ),
      subtitle: Text(
        employee.email,
        style: const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
      ),
      trailing: Text(
        employee.jobTitle,
        style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
      ),
    );
  }
}

// ── Action button ──────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool danger;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: danger ? const Color(0xFFFFEBEE) : const Color(0xFFEEEEEE),
          foregroundColor: danger ? const Color(0xFFC62828) : const Color(0xFF1A1A1A),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}

// ── Feature card ───────────────────────────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final String text;
  final List<Color> colors;

  const _FeatureCard({required this.text, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          height: 1.5,
        ),
      ),
    );
  }
}
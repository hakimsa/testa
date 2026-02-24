import 'package:flutter/material.dart';
import 'package:testa/controllers/employee_controller.dart';
import 'package:testa/screens/employe_for_screen.dart';
import 'package:testa/widget/employe_card.dart';
import 'package:testa/widget/employe_detalle.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final EmployeController _controller = EmployeController();

  @override
  void initState() {
    super.initState();
    _controller.loadEmployees();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Navigate to detail ──────────────────────────────────────────
  Future<void> _goDetail(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeDetailScreen(
          employee: _controller.employees[index],
          controller: _controller,
        ),
      ),
    );
  }

  // ── Navigate to create form ─────────────────────────────────────
  Future<void> _goCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeFormScreen(controller: _controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(

        children: [
          Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 3, 201, 201),
                Color.fromARGB(255, 2, 40, 90),
                Color(0xFFFFFFFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          )),
      
   
                const SizedBox(height: 30),
            
                // ── Header ────────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Empleados',
                            style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 2),
                        Text(
                          '${_controller.employees.length} registros',
                          style: const TextStyle(
                              fontSize: 13, color: Color(0xFF9E9E9E)),
                        ),
                      ],
                    ),
                    // Refresh button
                    if (_controller.isLoading)
                      const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Color(0xFF1A1A1A)),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh_rounded,
                            color: Color(0xFF1A1A1A)),
                        onPressed: _controller.loadEmployees,
                      ),
                  ],
                ),
            
                const SizedBox(height: 24),
            
                // ── Employee list ─────────────────────────────────────
                Container(
                  constraints: const BoxConstraints(maxHeight: 380),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _buildList(),
                ),
            
                const SizedBox(height: 20),
            
                // ── Action buttons ────────────────────────────────────
                Row(
                  children: [
                    _ActionButton(
                      label: 'Agregar',
                      icon: Icons.add_rounded,
                      onPressed: _goCreate,
                    ),
                    const SizedBox(width: 10),
                    _ActionButton(
                      label: 'Actualizar',
                      icon: Icons.refresh_rounded,
                      onPressed: _controller.loadEmployees,
                    ),
                  ],
                ),
            
                const SizedBox(height: 28),
            
                // ── Feature cards ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics:  BouncingScrollPhysics(),  // ← scroll horizontal propio
                      children: const [
                        _FeatureCard(
                          text: 'New feature en producción — rama main',
                          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                        ),
                        SizedBox(width: 12),
                        _FeatureCard(
                          text: 'Novedades del release en rama main',
                          colors: [Color(0xFF373B44), Color(0xFF4286f4)],
                        ),
                        SizedBox(width: 12),
                        _FeatureCard(
                          text: 'Novedades del release en rama main',
                          colors: [Color.fromARGB(255, 9, 32, 86), Color(0xFF4286f4)],
                        ),
                        SizedBox(width: 12),
                        _FeatureCard(
                          text: 'Descripción completa del nuevo feature',
                          colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
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
                ),
            
                const SizedBox(height: 30),
              ],
            ),
          );
        
      
        
  
    
  
  }

  // ── List builder ────────────────────────────────────────────────
  Widget _buildList() {
    if (_controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
            color: Color(0xFF1A1A1A), strokeWidth: 2),
      );
    }

    if (_controller.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  color: Color(0xFF9E9E9E), size: 36),
              const SizedBox(height: 10),
              Text(
                _controller.error!,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _controller.loadEmployees,
                child: const Text('Reintentar',
                    style: TextStyle(color: Color(0xFF1A1A1A))),
              )
            ],
          ),
        ),
      );
    }

    if (_controller.employees.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline,
                color: Color(0xFF9E9E9E), size: 36),
            SizedBox(height: 8),
            Text('No hay empleados',
                style:
                    TextStyle(fontSize: 13, color: Color(0xFF9E9E9E))),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _controller.employees.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
      itemBuilder: (_, i) => EmployeCard(
        employee: _controller.employees[i],
        onTap: () => _goDetail(i),
      ),
    );
  }
}

// ── Reusable action button ──────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16, color: const Color(0xFF1A1A1A)),
        label: Text(label,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF1A1A1A))),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

// ── Feature card ────────────────────────────────────────────────────────────────
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
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 13, height: 1.5)),
    );
  }
}
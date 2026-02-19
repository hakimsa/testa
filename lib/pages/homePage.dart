import 'package:flutter/material.dart';
import 'package:testa/models/employe.dart';
import 'package:testa/services/employeProvider.dart';

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pagestate();
}

Employeprovider employeprovider = Employeprovider();
@override
void initState() {
  employeprovider.getUsers();
}

class _home_pagestate extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      employeprovider.getUsers();
    });
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: FutureBuilder<List<Employe>>(
              future: employeprovider.getUsers(),
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<List<Employe>> snapshot,
                  ) {
                    // 🔄 Mientras carga
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // ❌ Si hay error
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    // ⚠️ Si no hay datos
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Column(
                          children: [
                            Divider(),
                            CircularProgressIndicator(color: Colors.purple),
                            Text('No hay empleados disponibles'),
                          ],
                        ),
                      );
                    }

                    // ✅ Cuando hay datos
                    final employees = snapshot.data!;

                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _cardlistEmployee(context, employees, index);
                      },
                    );
                  },
            ),
          ),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 25,
                  color: Colors.amberAccent,
                  child: Text("description completa "),
                ),
                Container(
                  child: Text("ver mas Detalles cd "),
                  height: 25,
                  color: const Color.fromARGB(255, 13, 180, 157),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Card _cardlistEmployee(
    BuildContext context,
    List<Employe> employees,
    int index,
  ) {
    final employee = employees[index];
    return Card(
      margin: EdgeInsets.only(top: 12.55),
      child: ListTile(
        title: Text(employee.name), // ajusta según tu modelo
        subtitle: Text(employee.email),
        leading: SizedBox(
          width: 45,
          height: 45,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), // opcional
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/no-image.png',
              image: (employee.imageUrl.isNotEmpty)
                  ? employee.imageUrl
                  : 'https://via.placeholder.com/25',
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/no-image.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        trailing: Text(employee.jobTitle), // si existe
      ),
    );
  }
}

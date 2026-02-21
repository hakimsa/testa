import 'package:flutter/material.dart';
import 'package:testa/models/employe.dart';
import 'package:testa/services/employeProvider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _Homepagetate();
}
Employeprovider employeprovider = Employeprovider();
@override
void initState() {
  employeprovider.getUsers();
  
}
class _Homepagetate extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      employeprovider.getUsers();
    });
    return Scaffold(

     body: ListView(
      children: [
      SizedBox(height: 200,child:   FutureBuilder<List<Employe>>(
  future: employeprovider.getUsers(),
  builder: (BuildContext context, AsyncSnapshot<List<Employe>> snapshot) {
    
    // 🔄 Mientras carga
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // ❌ Si hay error
    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    // ⚠️ Si no hay datos
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child:Column(children: [
          Divider(),
          CircularProgressIndicator(color: Color.fromARGB(255, 180, 15, 209),),
           Text('No hay empleados ok disponibles')
        ],),
      );
    }

    //  Cuando hay datos
    final employees = snapshot.data!;

    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (BuildContext context, int index) {
        return  _cardlistEmployee(context,employees,index);
      },
    );
  },
),)
    , SizedBox(height: 100,child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [Container(width: 250,height: 225,color: const Color.fromARGB(255, 74, 4, 38),child: Text("descriptiiiion completa nuevo feature Production new tag recien en prod  rama main ",style: TextStyle(color: Colors.white),),),Container(width: 150,height: 225,color: const Color.fromARGB(255, 130, 124, 35),child: Text("ver mas Detalles aqui "),),],
    ),)
     
      ],
     )

 );

  }
  
 Card _cardlistEmployee(BuildContext context, List<Employe> employees, int index) {
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
            trailing: Text(employee.jobTitle),// si existe
          ),
        );
  }
}
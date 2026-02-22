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
        SizedBox(height: 30,),
      SizedBox(height: 300,child:   FutureBuilder<List<Employe>>(
  future: employeprovider.getUsers(),
  builder: (BuildContext context, AsyncSnapshot<List<Employe>> snapshot) {
    
    // Mientras carga
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Si hay error
    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: const Color.fromARGB(255, 192, 16, 3), size: 50),
             CircularProgressIndicator(color: Color.fromARGB(255, 242, 68, 5),),
            SizedBox(height: 10),
            Text('Error al cargar empleados'),
          ],
        ),
      );
    }

    // Si no hay datos
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
),),SizedBox.fromSize(size: Size.fromHeight(20),)
    , Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        
        Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
           gradient: LinearGradient(
            colors: [Color.fromARGB(220, 2, 69, 46), Color.fromARGB(220, 1, 57, 6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(15),width: 250,height: 225,child: Text("New feature Production new tag recien en prod  rama main ",style: TextStyle(color: Colors.white),),),
         Container(
          decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Color.fromARGB(220, 0, 0, 0), Color.fromARGB(220, 208, 226, 13)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          ),
        padding: EdgeInsets.all(15),width: 250,height: 225,child: Text("Description for  completa nuevo feature Production new tag recien en prod  rama main ",style: TextStyle(color: Colors.white),),)
        ,Container(
          decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Color.fromARGB(220, 1, 48, 32), Color.fromARGB(220, 1, 65, 44)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          ),
        padding: EdgeInsets.all(15),width: 250,height: 225,child: Text("Description for  completa nuevo feature Production new tag recien en prod  rama main ",style: TextStyle(color: Colors.white),),)
        
      ]),
     Divider(color: Colors.indigo,)
      ],
     )


 );

  }
  
 Card _cardlistEmployee(BuildContext context, List<Employe> employees, int index) {
final employee = employees[index];
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.55,horizontal: 10),
          child: ListTile(
            title: Text(employee.name), // ajusta según tu modelo
            subtitle: Text(employee.email), 
            contentPadding: EdgeInsets.all(10),
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
            trailing: Text(employee.jobTitle),
            textColor: const Color.fromARGB(221, 73, 72, 72),// si existe
          ),
        );
  }
}
// To parse this JSON data, do
//
//     final employe = employeFromJson(jsonString);

import 'dart:convert';

Employe employeFromJson(String str) => Employe.fromJson(json.decode(str));

String employeToJson(Employe data) => json.encode(data.toJson());

class Employes {
  List<Employe> items = [];

  Employes();

  Employes.fromJsonList(List<dynamic> jsonList) {
   
    for (var item in jsonList) {
      final user = Employe.fromJson(item);
      items.add(user);
    }
  }
}

class Employe {
    int id;
    String name;
    String email;
    String jobTitle;
    String phone;
    String imageUrl;
    String employeeCode;
    bool active;
    dynamic dateContract;

    Employe({
        required this.id,
        required this.name,
        required this.email,
        required this.jobTitle,
        required this.phone,
        required this.imageUrl,
        required this.employeeCode,
        required this.active,
        required this.dateContract,
    });

    factory Employe.fromJson(Map<String, dynamic> json) => Employe(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        jobTitle: json["jobTitle"],
        phone: json["phone"],
        imageUrl: json["imageUrl"],
        employeeCode: json["employeeCode"],
        active: json["active"],
        dateContract: json["dateContract"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "jobTitle": jobTitle,
        "phone": phone,
        "imageUrl": imageUrl,
        "employeeCode": employeeCode,
        "active": active,
        "dateContract": dateContract,
    };
}

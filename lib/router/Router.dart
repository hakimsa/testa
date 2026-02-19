

import 'package:flutter/material.dart';

import '../pages/home_page.dart';

Map<String,WidgetBuilder>getApplitionRoute  (){
 
return <String,WidgetBuilder>{

'/':(context)=> HomePage()

};


}
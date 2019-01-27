import 'package:flutter/material.dart';
import 'package:catalogue/screens/home_page.dart';

import 'app_data.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: appName,
      theme: ThemeData(primarySwatch: appPrimarySwatch),
      home: HomePage(),

    );
  }
}
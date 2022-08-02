import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:user_list/model/user_data.dart';
import 'package:user_list/pages/home_page.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

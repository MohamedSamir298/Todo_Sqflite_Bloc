import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_abdullah_mansour_course/home_screen.dart';
import 'package:todo_app_abdullah_mansour_course/shared_pref/cache_helper.dart';
import 'cubit/blocObserver.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBLocObserver();
  // await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
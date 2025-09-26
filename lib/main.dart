import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes_aplikasi/providers/task_providers.dart';
import 'screens/splash_screen.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // ✅ tampil pertama kali
    );
  }
}

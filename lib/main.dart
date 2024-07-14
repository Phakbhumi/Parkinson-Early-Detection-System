import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'data/display_provider.dart';
import 'route/router.dart';
import 'package:provider/provider.dart';
import 'data/firebase_options.dart';
import 'data/results_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DiagnosisDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DisplaynameProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:fix_mates_admin/const/constant.dart';
import 'package:fix_mates_admin/firebase_options.dart';
import 'package:fix_mates_admin/provider/side_menu_provider.dart';
import 'package:fix_mates_admin/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (context) => SideMenuProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        brightness: Brightness.dark,
      ),
      home: MainScreen(),
    );
  }
}

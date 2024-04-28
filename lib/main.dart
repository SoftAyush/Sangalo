import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:kharcha_manager/Models/Account.dart';
import 'package:kharcha_manager/Models/Category.dart';
import 'package:kharcha_manager/Screens/SideBar.dart';
import 'package:kharcha_manager/Supports/Global.dart';
import 'package:kharcha_manager/Theme/DarkTheme.dart';
import 'package:kharcha_manager/Theme/LightTheme.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationSupportDirectory();
  isar = await Isar.open(
    [
      AccountSchema,
      CategorySchema,
    ],
    directory: dir.path,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: DarkAppTheme().darkTheme,
      theme: AppTheme().lightTheme,
      themeMode: ThemeMode.system,
      home: const Sidebar(),
    );
  }
}

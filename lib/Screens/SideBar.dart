import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:kharcha_manager/Models/Category.dart';
import 'package:kharcha_manager/Screens/Category.dart';
import 'package:kharcha_manager/Screens/Dashboard.dart';
import 'package:kharcha_manager/Screens/History.dart';
import 'package:kharcha_manager/Supports/Global.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  // final storage = const FlutterSecureStorage();
  double value = 0;
  String? username;
  String? _selectedPayType;

  @override
  void initState() {
    // TODO: implement initState
    // _readData();
    _autoInsert();
    super.initState();
  }

  _autoInsert() async {
    final catData = await isar!.categorys.where().findAll();
    if (catData.isEmpty) {
      await isar!.writeTxn(() async {
        await isar!.categorys.putAll([
          Category()
            ..type = 'income'
            ..name = 'Salary',
          Category()
            ..type = 'income'
            ..name = 'Allowance',
          Category()
            ..type = 'income'
            ..name = 'Bonus',
          Category()
            ..type = 'income'
            ..name = 'Petty Cash',
          Category()
            ..type = 'expense'
            ..name = 'Food',
          Category()
            ..type = 'expense'
            ..name = 'Social Life',
          Category()
            ..type = 'expense'
            ..name = 'Pets',
          Category()
            ..type = 'expense'
            ..name = 'Transport',
          Category()
            ..type = 'expense'
            ..name = 'Culture',
          Category()
            ..type = 'expense'
            ..name = 'HouseHold',
          Category()
            ..type = 'expense'
            ..name = 'Apparel',
          Category()
            ..type = 'expense'
            ..name = 'Beauty',
          Category()
            ..type = 'expense'
            ..name = 'Health',
          Category()
            ..type = 'expense'
            ..name = 'Education',
          Category()
            ..type = 'expense'
            ..name = 'Gift',
        ]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // _checkCategory();
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black,
        title: const Text(
          'Dashboard',
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              value == 0 ? value = 1 : value = 0;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade200,
                  Colors.blueAccent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          SafeArea(
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                NetworkImage("https://rb.gy/ozaror"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            username ?? 'Default Name',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoryWidget(),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.category_sharp,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Category',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryWidget(),
                              ),
                            );
                          },
                          leading: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          title: Text(
                            'History',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            debugPrint("Setting Clicked");
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const SettingWidget()),
                            // );
                          },
                          leading: const Icon(
                            Icons.settings,
                            color: Colors.black,
                          ),
                          title: Text(
                            'Settings',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        // ListTile(
                        //   onTap: () async {
                        //     // await _logout();
                        //   },
                        //   leading: const Icon(
                        //     Icons.logout_sharp,
                        //     color: Colors.black,
                        //   ),
                        //   title: const Text(
                        //     'Logout',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.w600,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: value),
              duration: const Duration(milliseconds: 500),
              builder: (_, double val, __) {
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(0, 3, 200 * val)
                    ..rotateY((pi / 6) * val),
                  child: ClipRRect(
                    borderRadius: value == 1
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          )
                        : val == 0 // Check if animation is completely closed
                            ? BorderRadius.zero
                            : const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                    child: const Dashboard(),
                  ),
                ));
              }),
          // GestureDetector(
          //   onTap: () {
          //     setState(() {
          //       value == 0 ? value = 1 : value = 0;
          //     });
          //   },
          // )
        ],
      ),
    );
  }
}

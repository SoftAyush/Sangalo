import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
// import 'package:isar/isar.dart';
import 'package:kharcha_manager/Models/Category.dart';
import 'package:kharcha_manager/Screens/AddCategory.dart';
import 'package:kharcha_manager/Screens/SideBar.dart';
import 'package:kharcha_manager/Supports/EnumFiles.dart';
import 'package:kharcha_manager/Supports/Global.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String? _selectedType;
  List<Category> category = [];
  List<Category> filter = [];
  @override
  initState() {
    super.initState();
    _readData();
  }

  _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height *
            0.8, // Set the desired height here
        child: const AddCategoryWidget(),
      ),
    );
  }

  _readData() async {
    final catData = isar!.categorys;
    final getData = await catData.where().findAll();
    setState(() {
      category = getData;
    });
  }

  _filter() {
    if (_selectedType == null) {
      filter = category;
    } else {
      filter = category
          .where(
            (cat) => cat.type.toLowerCase() == _selectedType!.toLowerCase(),
          )
          .toList();
    }
  }

  _deleteCategory(int catId, String category) async {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $category'),
          content: const Text("Are you sure you want to delete this category?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await isar!.writeTxn(() async {
                  await isar!.categorys.delete(catId);
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryWidget(),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category Delete Successfully.'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _filter();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Category',
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            // color: ,
            size: 30,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Sidebar(),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                child: Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  decoration: BoxDecoration(
                    // color: const Color.fromARGB(255, 40, 40, 40),
                    border: Border.all(
                      color: const Color(0xFFB3A194),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: DropdownButton(
                    value: _selectedType,
                    items: Type.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type.name,
                            child: Text(
                              type.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (dynamic value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color.fromARGB(255, 239, 153, 16),
                      fontWeight: FontWeight.w600,
                    ),
                    hint: Text(
                      'Select the Type',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFFB3A194),
                      size: 24,
                    ),
                    // dropdownColor: const Color.fromARGB(255, 40, 40, 40),
                    elevation: 2,
                    underline: Container(
                      height: 0,
                      color: const Color(0xFFB3A194),
                    ),
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.25,
                child: ListView.builder(
                  itemCount: filter.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 179, 161, 148),
                        ),
                      ),
                      margin:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filter[index].name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 5, 0, 0),
                                  child: Text(
                                    filter[index].type,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 186, 31, 51),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  debugPrint('Icon Button Clicked In Category');
                                  debugPrint(
                                      'Category Id : ${filter[index].catId}');
                                  await _deleteCategory(
                                    filter[index].catId,
                                    filter[index].name,
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_forever_sharp,
                                  color: Color.fromARGB(255, 186, 31, 51),
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _openAddExpenseOverlay();
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

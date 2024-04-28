import 'package:flutter/material.dart';
import 'package:kharcha_manager/Models/Category.dart';
import 'package:kharcha_manager/Screens/Category.dart';
import 'package:kharcha_manager/Supports/EnumFiles.dart';
import 'package:kharcha_manager/Supports/Global.dart';

class AddCategoryWidget extends StatefulWidget {
  const AddCategoryWidget({super.key});

  @override
  State<AddCategoryWidget> createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final categoryController = TextEditingController();
  String? _selectedType;

  _saveCat() async {
    final cat = isar!.categorys;
    if (_selectedType == null || categoryController.text.isNotEmpty) {
      final Category newCategory = Category()
        ..type = _selectedType!
        ..name = categoryController.text.trim();
      await isar!.writeTxn(() async {
        await cat.put(newCategory);
      });
      setState(() {
        categoryController.clear();
        _selectedType = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(
            seconds: 5,
          ),
          content: Text('Category Add Successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(
            seconds: 5,
          ),
          content: Text("Don't Leave Empty Field."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(-1, -1),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: ExcludeSemantics(
                          child: Text(
                            'Type',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                    Container(
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
                        style: Theme.of(context).textTheme.titleLarge,
                        hint: Text(
                          'Select the Type',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFFB3A194),
                          size: 24,
                        ),
                        dropdownColor: const Color.fromARGB(255, 40, 40, 40),
                        elevation: 2,
                        underline: Container(
                          height: 0,
                          color: const Color(0xFFB3A194),
                        ),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Align(
                alignment: const AlignmentDirectional(0, -1),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 8),
                      child: ExcludeSemantics(
                        child: Text(
                          'Category',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: categoryController,
                        // focusNode: unfocusNode,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Food',
                          hintStyle: Theme.of(context).textTheme.titleLarge,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 179, 161, 148),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 239, 153, 16),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 255, 89, 99),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 255, 89, 99),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                              15, 0, 15, 0),
                          prefixIcon: const Icon(
                            Icons.category_sharp,
                            color: Color.fromARGB(255, 179, 161, 148),
                            size: 20,
                          ),
                        ),
                        style: Theme.of(context).textTheme.titleLarge,
                        cursorColor: const Color.fromARGB(255, 40, 40, 40),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoryWidget(),
                      ),
                    );
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _saveCat();
                  },
                  child: Text(
                    'Save Category',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

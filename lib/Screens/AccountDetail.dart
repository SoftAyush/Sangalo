import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:kharcha_manager/Models/Account.dart';
import 'package:kharcha_manager/Models/Category.dart';
import 'package:kharcha_manager/Screens/SideBar.dart';
import 'package:kharcha_manager/Supports/EnumFiles.dart';
import 'package:kharcha_manager/Supports/Global.dart';

class AccountDetailWidget extends StatefulWidget {
  const AccountDetailWidget({super.key});

  @override
  State<AccountDetailWidget> createState() => _AccountDetailWidgetState();
}

class _AccountDetailWidgetState extends State<AccountDetailWidget> {
  // Define variables to hold form values
  final paishaController = TextEditingController();
  final descriptionsController = TextEditingController();
  final dateController = TextEditingController();

  String? _selectedType;
  String? _selectedCategory;
  String? _selectedPayType;
  List<Category> categoryByIncome = [];
  List<Category> categoryByExpenses = [];

  @override
  initState() {
    super.initState();
    _readData();
  }

  _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate!);
    });
  }

  _save() async {
    final account = isar!.accounts;
    final type = _selectedType;
    final category = _selectedCategory;
    final payType = _selectedPayType;
    final money = double.tryParse(paishaController.text);
    final dateText = dateController.text;
    final description = descriptionsController.text.trim();

    if (type != null &&
        category != null &&
        payType != null &&
        money != null &&
        dateText.isNotEmpty &&
        description.isNotEmpty) {
      final DateTime date = DateTime.tryParse(dateText)!;
      final newAccount = Account()
        ..type = type
        ..category = category
        ..payType = payType
        ..money = money
        ..date = date
        ..description = description;
      debugPrint('Current Datetime: $date');
      await isar!.writeTxn(() async {
        await account.put(newAccount);
      });
      setState(() {
        paishaController.clear();
        dateController.clear();
        descriptionsController.clear();
        _selectedType = null;
        _selectedCategory = null;
        _selectedPayType = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data Add Successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please don't Leave empty field."),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  _readData() async {
    final catData = isar!.categorys;
    final getIncomeData =
        await catData.where().filter().typeEqualTo('income').findAll();
    final getExpensesData =
        await catData.where().filter().typeEqualTo('expense').findAll();
    setState(() {
      categoryByIncome = getIncomeData;
      categoryByExpenses = getExpensesData;
    });
  }

  List<Object> getCategoryByTypes(String type) {
    switch (type) {
      case "income":
        return categoryByIncome.map((category) => category.name).toList();
      case "expense":
        return categoryByExpenses.map((category) => category.name).toList();
      default:
        return [];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    paishaController.dispose();
    dateController.dispose();
    descriptionsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Detail',
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, -1),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
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
                                  _selectedCategory = null;
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
                              // dropdownColor:
                              //     const Color.fromARGB(255, 40, 40, 40),
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
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, -1),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: ExcludeSemantics(
                                child: Text(
                                  'Category',
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
                              value: _selectedCategory,
                              items: _selectedType != null
                                  ? getCategoryByTypes(_selectedType!)
                                      .map((cat) {
                                      return DropdownMenuItem(
                                        value: cat,
                                        child: Text(
                                          cat.toString(),
                                        ),
                                      );
                                    }).toList()
                                  : null,
                              onChanged: (dynamic value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromARGB(255, 239, 153, 16),
                                fontWeight: FontWeight.w600,
                              ),
                              hint: Text(
                                'Select the Category',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFFB3A194),
                                size: 24,
                              ),
                              // dropdownColor:
                              //     const Color.fromARGB(255, 40, 40, 40),
                              elevation: 2,
                              underline: Container(
                                height: 0,
                                color: const Color(0xFFB3A194),
                              ),
                              isExpanded: true,
                            ),
                          )
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
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, -1),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 10),
                              child: ExcludeSemantics(
                                child: Text(
                                  'Pay Type',
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
                              value: _selectedPayType,
                              items: PayType.values
                                  .map(
                                    (payType) => DropdownMenuItem(
                                      value: payType.name,
                                      child: Text(
                                        payType.name.toUpperCase(),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (dynamic value) {
                                if (value == null) {
                                  return;
                                }
                                setState(() {
                                  _selectedPayType = value;
                                });
                              },
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Color.fromARGB(255, 239, 153, 16),
                                fontWeight: FontWeight.w600,
                              ),
                              hint: Text(
                                'Select the Pay Type',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFFB3A194),
                                size: 24,
                              ),
                              // dropdownColor:
                              //     const Color.fromARGB(255, 40, 40, 40),
                              elevation: 2,
                              underline: Container(
                                height: 0,
                                color: const Color(0xFFB3A194),
                              ),
                              isExpanded: true,
                            ),
                          )
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 0, 8),
                            child: ExcludeSemantics(
                              child: Text(
                                'Amount',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: Semantics(
                              label: 'Enter your Money',
                              child: TextFormField(
                                controller: paishaController,
                                // focusNode: unfocusNode,
                                keyboardType: TextInputType.number,
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: '80000.00',
                                  hintStyle:
                                      Theme.of(context).textTheme.titleLarge,
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
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          15, 0, 15, 0),
                                  prefixIcon: const Icon(
                                    Icons.monetization_on_sharp,
                                    color: Color.fromARGB(255, 179, 161, 148),
                                    size: 20,
                                  ),
                                ),
                                style: Theme.of(context).textTheme.titleLarge,
                                cursorColor:
                                    const Color.fromARGB(255, 40, 40, 40),
                              ),
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 0, 8),
                            child: ExcludeSemantics(
                              child: Text(
                                'Date',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 350,
                            child: Semantics(
                              label: 'Enter your Date',
                              child: TextFormField(
                                controller: dateController,
                                // focusNode: unfocusNode,
                                keyboardType: TextInputType.datetime,
                                autofocus: false,
                                obscureText: false,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: dateController.text.isEmpty
                                      ? 'No Date Selected'
                                      : dateController.text,
                                  hintStyle:
                                      Theme.of(context).textTheme.titleLarge,
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
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          15, 0, 15, 0),
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      await _presentDatePicker();
                                    },
                                    child: const Icon(
                                      Icons.date_range_sharp,
                                      color: Color.fromARGB(255, 179, 161, 148),
                                      size: 30,
                                    ),
                                  ),
                                ),
                                style: Theme.of(context).textTheme.titleLarge,
                                cursorColor:
                                    const Color.fromARGB(255, 40, 40, 40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 0),
                  child: Container(
                    width: double.infinity,
                    height: 115,
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: ExcludeSemantics(
                            child: Text(
                              'Description',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 10, 8, 0),
                          child: Semantics(
                            label: 'Enter a Descriptions',
                            child: TextFormField(
                              controller: descriptionsController,
                              autofocus: false,
                              obscureText: false,
                              maxLength: 150,
                              decoration: InputDecoration(
                                hintText: 'Descriptions',
                                hintStyle:
                                    Theme.of(context).textTheme.titleLarge,
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
                                contentPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        15, 0, 15, 0),
                                prefixIcon: const Icon(
                                  Icons.description_sharp,
                                  color: Color.fromARGB(255, 179, 161, 148),
                                  size: 20,
                                ),
                              ),
                              style: Theme.of(context).textTheme.titleLarge,
                              cursorColor:
                                  const Color.fromARGB(255, 40, 40, 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await _save();
                  },
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:kharcha_manager/Models/Account.dart';
import 'package:kharcha_manager/Models/Category.dart';
import 'package:kharcha_manager/Screens/AccountDetail.dart';
import 'package:kharcha_manager/Supports/Global.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double income = 00.00;
  double expenses = 00.00;
  int touchedIndex = -1;
  List<Category> category = [];
  String? _selectedPayType;
  String openingBalance = 'OB';
  final moneyController = TextEditingController();
  final payTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readAccountData();
    _readData();
    // _alertOB();
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 160.0 : 150.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.green,
            value: income,
            title: 'Income',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: expenses,
            title: 'Expenses',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }

  _readAccountData() async {
    final accountData = isar!.accounts;
    final getData = await accountData.where().findAll();
    final checkOb = getData.where((ob) => ob.category == openingBalance);
    double incomeSum = 0.0;
    double expensesSum = 0.0;
    for (var data in getData) {
      if (data.type == 'income') {
        incomeSum += data.money;
      } else if (data.type == 'expense') {
        expensesSum += data.money;
      }
    }
    setState(() {
      income = incomeSum == 0.0 ? 1.0 : incomeSum;
      expenses = expensesSum == 0.0 ? 1.0 : expensesSum;
    });
    if (checkOb.isEmpty) {
      await _askOB();
    }
  }

  _readData() async {
    final catData = isar!.categorys;
    final getData = await catData.where().findAll();
    setState(() {
      category = getData;
      // _checkCategory();
    });
  }

  _askOB() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Opening Balance',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please add your opening balance and select your pay type:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  controller: moneyController,
                  // focusNode: unfocusNode,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: '80000.00',
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
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    prefixIcon: const Icon(
                      Icons.monetization_on_sharp,
                      color: Color.fromARGB(255, 179, 161, 148),
                      size: 20,
                    ),
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                  cursorColor: const Color.fromARGB(255, 40, 40, 40),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  controller: payTypeController,
                  // focusNode: unfocusNode,
                  keyboardType: TextInputType
                      .text, // Use TextInputType.text for text input
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Enter cash, bank, or wallet',
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
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    prefixIcon: const Icon(
                      Icons.monetization_on_sharp,
                      color: Color.fromARGB(255, 179, 161, 148),
                      size: 20,
                    ),
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                  cursorColor: const Color.fromARGB(255, 40, 40, 40),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pay type';
                    }
                    // Regular expression to match "cash", "bank", or "wallet"
                    RegExp regExp =
                        RegExp(r'^(cash|bank|wallet)$', caseSensitive: false);
                    if (!regExp.hasMatch(value)) {
                      return 'Please enter valid pay type (cash, bank, or wallet)';
                    }
                    return null; // Returning null means the input is valid
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final account = isar!.accounts;
                final DateTime date = DateTime.now();
                final newAccounts = Account()
                  ..type = 'income'
                  ..category = openingBalance
                  ..payType = payTypeController.text
                  ..money = double.tryParse(moneyController.text)!
                  ..date = date
                  ..description = '';
                debugPrint('Current Datetime: $date');
                await isar!.writeTxn(() async {
                  await account.put(newAccounts);
                });
                debugPrint('Data Store From alert Box.');
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Income',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'RS.$income',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Expenses',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'RS.$expenses',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Chart',
                  style: Theme.of(context).textTheme.titleLarge,
                  // TextStyle(
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 30,
                  //   color: Colors.white,
                  // ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 0,
                          sections: showingSections(),
                        ),
                        swapAnimationDuration:
                            const Duration(milliseconds: 150),
                        swapAnimationCurve: Curves.linear,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountDetailWidget(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}

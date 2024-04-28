import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:kharcha_manager/Models/Account.dart';
import 'package:kharcha_manager/Screens/SideBar.dart';
import 'package:kharcha_manager/Supports/EnumFiles.dart';
import 'package:kharcha_manager/Supports/Global.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  String? _selectedType;
  List<Account> transactions = [];
  List<Account> filter = [];

  @override
  initState() {
    super.initState();
    _readAccountData();
  }

  _readAccountData() async {
    final accountData = isar!.accounts;
    final getData = await accountData.where().findAll();
    setState(() {
      transactions = getData;
    });
  }

  _filter() {
    if (_selectedType == null) {
      filter = transactions;
    } else {
      filter = transactions
          .where(
            (cat) => cat.type.toLowerCase() == _selectedType!.toLowerCase(),
          )
          .toList();
    }
  }

  Color getStatusColor(String type) {
    switch (type) {
      case 'expense':
        return const Color.fromARGB(255, 254, 132, 55);
      case 'income':
        return const Color.fromARGB(255, 54, 104, 11);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    _filter();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account History',
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
                    dropdownColor: const Color.fromARGB(255, 40, 40, 40),
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
                    String formattedDateTime =
                        DateFormat("yyyy-MM-dd").format(filter[index].date);

                    return Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
                      child: Container(
                        height: 160,
                        constraints: const BoxConstraints(
                          minWidth: 340,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(filter[index].type),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              // color: AppTheme.of(context).secondaryText,
                              offset: Offset(0, 2),
                            )
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              15, 10, 15, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
                                child: SizedBox(
                                  width: 315,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        filter[index].money.toString() ??
                                            '10000.00',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Date : $formattedDateTime',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Text(
                                        'Transactions : ${filter[index].payType}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Type: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            filter[index].type,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Text(
                                            'Category:  ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          Text(
                                            filter[index].category,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}

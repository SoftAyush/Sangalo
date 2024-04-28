import 'package:isar/isar.dart';

part 'Account.g.dart';

@Collection()
class Account {
  Id localId = Isar.autoIncrement;
  late String type;
  late String category;
  late String payType;
  late double money;
  late DateTime date;
  late String description;
}

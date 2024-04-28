import 'package:isar/isar.dart';

part 'Category.g.dart';

@Collection()
class Category {
  Id catId = Isar.autoIncrement;
  late String name;
  late String type;
}

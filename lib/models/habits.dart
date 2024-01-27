import 'package:isar/isar.dart';

//run cmdg to generate file:dart run build_runner build
part 'habits.g.dart';

@Collection()
class Habit {

  Id id = Isar.autoIncrement;
  late String name;
  List<DateTime> completeDays = [];
}
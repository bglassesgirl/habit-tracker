import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habits.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // SETUP

  // INITIALIZE
  static Future<void> initialize() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }
  // SAVE FIRST DATE STARTUP
  Future<void> saveFirstLaunchData() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // GET FIRSST APP DATE STARTUP
  Future<DateTime?> getFirstLaunchData() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // => CRUD OPERATIONS

  // LISTS OF HABITS
  final List<Habit> currentHabits = [];

  // CREATE
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;
    // save - db
    await isar.writeTxn(() => isar.habits.put(newHabit));
    // re-read from db
    readyHabits();
  }

  //READ
  Future<void> readyHabits() async {
    // fetch all habits from db
    List<Habit> fetchHabits = await isar.habits.where().findAll();
    // give to current habtis
    currentHabits.clear();
    currentHabits.addAll(fetchHabits);
    // update
    notifyListeners();
  }

  // UPDATE
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific  habit
    final habit = await isar.habits.get(id);
    // update
    if (habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed ->add the current date to the completeddDays list
        if (isCompleted && !habit.completeDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();
          // add the current date if it not already in the list
          habit.completeDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        } else {
          // remove the current date if the habit is not marked as completed
          habit.completeDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        // save the update habit back to the db
        await isar.habits.put(habit);
      });
    }

  }

  // UPDATE
  Future<void> updateHabitName (int id, String newName) async {
    // find the spicific habit
    final habit = await isar.habits.get(id);

    // update habit name
    if (habit != null) {
         await isar.writeTxn(() async {
            habit.name = newName;
            await isar.habits.put(habit);
         });
    }
    readyHabits();
  }

  // DELETE
  Future<void> deleteHabit(int id) async {
      // delete
      await isar.writeTxn(() async{
          await isar.habits.delete(id);
      });
      readyHabits();
  }
}

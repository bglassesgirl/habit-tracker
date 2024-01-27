import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habits.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  // SETUP

  // INITIALIZE
  static Future<void> initialize () async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open([HabitSchema, AppSettingsSchema],
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

  // CRUD OPERATIONS

  // LISTS OF HABITS

  // CREATE

  //READ

  // UPDATE

  // UPDATE

  // DELETE
}
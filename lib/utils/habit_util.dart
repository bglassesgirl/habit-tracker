// given a habit list of completion days
// is this habit completed today

import '../models/habits.dart';

bool isHabitCompletedToday(List<DateTime> completedDays) {
  final today = DateTime.now();
  return completedDays.any((date) =>
  date.year == today.year &&
  date.month == today.month &&
  date.day == today.day,
  );
}

// prepare the heat map dataset
Map<DateTime, int> prepHeatDataset(List<Habit> habits){
  Map<DateTime, int> dataset = {};

  for (var habit in habits) {
    for (var date in habit.completeDays) {
      //avoid time mismatch
      final normalizedDate = DateTime(date.year, date.month, date.day);
        // if exists, increment count
      if (dataset.containsKey(normalizedDate)) {
        dataset[normalizedDate] = dataset[normalizedDate]! + 1;
      } else {
        dataset[normalizedDate] = 1;
      }
    }
  }
  return dataset;
}
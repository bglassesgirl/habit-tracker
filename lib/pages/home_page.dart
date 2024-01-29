import 'package:flutter/material.dart';
import 'package:habit_tracker/components/drawer.dart';
import 'package:habit_tracker/components/habit_tittle.dart';
import 'package:habit_tracker/detabase/habit_detabase.dart';
import 'package:habit_tracker/models/habits.dart';
import 'package:provider/provider.dart';
import '../utils/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readyHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();

  // create habits
  void createNewHabits() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: "Adicione um novo hábito",
          ),
        ),
        actions: [
          // save button
          // cria um botao e quando pressionado ele salva no banco e volta pra tela anterior
          MaterialButton(
            onPressed: () {
              // get the habit named
              String habitName = textController.text;
              context.read<HabitDatabase>().addHabit(habitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Salvar'),
          ),

          // cancel button
          // it creates a button - on pressed he goes back (POP) to the latest screm
          // cria um buttao e ao ser pressionado ele apaga e volta pra tela anterior
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  // check habit, ON/OFF
  void checkValueOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  // edit habit
  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          MaterialButton(
            onPressed: () {
              String habitName = textController.text;
              context
                  .read<HabitDatabase>()
                  .updateHabitName(habit.id, habitName);
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Salvar'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  // delete habit
  void deleteHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vocé tem certeza que deseja deletar?'),
        actions: [
          MaterialButton(
            onPressed: () {
              context
                  .read<HabitDatabase>()
                  .deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,

      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabits,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitsList(),
    );
  }

  Widget _buildHabitsList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();
    // current
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        // get each habit
        final habit = currentHabits[index];
        // check if the habit is completed td
        bool isCompletedToday = isHabitCompletedToday(habit.completeDays);
        // return habit tittle
        return HabitTittle(
          isCompleted: isCompletedToday,
          text: habit.name,
          onChanged: (value) => checkValueOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}

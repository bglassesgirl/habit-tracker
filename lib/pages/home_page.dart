import 'package:flutter/material.dart';
import 'package:habit_tracker/components/drawer.dart';
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
            hintText:"Adicione um novo hábito",
          ),
        ),
        actions: [
          // save button
          // cria um botao e quando pressionado ele salva no banco e volta pra tela anterior
          MaterialButton(onPressed: (){
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
          MaterialButton(onPressed: (){
            Navigator.pop(context);
            textController.clear();
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
        title: const Text(''),
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

   Widget _buildHabitsList(){
      // habit db
      final habitDatabase = context.watch<HabitDatabase>();
      // current
      List<Habit> currentHabits = habitDatabase.currentHabits;
      return ListView.builder(
        itemCount: currentHabits.length,
        itemBuilder: (context, index){
            // get each habit
            final habit = currentHabits[index];
            // check if the habit is completed td
            bool isCompletedToday = isHabitCompletedToday(habit.completeDays);
            // return habit tittle
            return ListTile(
              title:Text(habit.name),
            );
        },
      );
   }
}

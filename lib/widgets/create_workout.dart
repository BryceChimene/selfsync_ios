import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../services/user_service.dart';
import '../services/workout_service.dart';
import '../widgets/dialogs.dart';

class CreateWorkoutPage extends StatefulWidget {
  final DateTime selectedDay;

  const CreateWorkoutPage({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  late TextEditingController workoutTitleController;
  late TextEditingController workoutNotesController;
  late TextEditingController durationController;

  @override
  void initState() {
    workoutTitleController = TextEditingController();
    workoutNotesController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    workoutTitleController.dispose();
    workoutNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = widget.selectedDay;

    return Scaffold(
      //Top Headerbar
      appBar: AppBar(
        shadowColor: Colors.white,
        elevation: 0.5,
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 29, 26, 49),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Goes back to previous page
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            //Page title
            const Text(
              'Build Workout',
              style: TextStyle(fontSize: 15),
            ),
            //Add workout to user
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: () async {
                if (workoutTitleController.text.isEmpty) {
                  showSnackBar(
                      context, 'Please enter a workout first, then save.');
                } else {
                  String username =
                      context.read<UserService>().currentUser.username;
                  Workout workout = Workout(
                    username: username,
                    title: workoutTitleController.text.trim(),
                    description: workoutNotesController.text.trim(),
                    date: selectedDay, //needs to get date from calendar page.
                  );
                  String result = await context
                      .read<WorkoutService>()
                      .createWorkout(workout);
                  if (result == 'Ok') {
                    showSnackBar(context, 'New workout successfully added!');
                    workoutTitleController.text = '';
                    workoutNotesController.text = '';
                    setState(() {});
                  } else {
                    showSnackBar(context, result);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('CREATE'),
            ),
          ],
        ),
      ),
      //Add exercise button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
            backgroundColor: const Color.fromARGB(255, 61, 59, 77),
            textStyle: const TextStyle(fontSize: 15),
            padding: const EdgeInsets.symmetric(vertical: 10),
            side: const BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
          ),
          onPressed: () {
            //Workout Creation dialog
          },
          child: const Text('ADD EXERCISE'),
        ),
      ),
      //Background color of page
      backgroundColor: const Color.fromARGB(255, 29, 26, 49),

      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 61, 59, 77),
        ),
        //Workout name, notes, and public option
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Workout name and public option
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
              child: Row(
                children: [
                  //Workout name
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(0),
                        hintText: 'Workout Name...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                      controller: workoutTitleController,
                    ),
                  ),
                  //public option
                  const Icon(
                    Icons.lock,
                    color: Colors.grey,
                    size: 15,
                  )
                ],
              ),
            ),
            //notes option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Add description or notes...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                ),
                minLines: 1,
                maxLines: null,
                controller: workoutNotesController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

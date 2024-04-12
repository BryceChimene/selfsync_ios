import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/exercise_service.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../services/user_service.dart';
import '../services/workout_service.dart';
import '../widgets/dialogs.dart';

class CreateWorkoutPage extends StatefulWidget {
  final DateTime selectedDay;
  final VoidCallback updateWorkouts; // updates calendar mark

  const CreateWorkoutPage(
      {super.key, required this.selectedDay, required this.updateWorkouts});

  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  late TextEditingController workoutTitleController;
  late TextEditingController workoutNotesController;
  Duration? duration;
  List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    workoutTitleController = TextEditingController();
    workoutNotesController = TextEditingController();
  }

  @override
  void dispose() {
    workoutTitleController.dispose();
    workoutNotesController.dispose();
    super.dispose();
  }

  void _addExercise() {
    setState(() {
      exercises.add(Exercise(workoutId: 1)); // Add a new Exercise object
    });
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
              style: TextStyle(fontSize: 17, color: Colors.white),
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
                      context, 'Please enter a workout first, then create.');
                } else {
                  String username =
                      context.read<UserService>().currentUser.username;
                  Workout workout = Workout(
                    username: username,
                    title: workoutTitleController.text.trim(),
                    description: workoutNotesController.text.trim(),
                    date: selectedDay,
                  );

                  String result = await context
                      .read<WorkoutService>()
                      .createWorkout(workout);

                  if (result == 'Ok') {
                    showSnackBar(context, 'New workout successfully created!');
                    workoutTitleController.text = '';
                    workoutNotesController.text = '';
                    for (Exercise exercise in exercises) {
                      exercise.workoutId = workout.id!;
                      await context
                          .read<ExerciseService>()
                          .createExercise(exercise);
                    }
                    //Updates the calendar mark for this workout
                    widget.updateWorkouts();
                    Navigator.pop(context);
                  } else {
                    showSnackBar(context, result);
                  }
                }
              },
              child: const Text('CREATE'),
            ),
          ],
        ),
      ),

      //Add exercise button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          bottom: 40,
          top: 20,
          left: 15,
          right: 15,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 61, 59, 77),
            foregroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: Colors.blueAccent, width: 2),
            ),
          ),
          onPressed: () {
            _addExercise();
            print(exercises);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text(
              'ADD EXERCISE',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),

      //Background color of entire page
      backgroundColor: const Color.fromARGB(255, 29, 26, 49),

      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 61, 59, 77),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Workout title and privacy option
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
                  child: Row(
                    children: [
                      //Workout Title
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.name,
                          cursorColor: Colors.grey,
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
                            border: UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                          controller: workoutTitleController,
                        ),
                      ),
                      //Privacy option
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _displayPrivacySheet(context);
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.lock,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                              WidgetSpan(
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Description option
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    cursorColor: Colors.grey,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color.fromARGB(255, 194, 193, 193),
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

                //Duration/Difficulty
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Duration option
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            _displayDurationSheet(context);
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Text(
                                    duration != null
                                        ? "${duration!.inHours}:${(duration!.inMinutes % 60).toString().padLeft(2, '0')}"
                                        : "---",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                const TextSpan(
                                    text: '\nEst. Duration',
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.black54,
                          indent: 8,
                          endIndent: 8,
                        ),
                        //Difficulty option
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {},
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Text(
                                    'Easy',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                TextSpan(
                                    text: '\nEst. Difficulty',
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: ExerciseCard(
                      exercise: exercises[index],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Bottom Sheet to Modify Duration of workout
  Future _displayDurationSheet(BuildContext context) async {
    Duration tempDuration = duration ?? Duration.zero;
    // ignore: unused_local_variable
    final newDuration = await showModalBottomSheet<Duration>(
      showDragHandle: false,
      isDismissible: true,
      backgroundColor: const Color.fromARGB(255, 61, 59, 77),
      context: context,
      builder: (context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Text(
                      'Modify Duration',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context, tempDuration);
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoTheme(
              data: const CupertinoThemeData(
                brightness: Brightness.dark,
              ),
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hm,
                initialTimerDuration: tempDuration,
                onTimerDurationChanged: (Duration newDuration) {
                  tempDuration = newDuration;
                },
                itemExtent: 50,
              ),
            ),
          ],
        ),
      ),
    );
    if (newDuration != null) {
      setState(() {
        duration =
            newDuration; // Update the actual duration with the confirmed selection
      });
    }
  }

  //Popup for the Privacy for workout...
  Future _displayPrivacySheet(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoTheme(
          data: const CupertinoThemeData(
            brightness: Brightness.dark,
          ),
          child: CupertinoActionSheet(
            title: const Text('Workout Privacy Options'),
            message: const Text(
              'Control who can see this workout. Do not include\n personal information...',
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock),
                    Text('Private'),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public),
                    Text('Public'),
                  ],
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ),
        );
      },
    );
  }
}

//Creates Exercise Card
class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 61, 59, 77),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Exercise Name',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Add functionality for the button here
                  },
                  icon: const Icon(Icons.more_horiz, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

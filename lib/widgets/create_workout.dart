import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/selfsync_database.dart';
import '../models/exercise.dart';
import '../models/workout.dart';
import '../services/exercise_service.dart';
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
  String originalWorkoutTitle = '';
  String originalWorkoutNotes = '';

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
      exercises.add(Exercise(title: 'title', workoutId: 41)); // Add a new Exercise object
    });
  }

  void _deleteExercise(int index) {
    setState(() {
      exercises.removeAt(index);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    DateTime selectedDay = widget.selectedDay;

    String username = context.read<UserService>().currentUser.username;
    Workout workout = Workout(
      username: username,
      title: workoutTitleController.text.trim(),
      description: workoutNotesController.text.trim(),
      date: selectedDay,
    );
    

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
                // Call the createWorkout method to save the workout to the database
                String result =
                    await context.read<WorkoutService>().createWorkout(workout);

                // Handle the result accordingly
                if (result == 'Ok') {
                  showSnackBar(context, 'Workout Created');

                  Workout? latestWorkout = await SelfSyncDatabase.instance
                      .getLatestWorkoutByUsername(username);

                  workout = latestWorkout!;

                  print('title: ' + workout.title + ', id: ${workout.id}');

                  if (workout.id != null) {
                    for (Exercise exercise in exercises) {
                      exercise.workoutId = workout.id!;
                      String exerciseResult = await context
                          .read<ExerciseService>()
                          .createExercise(exercise);
                      if (exerciseResult == 'Ok') {
                        print(exercise.title! + '\n${exercise.workoutId}');
                      } else {
                        print('Failed to create exercise ${exercise.title}');
                      }
                    }
                  } else {
                    showSnackBar(context, 'Failed to create workout: $result');
                  }
                }

                widget.updateWorkouts();
                Navigator.pop(context);
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
                //Workout info and privacy option
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Workout Title
                      TextButton(
                        onPressed: () async {
                          _displayTitleInfoSheet(context, workout);
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    workoutTitleController.text.isNotEmpty
                                        ? workoutTitleController.text
                                        : "Workout Name...",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              TextSpan(
                                text: workoutNotesController.text.isNotEmpty
                                    ? '\n${workoutNotesController.text}'
                                    : "\nAdd description or notes...",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
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
                      onDelete: () => _deleteExercise(index),
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

  Future _displayTitleInfoSheet(BuildContext context, Workout workout) async {
    originalWorkoutTitle = workoutTitleController.text;
    originalWorkoutNotes = workoutNotesController.text;

    await showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      backgroundColor: const Color.fromARGB(255, 61, 59, 77),
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      workoutTitleController.text = originalWorkoutTitle;
                      workoutNotesController.text = originalWorkoutNotes;
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Workout Info',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              //Wokout Name
              TextField(
                cursorColor: Colors.grey,
                controller: workoutTitleController,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Workout Name...',
                  hintStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //Workout Notes
              TextField(
                minLines: 1,
                maxLines: null,
                cursorColor: Colors.white70,
                controller: workoutNotesController,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Add description or notes...',
                  hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
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
    super.key,
    required this.exercise,
    required this.onDelete,
  });

  final Exercise exercise;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 61, 59, 77),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Exercise Name
                Expanded(
                  child: TextFormField(
                    onTap: () {
                      print('${exercise.title} ${exercise.id}');
                    },
                    cursorColor: Colors.grey,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Exercise Name',
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                //Exercise Options
                IconButton(
                  onPressed: () async {
                    await showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoTheme(
                          data: const CupertinoThemeData(
                            brightness: Brightness.dark,
                          ),
                          child: CupertinoActionSheet(
                            actions: [
                              //Delete workout
                              CupertinoActionSheetAction(
                                onPressed: onDelete,
                                child: const Text(
                                  'Delete Exercise',
                                  style: TextStyle(color: Colors.red),
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
                  },
                  icon: const Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                    applyTextScaling: true,
                  ),
                ),
              ],
            ),
            //Exercise Instructions
            TextFormField(
              minLines: 1,
              maxLines: null,
              cursorColor: Colors.grey,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Instructions...',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

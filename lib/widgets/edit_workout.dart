import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../services/workout_service.dart';
import 'dialogs.dart';

class EditWorkoutPage extends StatefulWidget {
  final Workout workout;
  //final List<Exercise> exercises;

  const EditWorkoutPage({
    super.key,
    required this.workout,
    //required this.exercises,
  });

  @override
  _EditWorkoutPageState createState() => _EditWorkoutPageState();
}

class _EditWorkoutPageState extends State<EditWorkoutPage> {
  late TextEditingController workoutTitleController;
  late TextEditingController workoutNotesController;

  @override
  void initState() {
    super.initState();
    workoutTitleController = TextEditingController(text: widget.workout.title);
    workoutNotesController =
        TextEditingController(text: widget.workout.description);
  }

  @override
  Widget build(BuildContext context) {
    Workout workout = Workout(
      username: widget.workout.username, 
      title: workoutTitleController.text.trim(),
      description: workoutNotesController.text.trim(), 
      date: widget.workout.date, 
      exerciseTitles: widget.workout.exerciseTitles);

    return Scaffold(
      //Background color of entire page
      backgroundColor: const Color.fromARGB(255, 29, 26, 49),

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
              'Edit Workout',
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),

            //Update workout for user
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 12),
              ),
              onPressed: () async {

                widget.workout.title = workout.title;
                widget.workout.description = workout.description;

                //Update workout
                String result = await context
                    .read<WorkoutService>()
                    .updateWorkout(widget.workout);

                //If workout update successful
                if (result == 'Ok') {
                  showSnackBar(context, 'Workout Updated');
                } else {
                  print(result);
                }
                Navigator.pop(context);
              },
              child: const Text('SAVE'),
            ),
          ],
        ),
      ),

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
                          _displayTitleInfoSheet(context, widget.workout);
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future _displayTitleInfoSheet(BuildContext context, Workout workout) async {
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
                      workout.title = workoutTitleController.text.trim();
                      workout.description = workoutNotesController.text.trim();
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

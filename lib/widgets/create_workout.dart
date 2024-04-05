import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../services/user_service.dart';
import '../services/workout_service.dart';
import '../widgets/dialogs.dart';

class CreateWorkoutPage extends StatefulWidget {
  final DateTime selectedDay;
  final VoidCallback updateWorkouts; // updates calendar mark

  const CreateWorkoutPage({super.key, required this.selectedDay, required this.updateWorkouts});

  @override
  _CreateWorkoutPageState createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  late TextEditingController workoutTitleController;
  late TextEditingController workoutNotesController;
  Duration? duration;

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
                    date: selectedDay, //needs to get date from calendar page.
                  );
                  String result = await context
                      .read<WorkoutService>()
                      .createWorkout(workout);
                  if (result == 'Ok') {
                    showSnackBar(context, 'New workout successfully created!');
                    workoutTitleController.text = '';
                    workoutNotesController.text = '';
                    widget.updateWorkouts(); //Updates the calendar mark for this workout
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
            //Workout Creation dialog
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

      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 61, 59, 77),
        ),
        //Workout name, notes, and privacy option
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Workout name and privacy option
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
              child: Row(
                children: [
                  //Workout name option
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
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                      ),
                      controller: workoutTitleController,
                    ),
                  ),
                  //Privacy option
                  IconButton(
                      onPressed: () {
                        //creates popup
                        _displayPrivacySheet(context);
                      },
                      icon: const Icon(
                        Icons.lock,
                        size: 20,
                        color: Colors.grey,
                      )),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Colors.grey,
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
            //Duration option
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 10),
              child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _displayDurationSheet(context);
                    },
                    child: Text(
                        'Est. Duration: ${duration != null ? "${duration!.inHours}:${(duration!.inMinutes % 60).toString().padLeft(2, '0')}" : "---"}'),
                  ),
                ],
              ),
            ),
          ],
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
            'Control who can see tis workout. Do not include\n personal information...',
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {},
              child: const Text('Private'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {}, 
              child: const Text('Friends'))
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

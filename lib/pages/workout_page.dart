// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:selfsync_ios/widgets/edit_workout.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../services/workout_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/create_workout.dart';
import '../widgets/dialogs.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/workout.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  late TextEditingController workoutController;
  late TextEditingController workoutDescriptionController;

  CalendarFormat format = CalendarFormat.week;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  //Trigger rebuild of the parent widget, to update calendar
  void _updateWorkouts() {
    setState(() {}); // Trigger rebuild of the parent widget
  }

  @override
  void initState() {
    super.initState();
    _updateWorkouts();
    workoutController = TextEditingController();
    workoutDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    workoutController.dispose();
    workoutDescriptionController.dispose();
    super.dispose();
  }

  //Toggle calendar view
  void _onHeaderTapped(DateTime focusedDay) {
    setState(() {
      format = format == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week;
    });
  }

  //Return workouts for it's given date
  List<Workout> _getEventsfromDay(DateTime date) {
    // Fetch workouts for the selected date from WorkoutService
    final workoutsForDate =
        context.read<WorkoutService>().workouts.where((workout) {
      return isSameDay(workout.date, date);
    }).toList();
    return workoutsForDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Bottom navigation bar
      bottomNavigationBar: BottomNavBar(
        indexNum: 0,
      ),

      //Top Header bar
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 40,
        backgroundColor: const Color.fromARGB(255, 29, 26, 49),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Selector<UserService, User>(
              selector: (context, value) => value.currentUser,
              builder: (context, value, child) {
                return Text(
                  '${value.name}\'s Routine',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.blueAccent,
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: Container(
        padding: const EdgeInsets.only(top: 5),
        //Background color of whole page
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 29, 26, 49),
        ),
        child: SafeArea(
          child: Column(
            children: [
              //Calendar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 61, 59, 77),
                ),
                child: TableCalendar(
                  focusedDay: focusedDay,
                  firstDay: DateTime(2023),
                  lastDay: DateTime(2025),
                  calendarFormat: format,
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  onHeaderTapped: (focusedDay) => _onHeaderTapped(focusedDay),
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                    setState(() {
                      selectedDay = selectDay;
                      focusedDay = focusDay;
                    });
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },
                  eventLoader: (date) => _getEventsfromDay(date),
                  rowHeight: 30,
                  headerStyle: HeaderStyle(
                    titleTextFormatter: (date, locale) =>
                        DateFormat.yMMMMd(locale).format(date),
                    headerPadding: const EdgeInsets.all(0),
                    headerMargin:
                        const EdgeInsets.only(top: 5, bottom: 5, left: 15),
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleCentered: false,
                    leftChevronPadding: const EdgeInsets.all(3),
                    rightChevronPadding: const EdgeInsets.all(3),
                    leftChevronMargin: const EdgeInsets.all(3),
                    rightChevronMargin: const EdgeInsets.all(3),
                    titleTextStyle: const TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(fontSize: 13, color: Colors.white),
                    weekendStyle: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    cellMargin: const EdgeInsets.only(
                        top: 2, bottom: 2, left: 4, right: 4),
                    tablePadding: const EdgeInsets.only(left: 8, right: 8),
                    outsideDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    todayDecoration: BoxDecoration(
                      color: const Color.fromARGB(255, 131, 131, 131)
                          .withOpacity(.5),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    weekendDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    weekendTextStyle: const TextStyle(color: Colors.white70),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    //Markers when workout is on date
                    markerDecoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              //Scrollable Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Consumer<WorkoutService>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        shrinkWrap: true,
                        // Add 1 for the additional button
                        itemCount: _getEventsfromDay(selectedDay).length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            //Add Workout & Log Nutrition Buttons
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //Add Workout Button
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255, 190, 189, 189),
                                        foregroundColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) =>
                                                CreateWorkoutPage(
                                              selectedDay: selectedDay,
                                              updateWorkouts: _updateWorkouts,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'ADD WORKOUT',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  //Log Nutrition Button
                                  Expanded(
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255, 190, 189, 189),
                                        foregroundColor: Colors.black,
                                      ),
                                      onPressed: () {
                                        // Add onPressed functionality for logging nutrition
                                      },
                                      child: const Text('LOG NUTRITION'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            //Shows workout card
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: WorkoutCard(
                                workout: _getEventsfromDay(selectedDay)[index -
                                    1], // Adjust index to account for the additional button
                                onWorkoutDeleted: _updateWorkouts,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Redoing WorkoutCard
class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.workout,
    required this.onWorkoutDeleted,
  });

  final Workout workout;
  final Function() onWorkoutDeleted;

  @override
  Widget build(BuildContext context) {
    IconData statusIcon = workout.done ? Icons.check : Icons.close;
    String statusToggle = workout.done ? 'Uncomplete' : 'Complete';

    return ClipRect(
      child: GestureDetector(
        onTap: () {
          print(
              'Tapped: ${workout.title} ${workout.id} (${workout.exerciseTitles})');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromARGB(255, 61, 59, 77),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Workout Title
                  Text(
                    workout.title,
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                  ),

                  //EditWorkoutCard Popup
                  IconButton(
                    onPressed: () async {
                      await showCupertinoModalPopup(
                        semanticsDismissible: true,
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
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CupertinoTheme(
                                          data: const CupertinoThemeData(
                                            brightness: Brightness.dark,
                                          ),
                                          child: CupertinoAlertDialog(
                                            title:
                                                const Text('Delete Workout?'),
                                            content: const Text(
                                              'This workout will be removed\npermanently.',
                                            ),
                                            actions: <CupertinoDialogAction>[
                                              CupertinoDialogAction(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                onPressed: () async {
                                                  String result = await context
                                                      .read<WorkoutService>()
                                                      .deleteWorkout(workout);
                                                  if (result == 'Ok') {
                                                    showSnackBar(context,
                                                        'Workout successfully deleted!');
                                                    onWorkoutDeleted();
                                                  } else {
                                                    showSnackBar(
                                                        context, result);
                                                    print(result);
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),

                                //Edit Workout
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) => EditWorkoutPage(
                                          workout: workout,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text('Edit'),
                                ),

                                //Share Workout
                                CupertinoActionSheetAction(
                                  onPressed: () {},
                                  child: const Text('Share'),
                                ),

                                //Toggle workout completion
                                CupertinoActionSheetAction(
                                  onPressed: () async {
                                    String result = await context
                                        .read<WorkoutService>()
                                        .toggleWorkoutDone(workout);
                                    if (result == 'Ok' && workout.done) {
                                      showSnackBar(context,
                                          'Workout successfully completed!');
                                    } else if (result == 'Ok' &&
                                        !workout.done) {
                                      showSnackBar(
                                          context, 'Workout unfinished!');
                                    } else {
                                      showSnackBar(context, result);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text(statusToggle),
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
              //Exercise Titles
              Text(
                workout.exerciseTitles,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
              //Workout description
              Text(
                workout.description,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),

              //Bottom Row of workoutcard
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 5),
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            WidgetSpan(
                              child: Text(
                                '0:00',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextSpan(
                                text: '\nEst. Duration',
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      const VerticalDivider(color: Colors.black45),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Icon(
                                  statusIcon,
                                  color:
                                      workout.done ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                            const TextSpan(
                                text: '\nStatus',
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                      const VerticalDivider(color: Colors.black45),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            WidgetSpan(
                              child: Text(
                                'Intermediate',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextSpan(
                                text: '\nEst. Difficulty',
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

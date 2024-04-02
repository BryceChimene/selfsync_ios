// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../services/workout_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/create_workout.dart';
import '../widgets/dialogs.dart';
import '../widgets/tutorial.dart';
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

  @override
  void initState() {
    workoutController = TextEditingController();
    workoutDescriptionController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    workoutController.dispose();
    workoutDescriptionController.dispose();
    super.dispose();
  }

  void _onHeaderTapped(DateTime focusedDay) {
    setState(() {
      format = format == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week;
    });
  }

  List<Workout> _getEventsfromDay(DateTime date) {
    // Fetch workouts for the selected date from WorkoutService
    final workoutsForDate =
        context.read<WorkoutService>().workouts.where((workout) {
      return isSameDay(workout.date, date);
    }).toList();
    return workoutsForDate;
  }

  void _editWorkout(Workout workout) {
    workoutController.text = workout.title;
    workoutDescriptionController.text = workout.description;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding:
              const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10),
          contentPadding:
              const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 0),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          actionsPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Edit Workout'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      hintText: 'Enter workout Title',
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    controller: workoutController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: 'Enter workout',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    controller: workoutDescriptionController,
                    maxLines: null,
                    minLines: 4,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.purple),
              ),
              onPressed: () {
                workoutController.text = '';
                workoutDescriptionController.text = '';
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.purple),
              ),
              onPressed: () async {
                if (workoutController.text.isEmpty) {
                  showSnackBar(
                      context, 'Please enter a workout title, then save.');
                } else {
                  workout.title = workoutController.text.trim();
                  workout.description =
                      workoutDescriptionController.text.trim();

                  String result = await context
                      .read<WorkoutService>()
                      .updateWorkout(workout);

                  if (result == 'Ok') {
                    showSnackBar(context, 'Workout successfully updated!');
                    workoutController.text = '';
                    workoutDescriptionController.text = '';
                  } else {
                    showSnackBar(context, result);
                  }
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
/*  Does not allow app to function...
    final newUser = context.read<UserService>().currentUser.newUser;

    //Shows tutorial if user is new
    if (newUser) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return const Tutorial();
            },
          );
        },
      );
    }
 */
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.help_center,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const Tutorial();
                  },
                );
              },
            ),

            // Shows profile name
            Selector<UserService, User>(
              selector: (context, value) => value.currentUser,
              builder: (context, value, child) {
                return Text(
                  '${value.name}\'s Workouts',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.blueAccent,
                  ),
                );
              },
            ),

            // Creates workout
/*             
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.only(
                          top: 15, left: 20, right: 20, bottom: 10),
                      contentPadding: const EdgeInsets.only(
                          top: 0, left: 15, right: 15, bottom: 0),
                      insetPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      actionsPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text('Create Workout'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextField(
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  hintText: 'Enter workout Title',
                                  labelStyle: TextStyle(color: Colors.black),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                controller: workoutController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: TextField(
                                style: const TextStyle(fontSize: 14),
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  hintText: 'Enter workout',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                controller: workoutDescriptionController,
                                maxLines: null,
                                minLines: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Add',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          onPressed: () async {
                            if (workoutController.text.isEmpty) {
                              showSnackBar(context,
                                  'Please enter a workout first, then save.');
                            } else {
                              String username = context
                                  .read<UserService>()
                                  .currentUser
                                  .username;
                              Workout workout = Workout(
                                username: username,
                                title: workoutController.text.trim(),
                                description:
                                    workoutDescriptionController.text.trim(),
                                date: selectedDay,
                              );
                              String result = await context
                                  .read<WorkoutService>()
                                  .createWorkout(workout);
                              if (result == 'Ok') {
                                showSnackBar(
                                    context, 'New workout successfully added!');
                                workoutController.text = '';
                                workoutDescriptionController.text = '';
                                setState(() {});
                              } else {
                                showSnackBar(context, result);
                              }
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ), 
*/

            // Redoing workout creation
            IconButton(
              icon: const Icon(
                Icons.add_alarm,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateWorkoutPage(selectedDay: selectedDay)),
                );
              },
            ),
          ],
        ),
      ),

      body: Container(
        padding: const EdgeInsets.only(top: 5),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 29, 26, 49),
        ),
        child: SafeArea(
          child: Column(
            children: [
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
                  headerStyle: const HeaderStyle(
                    headerPadding: EdgeInsets.all(0),
                    headerMargin: EdgeInsets.only(top: 5, bottom: 5, left: 15),
                    formatButtonVisible: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    titleCentered: false,
                    leftChevronPadding: EdgeInsets.all(3),
                    rightChevronPadding: EdgeInsets.all(3),
                    leftChevronMargin: EdgeInsets.all(3),
                    rightChevronMargin: EdgeInsets.all(3),
                    titleTextStyle: TextStyle(
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
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Consumer<WorkoutService>(
                    builder: (context, value, child) {
                      return ListView.builder(
                        itemCount: _getEventsfromDay(selectedDay).length,
                        itemBuilder: (context, index) {
                          return WorkoutCard(
                            workout: _getEventsfromDay(selectedDay)[index],
                            onEditWorkout: _editWorkout,
                          );
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

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({
    super.key,
    required this.workout,
    this.onEditWorkout,
  });

  final Workout workout;
  final Function(Workout)? onEditWorkout;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Card(
        shape: Border(
          left: BorderSide(
            width: 10,
            color: workout.done ? Colors.green : Colors.red,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        color: Colors.purple.shade300,
        child: Slidable(
          key: const ValueKey(0),
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: ((context) async {
                  String result = await context
                      .read<WorkoutService>()
                      .deleteWorkout(workout);
                  if (result == 'Ok') {
                    showSnackBar(context, 'Workout successfully deleted!');
                  } else {
                    showSnackBar(context, result);
                  }
                }),
                icon: Icons.delete,
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              SlidableAction(
                onPressed: ((context) async {
                  onEditWorkout!(workout);
                }),
                icon: Icons.edit,
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ],
          ),
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: ((context) async {
                  String result = await context
                      .read<WorkoutService>()
                      .toggleWorkoutDone(workout);
                  if (result == 'Ok' && workout.done) {
                    showSnackBar(context, 'Workout successfully completed!');
                  } else if (result == 'Ok' && !workout.done) {
                    showSnackBar(context, 'Workout unfinished!');
                  } else {
                    showSnackBar(context, result);
                  }
                }),
                icon: workout.done ? Icons.done : Icons.cancel,
                backgroundColor: workout.done ? Colors.green : Colors.red,
                foregroundColor: Colors.white,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text(
                    workout.title,
                    style: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  workout.description,
                  style: const TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/workout_service.dart';
import '../models/workout.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  _WorkoutListState createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList> {
  late TextEditingController titleSearchController;
  List<String> filteredWorkoutTitles = [];

  @override
  void initState() {
    super.initState();
    titleSearchController = TextEditingController();
    filteredWorkoutTitles = getRecentWorkoutTitles();
  }

  @override
  void dispose() {
    titleSearchController.dispose();
    super.dispose();
  }

  void refreshCard() {
    setState(() {
      filteredWorkoutTitles = getRecentWorkoutTitles();
    });
  }

  void filterWorkoutsByTitle(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredWorkoutTitles = getRecentWorkoutTitles();
      } else {
        filteredWorkoutTitles = getRecentWorkoutTitles()
            .where((title) => title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _showWorkoutDetailsDialog(Workout workout) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(workout.title),
          titlePadding:
              const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 0),
          insetPadding:
              const EdgeInsets.only(bottom: 40, top: 40, right: 15, left: 15),
          contentPadding: const EdgeInsets.only(top: 2, left: 15, right: 15),
          actionsPadding: const EdgeInsets.only(top: 2, bottom: 2, right: 10),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                    'Status: ${workout.done ? 'Completed' : 'Not Completed'}'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text('Date: ${dateFormat.format(workout.date)}'),
              ),
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                        horizontal:
                            BorderSide(color: Colors.black45, width: 2)),
                  ),
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 5, right: 5),
                  child: Text(
                    '${workout.description}',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ],
        );
      },
    );
  }

  List<String> getRecentWorkoutTitles() {
    final List<Workout> recentWorkouts =
        context.read<WorkoutService>().workouts;

    List<String> titles =
        recentWorkouts.map((workout) => workout.title).toList();

    return titles;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: TextButton(
              child: Text(
                'Clear Filter',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              onPressed: () {
                titleSearchController.clear();
                refreshCard();
              },
            ),
          ),
          //Filter workouts by title
          Padding(
            padding:
                const EdgeInsets.only(left: 8.0, right: 8.0, top: 0, bottom: 8),
            child: TextField(
              controller: titleSearchController,
              cursorColor: Colors.black,
              onChanged: filterWorkoutsByTitle,
              decoration: const InputDecoration(
                labelText: 'Search Titles',
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  width: 2,
                  color: Colors.purple,
                )),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredWorkoutTitles.length,
              itemBuilder: (context, index) {
                final selectedWorkout =
                    context.read<WorkoutService>().workouts.firstWhere(
                          (workout) =>
                              workout.title == filteredWorkoutTitles[index],
                        );

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      filteredWorkoutTitles[index],
                      style: TextStyle(fontSize: 13),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: Colors.purple,
                    dense: true,
                    onTap: () {
                      _showWorkoutDetailsDialog(selectedWorkout);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

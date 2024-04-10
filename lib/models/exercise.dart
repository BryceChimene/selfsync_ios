final String exerciseTable = 'exercise';

class ExerciseFields {
  static final String id = 'id';
  static final String workoutId = 'workoutId';
  static final String title = 'title';
  static final String description = 'description';
  static final String sets = 'sets';
  static final String reps = 'reps';
  static final List<String> allFields = [
    id,
    workoutId,
    title,
    description,
    sets,
    reps
  ];
}

class Exercise {
  final int? id;
  final int workoutId;
  String title;
  String description;
  int? sets;
  int? reps;

  Exercise({
    this.id,
    required this.workoutId,
    required this.title,
    required this.description,
    this.sets,
    this.reps,
  });

  Map<String, Object?> toJson() => {
        ExerciseFields.id: id,
        ExerciseFields.workoutId: workoutId,
        ExerciseFields.title: title,
        ExerciseFields.description: description,
        ExerciseFields.reps: reps,
        ExerciseFields.sets: sets,
      };

  static Exercise fromJson(Map<String, Object?> json) => Exercise(
        id: json[ExerciseFields.id] as int,
        workoutId: json[ExerciseFields.workoutId] as int,
        title: json[ExerciseFields.title] as String,
        description: json[ExerciseFields.description] as String,
        reps: json[ExerciseFields.reps] as int,
        sets: json[ExerciseFields.sets] as int,
      );

  toLowerCase() {}
}

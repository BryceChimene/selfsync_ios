import 'package:path/path.dart';
import 'package:selfsync_ios/models/exercise.dart';
import '../models/user.dart';
import '../models/workout.dart';
import 'package:sqflite/sqflite.dart';

class SelfSyncDatabase {
  static final SelfSyncDatabase instance = SelfSyncDatabase._initialize();
  static Database? _database;
  SelfSyncDatabase._initialize();

  Future _createDB(Database db, int version) async {
    const userUsernameType = 'TEXT PRIMARY KEY NOT NULL';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''CREATE TABLE $userTable (
      ${UserFields.username} $userUsernameType,
      ${UserFields.password} $textType,
      ${UserFields.name} $textType,
      ${UserFields.gender} $textType,
      ${UserFields.heightFt} $intType,
      ${UserFields.heightIn} $intType,
      ${UserFields.weight} $doubleType,
      ${UserFields.age} $intType,
      ${UserFields.newUser} $boolType
    ) ''');

    await db.execute('''CREATE TABLE $workoutTable (
      ${WorkoutFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${WorkoutFields.username} $textType,
      ${WorkoutFields.title} $textType,
      ${WorkoutFields.description} $textType,
      ${WorkoutFields.done} $boolType,
      ${WorkoutFields.date} $textType,
      ${WorkoutFields.exerciseTitles} $textType,
      FOREIGN KEY (${WorkoutFields.username}) REFERENCES $userTable (${UserFields.username})
    )''');

    await db.execute('''CREATE TABLE $exerciseTable (
      ${ExerciseFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ExerciseFields.workoutId} $intType,
      ${ExerciseFields.title} $textType,
      ${ExerciseFields.description} $textType,
      ${ExerciseFields.reps} $intType,
      ${ExerciseFields.sets} $intType,
      FOREIGN KEY (${ExerciseFields.workoutId}) REFERENCES $workoutTable (${WorkoutFields.id}) ON DELETE CASCADE
    )''');
  }

  //Alows the use of the foreign key
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  //Opens the database
  Future<Database> _initDB(String fileName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  //Close the database
  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  //for the close method
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDB('selfsync.db');
      return _database;
    }
  }

  //Create a user for database
  Future<User> createUser(User user) async {
    final db = await instance.database;
    await db!.insert(userTable, user.toJson());
    return user;
  }

  //Return user by username from database
  Future<User> getUser(String username) async {
    final db = await instance.database;
    final maps = await db!.query(
      userTable,
      columns: UserFields.allFields,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('$username not found in the database.');
    }
  }

  //Return all users in database
  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    final result = await db!.query(
      userTable,
      orderBy: '${UserFields.username} ASC',
    );
    return result.map((e) => User.fromJson(e)).toList();
  }

  //To update a user from database
  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db!.update(
      userTable,
      user.toJson(),
      where: '${UserFields.username} = ?',
      whereArgs: [user.username],
    );
  }

  //To delete a user from databse
  Future<int> deleteUser(String username) async {
    final db = await instance.database;
    return db!.delete(
      userTable,
      where: '${UserFields.username} = ?',
      whereArgs: [username],
    );
  }

  //To force tutorial on new Users
  Future<int> toggleNewUser(User user) async {
    final db = await instance.database;
    user.newUser = !user.newUser;
    return db!.update(
      userTable,
      user.toJson(),
      where: '${UserFields.username} = ?',
      whereArgs: [user.username],
    );
  }

  //Create workout for user
  Future<Workout> createWorkout(Workout workout) async {
    final db = await instance.database;
    await db!.insert(
      workoutTable,
      workout.toJson(),
    );
    return workout;
  }

  Future<Workout?> getLatestWorkoutByUsername(String username) async {
    final db = await instance.database;
    final result = await db!.query(
      workoutTable,
      orderBy:
          '${WorkoutFields.id} DESC', // Order by date descending to get the latest workout first
      limit: 1, // Limit the result to one entry
      where: '${WorkoutFields.username} = ?',
      whereArgs: [username],
    );

    if (result.isNotEmpty) {
      return Workout.fromJson(result.first);
    } else {
      return null; // Return null if no workout is found
    }
  }

  //Updates a workout
  Future<int> updateWorkout(Workout workout) async {
    final db = await instance.database;
    return db!.update(
      workoutTable,
      workout.toJson(),
      where:
          '${WorkoutFields.title} = ? AND ${WorkoutFields.id} = ? AND ${WorkoutFields.username} = ?',
      whereArgs: [workout.title, workout.id, workout.username],
    );
  }

  //To toggle the status of a workout (true/false)
  Future<int> toggleWorkoutDone(Workout workout) async {
    final db = await instance.database;
    workout.done = !workout.done;
    return db!.update(
      workoutTable,
      workout.toJson(),
      where:
          '${WorkoutFields.title} = ? AND ${WorkoutFields.id} = ? AND ${WorkoutFields.username} = ?',
      whereArgs: [workout.title, workout.id, workout.username],
    );
  }

  //Return all the workouts associated to username from database
  Future<List<Workout>> getWorkouts(String username) async {
    final db = await instance.database;
    final result = await db!.query(
      workoutTable,
      orderBy: '${WorkoutFields.date} DESC',
      where: '${WorkoutFields.username} = ?',
      whereArgs: [username],
    );
    return result.map((e) => Workout.fromJson(e)).toList();
  }

  //Delete a workout from the database
  Future<int> deleteWorkout(Workout workout) async {
    final db = await instance.database;
    return db!.delete(
      workoutTable,
      where:
          '${WorkoutFields.title} = ? AND ${WorkoutFields.id} = ? AND ${WorkoutFields.username} = ?',
      whereArgs: [workout.title, workout.id, workout.username],
    );
  }

  //Create Exercise for workout
  Future<Exercise> createExercise(Exercise exercise) async {
    final db = await instance.database;
    await db!.insert(
      exerciseTable,
      exercise.toJson(),
    );
    return exercise;
  }

  //Update an exercise
  Future<int> updateExercise(Exercise exercise) async {
    final db = await instance.database;
    return db!.update(
      exerciseTable,
      exercise.toJson(),
      where:
          '${ExerciseFields.title} = ? AND ${ExerciseFields.id} = ? AND ${ExerciseFields.workoutId} = ?',
      whereArgs: [exercise.title, exercise.id, exercise.workoutId],
    );
  }

  //Return all the exercises associated to a workout from database
  Future<List<Exercise>> getExercises(int workoutId) async {
    final db = await instance.database;
    final result = await db!.query(
      exerciseTable,
      orderBy: '${ExerciseFields.title} DESC',
      where: '${ExerciseFields.workoutId} = ?',
      whereArgs: [workoutId],
    );
    return result.map((e) => Exercise.fromJson(e)).toList();
  }

  //Delete a exercise from the database
  Future<int> deleteExercise(Exercise exercise) async {
    final db = await instance.database;
    return db!.delete(
      exerciseTable,
      where:
          '${ExerciseFields.title} = ? AND ${ExerciseFields.id} = ? AND ${ExerciseFields.workoutId} = ?',
      whereArgs: [exercise.title, exercise.id, exercise.workoutId],
    );
  }
}

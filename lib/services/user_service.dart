import 'package:flutter/material.dart';
import '../database/selfsync_database.dart';
import '../models/user.dart';

class UserService with ChangeNotifier {
  late User _currentUser;
  bool _busyCreate = false;
  bool _userExists = false;

  User get currentUser => _currentUser;
  bool get busyCreate => _busyCreate;
  bool get userExists => _userExists;
  bool get newUser => _currentUser.newUser;

  set userExists(bool value) {
    _userExists = value;
    notifyListeners();
  }

  Future<String> updateUser({
    required String name,
    required String gender,
    required String heightFt,
    required String heightIn,
    required String weight,
    required String age,
  }) async {
    try {
      _currentUser.name = name;
      _currentUser.gender = gender;
      _currentUser.heightFt = int.parse(heightFt);
      _currentUser.heightIn = int.parse(heightIn);
      _currentUser.weight = double.parse(weight);
      _currentUser.age = int.parse(age);

      await SelfSyncDatabase.instance.updateUser(_currentUser);

      notifyListeners();
      return 'Ok';
    } catch (e) {
      return getHumanReadableError(e.toString());
    }
  }

  Future<String> getUser(String username) async {
    String result = 'Ok';

    try {
      _currentUser = await SelfSyncDatabase.instance.getUser(username);
      notifyListeners();
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> checkIfUserExists(String username) async {
    String result = 'Ok';
    try {
      await SelfSyncDatabase.instance.getUser(username);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> deleteUser(String username) async {
    String result = 'Ok';
    try {
      await SelfSyncDatabase.instance.deleteUser(username);
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    return result;
  }

  Future<String> isPasswordCorrect(String username, String password) async {
    try {
      User user = await SelfSyncDatabase.instance.getUser(username);
      if (user.password == password) {
        return 'Ok';
      } else {
        return 'Incorrect password';
      }
    } catch (e) {
      return getHumanReadableError(e.toString());
    }
  }

  Future<String> createUser(User user) async {
    String result = 'Ok';
    _busyCreate = true;
    notifyListeners();
    try {
      await SelfSyncDatabase.instance.createUser(user);
      await Future.delayed(Duration(seconds: 2));
    } catch (e) {
      result = getHumanReadableError(e.toString());
    }
    _busyCreate = false;
    notifyListeners();
    return result;
  }

  void logout() {
    _currentUser = User(
      username: '', // Set appropriate default values
      password: '',
      name: '',
      gender: '',
      heightFt: 0,
      heightIn: 0,
      weight: 0.0,
      age: 0,
    );
    // Notify listeners that the user has logged out
    notifyListeners();
  }

  Future<String> toggleNewUser(User user) async {
    try {
      await SelfSyncDatabase.instance.toggleNewUser(user);
    } catch (e) {
      return e.toString();
    }
    String result = await getUser(user.username);
    return result;
  }
}

String getHumanReadableError(String message) {
  if (message.contains('UNIQUE constraint failed')) {
    return 'This user already exists in the database. Please choose a new one.';
  }
  if (message.contains('not found in the databse')) {
    return 'The user does not exist in the database. Please register first.';
  }
  return message;
}

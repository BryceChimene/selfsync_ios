//FUTURE NOTE, add hashing to password to make secure

final String userTable = 'user';

class UserFields {
  static final String username = "username";
  static final String password = "password";
  static final String name = "name";
  static final String gender = "gender";
  static final String heightFt = "heightFt";
  static final String heightIn = "heightIn";
  static final String weight = "weight";
  static final String age = "age";
  static final String newUser = "newUser";

  static final List<String> allFields = [
    username,
    password,
    name,
    gender,
    heightFt,
    heightIn,
    weight,
    age,
    newUser,
  ];
}

class User {
  final String username;
  final String password;
  String name;
  String gender;
  int heightFt;
  int heightIn;
  double weight;
  int age;
  bool newUser = true;

  User({
    required this.username,
    required this.password,
    required this.name,
    required this.gender,
    required this.heightFt,
    required this.heightIn,
    required this.weight,
    required this.age,
    this.newUser = true,
  });

  Map<String, Object?> toJson() => {
        UserFields.username: username,
        UserFields.password: password,
        UserFields.name: name,
        UserFields.gender: gender,
        UserFields.heightFt: heightFt.toInt(),
        UserFields.heightIn: heightIn.toInt(),
        UserFields.weight: weight.toDouble(),
        UserFields.age: age.toInt(),
        UserFields.newUser: newUser ? 1 : 0,
      };

  static User fromJson(Map<String, Object?> json) => User(
        username: json[UserFields.username] as String,
        password: json[UserFields.password] as String,
        name: json[UserFields.name] as String,
        gender: json[UserFields.gender] as String,
        heightFt: json[UserFields.heightFt] as int,
        heightIn: json[UserFields.heightIn] as int,
        weight: json[UserFields.weight] as double,
        age: json[UserFields.age] as int,
        newUser: json[UserFields.newUser] == 1 ? true : false,
      );
}

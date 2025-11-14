const String tableUsers = 'users';

class UserFields {
  static final List<String> values = [id, username, password];
  static const String id = '_id';
  static const String username = 'username';
  static const String password = 'password';
}

class User {
  final int? id;
  final String username;
  final String password;

  const User({
    this.id,
    required this.username,
    required this.password,
  });

  Map<String, Object?> toJson() => {
    UserFields.id: id,
    UserFields.username: username,
    UserFields.password: password,
  };

  static User fromJson(Map<String, Object?> json) => User(
    id: json[UserFields.id] as int?,
    username: json[UserFields.username] as String,
    password: json[UserFields.password] as String,
  );
}

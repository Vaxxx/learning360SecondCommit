class User {
  final String fullname;
  final String level;
  final String email;
  final String role;
  final String id;

  User({this.fullname, this.level, this.email, this.role, this.id});

  User.fromMap(Map<String, dynamic> data, String id)
      : fullname = data['fullname'],
        level = data['level'],
        email = data['email'],
        role = data['role'],
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "fullname": fullname,
      "level": level,
      "email": email,
      "role": role,
    };
  }
} //User

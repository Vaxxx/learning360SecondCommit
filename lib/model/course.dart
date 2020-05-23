class Course {
  final String name;
  final String semester;
  final String month;
  final String year;
  final String id;

  Course({this.name, this.semester, this.month, this.year, this.id});

  Course.fromMap(Map<String, dynamic> data, String id)
      : name = data['name'],
        semester = data['semester'],
        month = data['month'],
        year = data['year'],
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "semester": semester,
      "month": month,
      "year": year,
    };
  }
} //User

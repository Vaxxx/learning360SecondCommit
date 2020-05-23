class CourseUpload {
  final String name;
  final String level;
  final String semester;
  final String month;
  final String year;
  final String filename;
  final String id;

  CourseUpload(
      {this.name,
      this.level,
      this.semester,
      this.month,
      this.year,
      this.filename,
      this.id});

  CourseUpload.fromMap(Map<String, dynamic> data, String id)
      : name = data['name'],
        level = data['level'],
        semester = data['semester'],
        month = data['month'],
        year = data['year'],
        filename = data['filename'],
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "level": level,
      "semester": semester,
      "month": month,
      "year": year,
      "filename": filename,
    };
  }
} //User

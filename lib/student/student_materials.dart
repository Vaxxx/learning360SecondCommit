import 'package:flutter/material.dart';
import 'package:learning360/model/course_upload.dart';
import 'package:learning360/model/firestore_services.dart';

class StudentMaterials extends StatefulWidget {
  static String cName;
  static String cLevel;
  static String cSemester;
  static String cMonth;
  static String cYear;
  static String cFileName;
  @override
  _StudentMaterialsState createState() => _StudentMaterialsState();
}

class _StudentMaterialsState extends State<StudentMaterials> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Contents'),
      ),
      body: StreamBuilder(
        stream: FirestoreService().getCourseUpload(),
        builder:
            (BuildContext context, AsyncSnapshot<List<CourseUpload>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData)
            return CircularProgressIndicator();

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                CourseUpload course = snapshot.data[index];
                return ListTile(
                  title: Text(course.filename),
                  subtitle: Text(course.name),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      moveToVideo(course.name, course.level, course.semester,
                          course.month, course.year, course.filename);
                    },
                  ),
                  onTap: () {
                    moveToVideo(course.name, course.level, course.semester,
                        course.month, course.year, course.filename);
                  },
                );
              });
        },
      ),
    );
  }

  void moveToVideo(String name, String level, String semester, String month,
      String year, String filename) {
    StudentMaterials.cName = name;
    StudentMaterials.cLevel = level;
    StudentMaterials.cSemester = semester;
    StudentMaterials.cMonth = month;
    StudentMaterials.cYear = year;
    StudentMaterials.cFileName = filename;

    Navigator.pushNamed(context, '/video_file');
  }
}

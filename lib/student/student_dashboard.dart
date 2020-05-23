import 'package:flutter/material.dart';
import 'package:learning360/model/course.dart';
import 'package:learning360/model/firestore_services.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: StreamBuilder(
        stream: FirestoreService().getCourses(),
        builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData)
            return CircularProgressIndicator();
          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Course course = snapshot.data[index];
                return ListTile(
                  leading: Text(course.month),
                  title: Text(course.name),
                  subtitle: Text("Semester: ${course.semester}"),
                );
              });
        },
      ),
    );
  }
}

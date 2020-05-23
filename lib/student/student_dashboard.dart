import 'package:flutter/material.dart';
import 'package:learning360/model/course.dart';
import 'package:learning360/model/firestore_services.dart';
import 'package:learning360/screens/login.dart';

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int count = 0;

  @override
  void initState() {
    print('initttttttttttttttttttttttttttttttttt');
    print('Level Name: ${LoginPage.levelName}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _level = int.parse(LoginPage.levelName);
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: StreamBuilder(
        stream: FirestoreService().getCoursesWithLevel(LoginPage.levelName),
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
                  subtitle: Text("Level: ${course.level}"),
                  onTap: () {
                    moveToFiles();
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      moveToFiles();
                    },
                  ),
                );
              });
        },
      ),
    );
  }

  void moveToFiles() {
    Navigator.pushNamed(context, '/student_materials');
  }
}

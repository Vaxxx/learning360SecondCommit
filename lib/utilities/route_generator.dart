import 'package:flutter/material.dart';
import 'package:learning360/admin/admin_dashboard.dart';
import 'package:learning360/admin/create_course.dart';
import 'package:learning360/screens/login.dart';
import 'package:learning360/screens/register.dart';
import 'package:learning360/student/student_dashboard.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => RegisterPage(),
        );
      case '/admin_dashboard':
        return MaterialPageRoute(
          builder: (_) => AdminDashboard(),
        );
      case '/student_dashboard':
        return MaterialPageRoute(
          builder: (_) => StudentDashboard(),
        );
      case '/create_course':
        return MaterialPageRoute(
          builder: (_) => CreateCourse(),
        );
      default:
        return _errorRoute();
    } //switch
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error Page'),
        ),
        body: Center(
          child: Text('AN ERROR HAS OCCURED!'),
        ),
      );
    });
  } //error ROUTE
} //end RouteGenerator

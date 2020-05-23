import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learning360/model/course.dart';
import 'package:learning360/model/user.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  FirestoreService._internal();

//declare a firestore handle
  Firestore _db = Firestore.instance;

  factory FirestoreService() {
    return _firestoreService;
  }

//Add users
  Future<void> addUser(User user) {
    return _db.collection('users').add(user.toMap());
  }

//view users
  Stream<List<User>> getUsers() {
    return _db.collection('users').snapshots().map(
          (snapshot) => snapshot.documents
              .map(
                (doc) => User.fromMap(doc.data, doc.documentID),
              )
              .toList(),
        );
  } //getUsers

//delete users
  Future<void> deleteUser(String id) {
    return _db.collection('users').document(id).delete();
  }

  //Add course
  Future<void> addCourse(Course course) {
    return _db.collection('courses').add(course.toMap());
  }

//view Courses
  Stream<List<Course>> getCourses() {
    return _db.collection('courses').snapshots().map(
          (snapshot) => snapshot.documents
              .map(
                (doc) => Course.fromMap(doc.data, doc.documentID),
              )
              .toList(),
        );
  } //getCourses
} //Firestore Service

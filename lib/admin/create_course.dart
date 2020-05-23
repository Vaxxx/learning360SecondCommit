import 'package:flutter/material.dart';
import 'package:learning360/model/course.dart';
import 'package:learning360/model/firestore_services.dart';
import 'package:learning360/utilities/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CreateCourse extends StatefulWidget {
  @override
  _CreateCourseState createState() => _CreateCourseState();
}

class _CreateCourseState extends State<CreateCourse> {
  TextEditingController _nameController;
  GlobalKey<FormState> _courseKey = GlobalKey<FormState>();
  bool _validate = false;
  bool showSpinner = false;
  String semesterValue = 'Choose the Semester';
  String monthValue = 'Choose the Month';
  String yearValue = 'Choose the Year';

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body(context));
  }

  Widget body(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return portrait();
    } else {
      return landscape();
    }
  }

  Widget portrait() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Course'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            /////////////////////////////////////////ITEM 1: clipPath//////////////////////////////////////////////
            clipPathContainer(),
            /////////////////////////////////////////clipPath//////////////////////////////////////////////
            ////////////////////////////////////////////////////////////ITEM 2 EMAILContainer/////////////////////////////////
            ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Form(
                key: _courseKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    nameContainer(),
                    semesterContainer(),
                    monthContainer(),
                    yearContainer(),
                    createCourseContainer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget landscape() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Course'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ////////////////////////////////////First Container: fullname///////////////////////
            ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Form(
                key: _courseKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    nameContainer(),
                    semesterContainer(),
                    monthContainer(),
                    yearContainer(),
                    createCourseContainer(),
                  ],
                ),
              ),
            )
            ////////////////////////////////////5th Container: Register Button///////////////////////
          ],
        ),
      ),
    );
  }

  ///form elements///////////////////////////////////////////////////////////////
  TextFormField nameText() {
    return TextFormField(
      controller: _nameController,
      validator: validateName,
      decoration: InputDecoration(
        labelText: "Course Name",
        hintText: "Enter Course Name",
        border: OutlineInputBorder(),
      ),
    );
  } //fullnameText()

///////////////////////////////////////////////////////CONTAINER FORM FIELDS////////////////////////////
//////////////////////////////////////////item 1: Clip path///////////////////////
  ClipPath clipPathContainer() {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: backgroundImage, fit: BoxFit.cover)),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          children: <Widget>[
            Text(
              'Learning360',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            Text(
              'Create Course',
              style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: splashColor),
            )
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////ITEM 2: FULL NAME//////////////////////////////////////////////////
  Container nameContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyWithOpacity, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Icon(
              Icons.person_outline,
              color: colorGrey,
            ),
          ),
          Container(
            height: 10.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          ////remove container and place widget here.....////////////////////
          Expanded(
            child: nameText(),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////END OF ITEM 2: FULL NAME/////////////////////////////////////////////
  //////////////////////////////////////////ITEM 3: CLASS//////////////////////////////////////////////////
  Container semesterContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyWithOpacity, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Icon(
              Icons.class_,
              color: colorGrey,
            ),
          ),
          Container(
            height: 10.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          ////remove container and place item here.....////////////////////
          Expanded(
            child: DropdownButton<String>(
              value: semesterValue,
              onChanged: (String Value) {
                setState(() {
                  semesterValue = Value;
                });
              },
              items: <String>[
                'Choose the Semester',
                '1',
                '2',
                '3',
                '4',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

///////////////////////////////////////END OF ITEM 3: SEMESTER////////////////////////////////////////////

  //////////////////////////////////////////ITEM 3: CLASS//////////////////////////////////////////////////
  Container monthContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyWithOpacity, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Icon(
              Icons.memory,
              color: colorGrey,
            ),
          ),
          Container(
            height: 10.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          ////remove container and place item here.....////////////////////
          Expanded(
            child: DropdownButton<String>(
              value: monthValue,
              onChanged: (String newValue) {
                setState(() {
                  monthValue = newValue;
                });
              },
              items: <String>[
                'Choose the Month',
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

///////////////////////////////////////END OF ITEM 3: SEMESTER////////////////////////////////////////////

  //////////////////////////////////////////ITEM 3: MONTH//////////////////////////////////////////////////
  Container yearContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyWithOpacity, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Icon(
              Icons.memory,
              color: colorGrey,
            ),
          ),
          Container(
            height: 10.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          ////remove container and place item here.....////////////////////
          Expanded(
            child: DropdownButton<String>(
              value: yearValue,
              onChanged: (String newValue) {
                setState(() {
                  yearValue = newValue;
                });
              },
              items: <String>[
                'Choose the Year',
                '2020',
                '2021',
                '2022',
                '2023',
                '2024',
                '2025',
                '2026',
                '2027',
                '2028',
                '2029',
                '2030',
                '2031',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Container createCourseContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              splashColor: googleColor,
              color: googleColor,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Create Course',
                      style: TextStyle(color: colorWhite),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Transform.translate(
                    offset: Offset(15.0, 0.0),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0)),
                        splashColor: colorWhite,
                        color: colorWhite,
                        child: Icon(
                          Icons.receipt,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          createCourse();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                createCourse();
              },
            ),
          )
        ],
      ),
    );
  }

///////////////////////////////////////END OF ITEM 3: SEMESTER////////////////////////////////////////////
  String validateName(String value) {
    String pattern = '(^[a-zA-Z ])';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    } else if (value.length < 6) {
      return "Your Full Name is too short, Please ensure you enter your First Name and Last Name and it must at least three characters";
    }
    return null;
  } //validateName

  void backToLastPage() {
    Navigator.pushNamed(context, '/admin_dashboard');
  }

  createCourse() async {
    if (_courseKey.currentState.validate()) {
      //form fields are validated
      _courseKey.currentState.save();
      String _name = _nameController.text.trim();
      String _semester = semesterValue;
      String _month = monthValue;
      String _year = yearValue;
      print(
          "Name: $_name \nSemester: $_semester \n Month: $_month \n Year: $_year");
      try {
        Course course = Course(
            name: _name, semester: _semester, month: _month, year: _month);

        await FirestoreService().addCourse(course);
        backToLastPage();
        displayMsg("A new Course has been created");
      } catch (e) {
        print("ERROR: $e");
        displayMsg("ERROR: $e");
      }
    } else {
      setState(() {
        _validate = true;
        displayMsg('Please fill the form correctly');
      });
    }
  }
} //createcoursestate

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

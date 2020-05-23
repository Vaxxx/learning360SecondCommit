import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learning360/model/course.dart';
import 'package:learning360/model/course_upload.dart';
import 'package:learning360/model/firestore_services.dart';
import 'package:learning360/utilities/constants.dart';

class UploadCourse extends StatefulWidget {
  @override
  _UploadCourseState createState() => _UploadCourseState();
}

class _UploadCourseState extends State<UploadCourse> {
  String _filePath;
  String appendedText;

  String _fileTitle;
  Map<String, String> _filePaths;
  String _extension;
  FileType _fileType = FileType.any;
  bool _multiPick = false;
  GlobalKey<FormState> _scaffoldKey = GlobalKey<FormState>();
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  String levelValue = 'Enter Student Level';
  String semesterValue = 'Choose the Semester';
  String monthValue = 'Choose the Month';
  String yearValue = 'Choose the Year';
  var _mySelection;
  List<Course> course;
  String _course;
  List<DropdownMenuItem> courseItems = [];

  chooseFiles() async {
    try {
      _filePath = null;
      if (_multiPick) {
        //user wants to upload multiple files
        _filePaths = await FilePicker.getMultiFilePath(
            type: _fileType,
            allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '')?.split(',')
                : null);
      } else {
        //single file
        _filePath = await FilePicker.getFilePath(
            type: _fileType,
            allowedExtensions: (_extension?.isNotEmpty ?? false)
                ? _extension?.replaceAll(' ', '')?.split(',')
                : null);
      }
      uploadToFirebase();
    } on PlatformException catch (e) {
      print('Unsupported operation ' + e.toString());
    }
  }

  uploadToFirebase() {
    if (_fileType == FileType.image) {
      print('its an image');
      String _name = 'ImageFile/';
      appendedText = '$_name';
    } else if (_fileType == FileType.video) {
      print('its a video');
      String _name = 'VideoFile/';
      appendedText = '$_name/';
    } else if (_fileType == FileType.any) {
      print('its a pdf');
      String _name = 'PDFFile/';
      appendedText = '$_name/';
    } else {
      print('Unsupported file');
      String _name = 'UnsupportedFile/';
      appendedText = '$_name/';
    }

    if (_multiPick) {
      _filePaths.forEach((fileName, filePath) {
        print('File Name: $fileName');
        print('File Path: $filePath');
        print('File Type: $_fileType');
        upload(fileName, filePath);
      });
    } else {
      String fileName = _filePath.split('/').last;
      String ext = _filePath.split('.').last;
      String filePath = _filePath;
      print('Single File Type: $_fileType');
      print('Single File ext: $ext');
      _fileTitle = fileName;
      upload(fileName, filePath);
    }
  } //uploadToFirebase

  saveToDatabase() async {
    CourseUpload course = CourseUpload(
        name: _mySelection,
        level: levelValue,
        semester: semesterValue,
        month: monthValue,
        year: yearValue,
        filename: _fileTitle);
    _course = '$_mySelection$levelValue$semesterValue$monthValue$yearValue';
    print('filename: $_fileTitle');
    await FirestoreService().addCourseUpload(course);
  }

  upload(fileName, filePath) {
    saveToDatabase();
    _extension = fileName.toString().split('.').last;
    appendedText = '$_course$appendedText';
    String combine = "$appendedText$fileName";
    print('Combine file is...................:::$combine');
    print('File Nameeeeeeeeeeeeeeeeeeeeeeee.....$fileName');
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child(combine);
    final StorageUploadTask uploadTask = storageReference.putFile(
        File(filePath), StorageMetadata(contentType: '$_fileType/$_extension'));
    displayMsg('File has been successfully uploaded');
    setState(() {
      _tasks.add(uploadTask);
    });
  }

  dropDown() {
    return DropdownButton(
      hint: Text('Select File Type'),
      value: _fileType,
      items: <DropdownMenuItem>[
        DropdownMenuItem(
          child: Text('Video'),
          value: FileType.video,
        ),
        DropdownMenuItem(
          child: Text('pdf'),
          value: FileType.any,
        ),
        DropdownMenuItem(
          child: Text('Image'),
          value: FileType.image,
        ),
      ],
      onChanged: (value) {
        setState(() {
          _fileType = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UPLOAD COURSE'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //course title /////////////////////////
            SizedBox(
              height: 30.0,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('courses').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData)
                  return Text('There is no available courses');
                var length = snapshot.data.documents.length;
                DocumentSnapshot ds = snapshot.data.documents[length - 1];
                // var _queryCat = snapshot.data.documents;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.category,
                      color: Colors.black,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    DropdownButton(
                      hint: Text('Choose a Course'),
                      onChanged: (courseValue) {
                        //add a snackbar
                        final snackBar = SnackBar(
                          content: Text('Category is $courseValue'),
                        );
                        //display snackbar
                        Scaffold.of(context).showSnackBar(snackBar);
                        setState(() {
                          _mySelection = courseValue;
                        });
                      },
                      isExpanded: false,
                      value: _mySelection,
                      items: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new DropdownMenuItem<String>(
                            value: document.data['name'].toString(),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text(
                                document.data['name'].toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xff11b719),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ));
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
            //////////////////////////////////////////
            levelContainer(),
            semesterContainer(),
            monthContainer(),
            yearContainer(),
            Text('Choose File Type:'),
            dropDown(),
//            SwitchListTile.adaptive(
//                title: Text('Choose Multiple Files'),
//                value: _multiPick,
//                onChanged: (bool value) {
//                  setState(() {
//                    _multiPick = value;
//                  });
//                }),
            OutlineButton(
              child: Text('Choose Files'),
              onPressed: () {
                chooseFiles();
              },
            ),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////ITEM 3: LEVEL//////////////////////////////////////////////////
  Container levelContainer() {
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
              value: levelValue,
              onChanged: (String value) {
                setState(() {
                  levelValue = value;
                });
              },
              items: <String>[
                'Enter Student Level',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
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

///////////////////////////////////////END OF ITEM 3: LEVEL////////////////////////////////////////////

  //////////////////////////////////////////ITEM 3: SEMESTER//////////////////////////////////////////////////
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

  //////////////////////////////////////////ITEM 3: MONTH//////////////////////////////////////////////////
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

///////////////////////////////////////END OF ITEM 3: MONTH////////////////////////////////////////////

  //////////////////////////////////////////ITEM 3: YEAR//////////////////////////////////////////////////
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
}

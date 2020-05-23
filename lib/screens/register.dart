import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning360/model/firestore_services.dart';
import 'package:learning360/model/user.dart';
import 'package:learning360/utilities/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //declared variables
  TextEditingController _fullnameController;
  TextEditingController _emailController;
  //TextEditingController _classController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  String dropdownValue = 'Choose your class';

  @override
  void initState() {
    _fullnameController = TextEditingController();
    _emailController = TextEditingController();
    // _classController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    //_classController.dispose();
    _passwordController.dispose();
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
        title: Text('REGISTER'),
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
                key: _formKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    fullnameContainer(),
                    classContainer(),
                    emailContainer(),
                    passwordContainer(),
                    registerContainer(),
                  ],
                ),
              ),
            )
            ////////////////////////////////////////////////////////////End of Container/////////////////////////////////
            //////////////////////////////////////////////////////////////ITEM 3 CLASS container/////////////////////////////

            ////////////////////////////////////////////////////////////END OF ITEM 3 CLASS container///////////////////////////
            ////////////////////////////////////////////////////////////ITEM 4  EMAIL container///////////////////////////

            ////////////////////////////////////////////////////////////END OF ITEM 4  EMAIL container///////////////////////////
            //////////////////////////////////////////////////////////// ITEM 4  PASSWORD container///////////////////////////

            ////////////////////////////////////////////////////////////End of Four container///////////////////////////
            ////////////////////////////////////////////////////////////Five container ///////////////////////////

            ////////////////////////////////////////////////////////////End of Five container///////////////////////////
          ],
        ),
      ),
    );
  }

  Widget landscape() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
                key: _formKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    fullnameContainer(),
                    classContainer(),
                    emailContainer(),
                    passwordContainer(),
                    registerContainer(),
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
  TextFormField fullNameText() {
    return TextFormField(
      controller: _fullnameController,
      validator: validateFullName,
      decoration: InputDecoration(
        labelText: "Full Name",
        hintText: "Full Name",
        border: OutlineInputBorder(),
      ),
    );
  } //fullnameText()

  TextFormField emailText() {
    return TextFormField(
      controller: _emailController,
      validator: validateEmail,
      decoration: InputDecoration(
        labelText: "Enter Email Address",
        hintText: "Email Address",
        border: OutlineInputBorder(),
      ),
    );
  } //emailText()

  TextFormField passwordText() {
    return TextFormField(
      controller: _passwordController,
      validator: validatePassword,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Enter Password",
        hintText: "Password",
        border: OutlineInputBorder(),
      ),
    );
  } //phoneText()

  register() async {
    String _role = "Student";
    if (_formKey.currentState.validate()) {
      //form fields are validated
      _formKey.currentState.save();
      print(
          "Fullname: ${_fullnameController.text.trim()} \nClass: $dropdownValue \n");
      print(
          "Email: ${_emailController.text.trim()}  \n  Password: ${_passwordController.text.trim()}");
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());

        User user = User(
            fullname: _fullnameController.text.trim(),
            level: dropdownValue,
            email: _emailController.text.trim(),
            role: _role);
        await FirestoreService().addUser(user);
        backToLastPage();
        displayMsg("A new Student has been created");
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

  ////////////////////////////////////////////////////////CONTAINER FORM FIELDS////////////////////////////
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
              'REGISTER',
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

  //////////////////////////////////////////end of item 1: Clip path///////////////////////
  //////////////////////////////////////////ITEM 2: FULL NAME//////////////////////////////////////////////////
  Container fullnameContainer() {
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
            child: fullNameText(),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////END OF ITEM 2: FULL NAME/////////////////////////////////////////////
  //////////////////////////////////////////ITEM 3: CLASS//////////////////////////////////////////////////
  Container classContainer() {
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
              value: dropdownValue,
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>[
                'Choose your class',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7'
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

  ///////////////////////////////////////END OF ITEM 3: CLASS////////////////////////////////////////////////
  //////////////////////////////////////////ITEM 4: EMAIL/////////////////////////////////////////////////////
  Container emailContainer() {
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
              Icons.alternate_email,
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
            child: emailText(),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////END OF ITEM 4: EMAIL////////////////////////////////////////////////
  //////////////////////////////////////////ITEM 5:  PASSWORD//////////////////////////////////////////////////
  Container passwordContainer() {
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
              Icons.lock,
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
            child: passwordText(),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////END OF ITEM 5: PASSWORD/////////////////////////////////////////////
  //////////////////////////////////////////ITEM 6: REGISTER//////////////////////////////////////////////////
  Container registerContainer() {
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
                      'REGISTER',
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
                          register();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                register();
              },
            ),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////END OF ITEM 6: REGISTER/////////////////////////////////////////////
  ////////////////////////////////////////////////////////END OF CONTAINER FORM FIELDS////////////////////////////
///////////////////////////////VALIDATION/////////////////////////////////////////////////////////////
/////////////////////////validators/////////////////////////////////////////////////////////////////
  String validateFullName(String value) {
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

  String validatePassword(String value) {
    if (value.length == 0) {
      return "A Password  is Required";
    } else if (value.length < 5) {
      return "Your Password is too short, it must at least five characters";
    }
    return null;
  } //validateName

  String validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  void backToLastPage() {
    Navigator.pop(context);
  }
///////////////////////////////END OF VALIDATION/////////////////////////////////////////////////////////////
} //registerpagestate

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

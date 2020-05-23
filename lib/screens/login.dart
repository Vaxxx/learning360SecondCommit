import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learning360/utilities/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //declared variables
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
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

////////////////////////////////////////////////portrait section///////////////////////////
  Widget portrait() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning360'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //////////////////////////////////////ITEM 1 //////////////////////////////////////////////////////////
            clipPathContainer(),
            //////////////////////////////////////ITEM 2 //////////////////////////////////////////////////////////
            Form(
              key: _formKey,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
                  emailContainer(),
                  passwordContainer(),
                  loginButtonContainer(),
                ],
              ),
            ),

            ////////////////////////////////////// END OF ITEM 2 //////////////////////////////////////////////////////////
            //////////////////////////////////////ITEM 3:  PASSWORD //////////////////////////////////////////////////////////

            //////////////////////////////////////END OF ITEM 3 //////////////////////////////////////////////////////////
            ////////////////////////////////////// ITEM 4 LOGIN BUTTON//////////////////////////////////////////////////////////

            ////////////////////////////////////// END OF ITEM 4 //////////////////////////////////////////////////////////
            ////////////////////////////////////// ITEM 5: log in with google//////////////////////////////////////////////////////////
            googleLoginButtonContainer(),
            ////////////////////////////////////// END OF ITEM 5 //////////////////////////////////////////////////////////
            ////////////////////////////////////// ITEM 6 : DON'T HAVE AN ACCOUNT //////////////////////////////////////////////////////////
            registerButtonContainer(),
            ////////////////////////////////////// END OF ITEM 6 //////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }

////////////////////////////////////////////////end of portrait section///////////////////////////
  ////////////////////////////////////////////////LAND SCAPE section///////////////////////////
  Widget landscape() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
        )),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: colorWhite),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              //////////////////////////////////////ITEM 2 //////////////////////////////////////////////////////////
              Padding(
                padding: EdgeInsets.only(bottom: 20.0),
              ),
              Form(
                key: _formKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    emailContainer(),
                    passwordContainer(),
                    loginButtonContainer(),
                  ],
                ),
              ),
              ////////////////////////////////////// END OF ITEM 2 //////////////////////////////////////////////////////////
              //////////////////////////////////////ITEM 3:  PASSWORD //////////////////////////////////////////////////////////

              //////////////////////////////////////END OF ITEM 3 //////////////////////////////////////////////////////////
              ////////////////////////////////////// ITEM 4 //////////////////////////////////////////////////////////

              ////////////////////////////////////// END OF ITEM 4 //////////////////////////////////////////////////////////
              ////////////////////////////////////// ITEM 5: log in with google//////////////////////////////////////////////////////////
              googleLoginButtonContainer(),
              ////////////////////////////////////// END OF ITEM 5 //////////////////////////////////////////////////////////
              ////////////////////////////////////// ITEM 6 : DONT HAVE AN ACCOUNT //////////////////////////////////////////////////////////
              registerButtonContainer(),
              ////////////////////////////////////// END OF ITEM 6 //////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  } //end landscape

////////////////////////////////////////////////END OF LANDSCAPE section///////////////////////////
////////////////////////////////////////////////form fields//////////////////////////////////////
  TextFormField emailAddress() {
    return TextFormField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your Email',
          labelText: 'Enter your Email',
          hintStyle: TextStyle(color: colorGrey)),
      controller: _emailController,
      validator: validateEmail,
    );
  }

///////////////////////////////////////////////////password field/////////////////////////////
  TextFormField passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your Password',
          labelText: 'Enter your Password',
          hintStyle: TextStyle(color: colorGrey)),
      controller: _passwordController,
      validator: validatePassword,
      obscureText: true,
    );
  }

//////////////////////////////////////////login////////////////////////////////
  login() async {
    String email = _emailController.text.trim();
    String pass = _passwordController.text.trim();

    if (_formKey.currentState.validate()) {
      //form details were filled correctly
      _formKey.currentState.save();
      print('its okay');
      if (email.toLowerCase().trim() == 'admin@mail.com' &&
          pass.trim() == 'Vakporize') {
        //admin
        Navigator.pushNamed(context, '/admin_dashboard');
        displayMsg('Welcome Admin');
      } else {
        try {
          final user = await _auth.signInWithEmailAndPassword(
              email: email, password: pass);
          if (user != null) {
            ///meaning a record with the details exists
            ///so go to student dashboard
            Navigator.pushNamed(context, '/student_dashboard');
            // displayMsg('YOU ARE WELCOME!');
          }
        } catch (e) {
          displayMsg('Wrong details were entered: $e');
        }
      }
    } else {
      ///form fields not correctly filled
      setState(() {
        _validate = true;
        displayMsg("Please fill the form with the correct details");
      });
    }
  }

  register() {
    Navigator.pushNamed(context, '/register');
  }

  googleLogin() {
    print('googlelogin');
  }

  ///////VALIDATE USER
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
  } //validateEmail

  String validatePassword(String value) {
    if (value.length == 0) {
      return "A Password  is Required";
    } else if (value.length < 5) {
      return "Your Password is too short, it must at least five characters";
    }
    return null;
  } //validateName

////////////////////////////////////////////////////////////////////////////////CONTAINERS FOR THE FORM///////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////CONTAINERS FOR EMAIL///////////////////////////////////////
  Container emailContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorGreyWithOpacity,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ///First Child is the email address
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.person_outline,
              color: colorGrey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: emailAddress(),
          ),

          ///second child is the password field
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR EMAIL///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////CONTAINERS FOR PASSWORD///////////////////////////////////////
  Container passwordContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyWithOpacity, width: 1.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.lock_open,
              color: colorGrey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: passwordField(),
          )
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR PASSWORD///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////CONTAINERS FOR CLIP PATH///////////////////////////////////////
  ClipPath clipPathContainer() {
    return ClipPath(
      //ITEM 1...IN THE FRAME
      //add a clipper for the background image
      clipper: MyClipper(),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
        )),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
        child: Column(
          //the text in the background image
          children: <Widget>[
            Text(
              'Learning360',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            )
          ],
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR CLIPPATH///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// CONTAINERS FOR LOGIN BUTTON///////////////////////////////////////
  Container loginButtonContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              splashColor: splashColor,
              color: splashColor,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'LOGIN',
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
                          Icons.arrow_forward,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          login();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                login();
              },
            ),
          )
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////// END CONTAINERS FOR LOGIN BUTTON///////////////////////////////////////V
//////////////////////////////////////////////////////////////////////////////// CONTAINERS FOR GOOGLE LOGIN BUTTON///////////////////////////////////////
  Container googleLoginButtonContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
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
                      'LOGIN WITH GOOGLE',
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
                          Icons.email,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          googleLogin();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                googleLogin();
              },
            ),
          )
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR GOOGLE LOGIN BUTTON///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// CONTAINERS FOR REGISTER BUTTON///////////////////////////////////////
  Container registerButtonContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.center,
                child: Text(
                  "DON'T HAVE AN ACCOUNT?",
                  style: TextStyle(color: primaryColor),
                ),
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
//////////////////////////////////////////////////////////////////////////////// END CONTAINERS FOR REGISTER BUTTON///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR THE FORM///////////////////////////////////////
} //loginpagestate

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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awaazapp/screens/registerScreen.dart';
import 'package:awaazapp/screens/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Coming soon..."),
      content: Text("Feature under development."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color(0xFFffa69e),
          Color(0xFF861657),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 100.0),
          Container(
              margin: EdgeInsets.only(
                bottom: 20.0,
                right: 20.0,
                left: 20.0,
              ),
              child: Image.asset("image/awaaz_icon.png")),
          SizedBox(height: 100),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: _emailController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(16.0)),
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  hintText: "Enter email",
                  hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
              controller: _passwordController,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(16.0)),
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  hintText: "Enter password",
                  hintStyle: TextStyle(fontSize: 18.0, color: Colors.white),
                  labelStyle: TextStyle(
                    color: Colors.white,
                  )),
              obscureText: true,
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 46.0, top: 14.0),
            child: InkWell(
              child: Text(
                "Forgot your password?",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
              onTap: ()async {
                if(_emailController.text != "")
                  {
                authService.resetPassword(_emailController.text);
              }else{
                  showDialog(context: context,
                      builder: (con) {
                        return AlertDialog(title: Text("Error"),content: Text("Enter your email."),);
                      } );
                }
                },
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: RaisedButton(
              onPressed: () async {
                authService
                    .signInWithEmailAndPassword(
                        _emailController.text, _passwordController.text)
                    .then((auth) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                }).catchError((error) {
                  showDialog(
                      context: context,
                      builder: (con) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(error.toString()),
                        );
                      });
                });
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              textColor: Colors.white,
              padding: const EdgeInsets.all(0),
              child: Container(
                alignment: Alignment.center,
                height: 50.0,
                width: MediaQuery.of(context).size.width * .5,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    gradient: new LinearGradient(
                        colors: [Colors.black, Colors.black87])),
                padding: const EdgeInsets.all(0),
                child: Text(
                  "SIGN IN",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  )),
            ],
          )
        ],
      ),
    )));
  }
}

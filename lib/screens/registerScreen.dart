import 'package:awaazapp/screens/uploadProfileImageScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awaazapp/screens/loginScreen.dart';
import 'package:awaazapp/screens/homeScreen.dart';
import '../auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailSignUpController = TextEditingController();
  final TextEditingController _passwordSignUpController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);
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
              Container(
                  margin: EdgeInsets.only(
                    top: 70.0,
                    right: 20.0,
                    left: 20.0,
                  ),
                  child: Image.asset("image/awaaz_icon.png")
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _emailSignUpController,
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
                      hintStyle:
                          TextStyle(fontSize: 18.0, color: Colors.white),
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
                  controller: _passwordSignUpController,
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
                      hintStyle:
                          TextStyle(fontSize: 18.0, color: Colors.white),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                  obscureText: true,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: RaisedButton(
                  onPressed: () async {
                    await authService.createUserWithEmailAndPassword(
                        _emailSignUpController.text, _passwordSignUpController.text).then((value) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UploadProfileImageScreen(email: _emailSignUpController.text)));
                        }).catchError((error){
                      showDialog(context: context,
                          builder: (con) {
                            return AlertDialog(title: Text("Error"),content: Text(error.toString()),);
                          } );
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: MediaQuery.of(context).size.width*.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: new LinearGradient(
                            colors: [Colors.black, Colors.black87])),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "SIGN UP",
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
                    "Already have an account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(width: 5.0,),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        "Sign In",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:awaazapp/screens/loginScreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
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
                    children: [
                      SizedBox(height: 250.0,),
                      // Container(
                      //     margin: EdgeInsets.only(top: 50.0),
                      //     child: Image.asset("image/awaaz_icon.png")),
                      Container(
                          margin: EdgeInsets.only(
                          //   top: 120.0,
                            right: 20.0,
                            left: 20.0,
                          ),
                          child: Image.asset("image/awaaz_logo.png")),
                      SizedBox(height: 100.0),
                      Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width * .5,
                          child: RaisedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text(
                                "Get Started",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.black)),
                      SizedBox(height: 200.0),
                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Container(
                            alignment: Alignment.center,
                            // height: 80.0,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Developed as a part of the 18 under 18 Fellowship program of Whitehat Junior",
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            )
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}

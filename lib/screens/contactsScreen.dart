import 'package:awaazapp/auth_service.dart';
import 'package:awaazapp/database.dart';
import 'package:awaazapp/screens/contactDetails.dart';
import 'package:awaazapp/screens/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awaazapp/screens/addContacts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactsScreen extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  _launchPhoneURL(String phoneNumber) async {
    String url = 'tel:' + phoneNumber;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Emergency Contacts",
            style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold))),
        actions: [
          GestureDetector(
            onTap: () async {
              authService.signOut().then((value) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.logout),
            ),
          )
        ],
        backgroundColor: Color(0xFF8207DF),
      ),
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: ContactDatabase.readUserContacts(userId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0, left: 10.0, right: 10.0,),
                  child: ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0,bottom: 10,left: 10),
                          child: Card(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0,bottom: 10,left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          document["name"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                          ),
                                        ),

                                        SizedBox(height: 10.0),
                                        Text(
                                          document["phone"],
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0,bottom: 10,right: 10),
                                      child: Container(
                                        width: 42.0,
                                        height: 42.0,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF414350),
                                          borderRadius: BorderRadius.circular(50.0),
                                        ),
                                        child: IconButton(
                                          color: Colors.white,
                                          icon: Icon(Icons.call),
                                          onPressed: () {
                                            FlutterPhoneDirectCaller.callNumber(document["phone"].toString());
                                          },
                                        ),
                                      ),
                                    ),

                                  ],
                                ),

                              ],
                            ),
                          ),
                        );
                      }).toList()),
                );
              }
          )
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddContacts()),
            );
          },
          tooltip: "Add Post",
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF8207DF),
          // ));
        )
    );
  }
}

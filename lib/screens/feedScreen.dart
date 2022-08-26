import 'package:awaazapp/database.dart';
import 'package:awaazapp/screens/addFeed.dart';
import 'package:awaazapp/screens/loginScreen.dart';
import 'package:awaazapp/screens/postDescriptionScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../auth_service.dart';

class FeedScreen extends StatelessWidget {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("News Feed",
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
        body: _buildListView(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePost()),
            );
          },
          tooltip: "Add Post",
          child: Icon(Icons.add),
          backgroundColor: Color(0xFF8207DF),
          // ));
        ));
  }

  Widget _buildListView(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: PostDatabase.readAllPosts(userId),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top:20.0, left:10.0, right: 10.0,),
                child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PostDescriptionScreen(document: document)
                          ));
                        },
                        child: Card(
                          margin: EdgeInsets.only(bottom: 20),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(document["userImage"]),
                                          radius: 28.0,
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 6.0, horizontal: 16.0),
                                                child: Text(
                                                  document["username"],
                                                  style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              // Padding(
                                              //   padding:
                                              //   const EdgeInsets.symmetric(horizontal: 16.0),
                                              //   child: Text(DateTime.fromMillisecondsSinceEpoch(document['time_stamp']).toString(),
                                              //     style: TextStyle(
                                              //       color: Colors.grey,
                                              //       fontSize: 14.0,
                                              //     ),
                                              //   ),
                                              // ),
                                              // const SizedBox(height: 5.0),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(document["postImage"]),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          document["title"],
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Text(document['description'])),
                                  const SizedBox(height: 20.0),
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
    );
  }
}

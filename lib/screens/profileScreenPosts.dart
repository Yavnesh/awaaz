import 'package:awaazapp/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreenPosts extends StatefulWidget {
  const ProfileScreenPosts({Key? key}) : super(key: key);

  @override
  _ProfileScreenPostsState createState() => _ProfileScreenPostsState();
}

class _ProfileScreenPostsState extends State<ProfileScreenPosts> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: PostDatabase.readUserPosts(userId),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                left: 10.0,
                right: 10.0,
              ),
              child: ListView(
                  children: snapshot.data!.docs.map((document) {
                return InkWell(
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(
                    //     document: document
                    // )));
                  },
                  child: Container(
                    height: 300,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                          document["postImage"],
                          fit: BoxFit.cover),
                    ),
                  ),
                );
              }).toList()),
            );
          }),
    );
  }
}

// import 'dart:core';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class Database {
//
//   static User user = FirebaseAuth.instance.currentUser;
//
//   static void updatePostref(String uid) {
//     postsRef =
//         FirebaseFirestore.instance.collection('users').doc(uid).collection(
//             'posts').withConverter<Post>(
//           fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()),
//           toFirestore: (note, _) => note.toJson(),
//         );
//   }
//
//   static var postsRef =
//   FirebaseFirestore.instance.collection('users').doc(user.uid).collection(
//       'posts').withConverter<Post>(
//     fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()),
//     toFirestore: (note, _) => note.toJson(),
//   );
//
//   static Stream<QuerySnapshot<Post>> posts = postsRef.snapshots();
//
//   static Future<void> addPost(Post data, BuildContext context) {
//     // Call the user's CollectionReference to add a new user
//     return postsRef
//         .add(data)
//         .then((value) =>
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text('Post Added'))))
//         .catchError((error) => print("Failed to add post: $error"));
//   }
// }
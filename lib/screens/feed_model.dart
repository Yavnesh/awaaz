import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FeedModel {
  String? docID ;
  String? title ;
  String? post ;

  var _uid = FirebaseAuth.instance.currentUser;
  FeedModel({this.docID, this.post, this.title});

  FeedModel.fromMap(DocumentSnapshot data) {
    docID = _uid as String?;
    title = data["title"];
    post = data["post"];
  }
}
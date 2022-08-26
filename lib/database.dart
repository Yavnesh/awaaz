import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _postCollection = _firestore.collection('posts');
final CollectionReference _userCollection = _firestore.collection('users');
final CollectionReference _contactCollection = _firestore.collection('contact');

class PostDatabase {
  static Future<void> addPost({
    String? userId,
    String? title,
    String? description,
    String? post_image,
    String? user_name,
    String? user_image
  }) async {
    DocumentReference documentReference =
    _postCollection.doc(DateTime.now().millisecondsSinceEpoch.toString());

    Map<String, dynamic> data = <String, dynamic>{
      "userId": userId,
      "title": title,
      "description": description,
      "postImage": post_image,
      "time_stamp": DateTime.now().millisecondsSinceEpoch.toString(),
      "username": user_name,
      "userImage": user_image,
    };
    await documentReference
        .set(data)
        .whenComplete(() => print("Post added to database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readAllPosts(uid) {
    String? userId = uid;
    return FirebaseFirestore.instance
        .collection('posts').where('userId', isNotEqualTo: userId).snapshots();
  }

  static Stream<QuerySnapshot> readUserPosts(uid) {
    String? userId = uid;
    return FirebaseFirestore.instance
        .collection('posts').where('userId', isEqualTo: userId).snapshots();
  }

}

class UserDatabase {
  static Future<void> addUser({
    String? userId,
    String? name,
    String? phone,
    String? user_image,
    String? category,
    String? email,
  }) async {
    DocumentReference documentReference =
    _userCollection.doc(DateTime.now().millisecondsSinceEpoch.toString());

    Map<String, dynamic> data = <String, dynamic>{
      "userId": userId,
      "name": name,
      "phone": phone,
      "user_image": user_image,
      "category": category,
      "email": email,
      "time_stamp": DateTime.now().millisecondsSinceEpoch.toString()
    };
    await documentReference
        .set(data)
        .whenComplete(() => print("User added to database"))
        .catchError((e) => print(e));
  }

  static readUser(uid) {
    String? userId = uid;
    return FirebaseFirestore.instance
        .collection('users').where('userId', isEqualTo: userId).snapshots();
  }
}

class ContactDatabase {
  static Future<void> addContact({
    String? userId,
    String? name,
    String? phoneNo,
  }) async {
    DocumentReference documentReference =
    _contactCollection.doc("$userId"+ DateTime.now().millisecondsSinceEpoch.toString());

    Map<String, dynamic> data = <String, dynamic>{
      "userId": userId,
      "name": name,
      "phone": phoneNo,
      "time_stamp": DateTime.now().millisecondsSinceEpoch.toString()
    };
    await documentReference
        .set(data)
        .whenComplete(() => print("Contact added to database"))
        .catchError((e) => print(e));
  }

  static readUserContacts(uid) {
    String? userId = uid;
    return FirebaseFirestore.instance
        .collection('contact').where('userId', isEqualTo: userId).snapshots();
  }
}
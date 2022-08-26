import 'dart:io';

import 'package:awaazapp/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String uploadedPath = "";
  late XFile _image;
  ImagePicker imagePicker = ImagePicker();
  bool _isLoading = false;
  File? _imageFile;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  void clearText() {
    titleController.clear();
    descriptionController.clear();

    setState(() {
      _imageFile = null;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   var readUser = UserDatabase.readUser(userId);
  // }

  //select image from source
  selectImage() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) =>
            BottomSheet(
              builder: (context) =>
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    ListTile(
                        leading: Icon(Icons.camera),
                        title: Text("Camera"),
                        onTap: () {
                          Navigator.of(context).pop();
                          imagePickerMethod(ImageSource.camera);
                        }),
                    ListTile(
                        leading: Icon(Icons.filter),
                        title: Text("Gallery"),
                        onTap: () {
                          Navigator.of(context).pop();
                          imagePickerMethod(ImageSource.gallery);
                        })
                  ]),
              onClosing: () {},
            ));
  }

  imagePickerMethod(ImageSource source) async {
    var pic = await imagePicker.pickImage(source: source);
    if (pic != null) {
      setState(() {
        _image = XFile(pic.path);
      });
    }
    uploadImage(); // image upload function
  }

  void uploadImage() {
    String imageFileName = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final Reference storageReference =
    FirebaseStorage.instance.ref().child('Images').child(imageFileName);
    final UploadTask uploadTask = storageReference.putFile(File(_image.path));
    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        _isLoading = true;
      });
    });
    uploadTask.then((TaskSnapshot taskSnapshot) async {
      uploadedPath = await uploadTask.snapshot.ref.getDownloadURL();
      print(uploadedPath);

      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {});
  }

  void saveData(name,user_img) {
    PostDatabase.addPost(
        userId: userId,
        title: titleController.text,
        description: descriptionController.text,
        post_image: uploadedPath,
        user_name: name,
        user_image: user_img
    );
  }

  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> _stream;
    _stream = UserDatabase.readUser(userId);
    return StreamBuilder(
        stream: _stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List userDetails = [];
          snapshot.data!.docs.map((e) {
            Map details = e.data() as Map<String, dynamic>;
            userDetails.add(details);
          }).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text("Create Post",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold))),
              backgroundColor: Color(0xFF8207DF),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        _imageFile != null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              child: Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width - 20,
                                child: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ],
                        )
                            : GestureDetector(
                          onTap: () {
                            selectImage();
                          },
                          child: Card(
                            elevation: 2,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * .3,
                              child: _isLoading == false
                                  ? Container(
                                child: uploadedPath == ""
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Color(0xFF8207DF),
                                      size: 100,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        "Upload Image",
                                        style:
                                        TextStyle(fontSize: 22),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                          "click here for upload image"),
                                    )
                                  ],
                                )
                                    : Image(
                                    image:
                                    NetworkImage(uploadedPath)),
                              )
                                  : CircularProgressIndicator(
                                color: Color(0xFF8207DF),
                              ),
                              // child: Image.asset(
                              //   'assets/images/upload.png',
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                          child: TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                                labelText: "Title", floatingLabelBehavior: FloatingLabelBehavior.auto),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                          child: TextField(
                            controller: descriptionController,
                            maxLength: 150,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLines: 3,
                            decoration: InputDecoration(
                                labelText: "Description", floatingLabelBehavior: FloatingLabelBehavior.auto),
                          ),
                        ),
                        const SizedBox(height: 60.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            padding: const EdgeInsets.fromLTRB(
                                40.0, 16.0, 30.0, 16.0),
                            color: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0))),
                            onPressed: () {
                              saveData(userDetails[0]['name'],userDetails[0]['user_image'],);
                              clearText();
                              Fluttertoast.showToast(
                                  msg: "Post added successfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM);
                              Navigator.pop(context);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "Create Post".toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          );;
        });


  }
}

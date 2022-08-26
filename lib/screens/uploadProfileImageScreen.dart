import 'dart:io';

import 'package:awaazapp/auth_service.dart';
import 'package:awaazapp/database.dart';
import 'package:awaazapp/screens/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadProfileImageScreen extends StatefulWidget {
  final String? email;
  const UploadProfileImageScreen({Key? key, this.email}) : super(key: key);

  @override
  _UploadProfileImageScreenState createState() => _UploadProfileImageScreenState();
}

class _UploadProfileImageScreenState extends State<UploadProfileImageScreen> {
  String uploadedPath = "";
  late XFile _image;
  ImagePicker imagePicker = ImagePicker();
  bool _isLoading = false;
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  var _user = ['Victim', 'Organisation'];
  var _currentItemSelected = 'Victim';

  selectImage() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
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
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
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

  void saveUser() {
    UserDatabase.addUser(
        userId: userId,
        name: _nameController.text,
        phone: _phoneNumberController.text,
        user_image: uploadedPath,
        category: _currentItemSelected,
        email: widget.email.toString(),
    ).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home())));
  }

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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
                            width: MediaQuery.of(context).size.width - 20,
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
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFffa69e),
                                Color(0x80861657),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .3,
                          child: _isLoading == false
                              ? Container(
                            child: uploadedPath == ""
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Colors.black,
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
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _nameController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16.0)),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: "Enter name",
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
                child: TextField(
                  controller: _phoneNumberController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16.0)),
                      prefixIcon: const Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      hintText: "Enter phone number",
                      hintStyle:
                      TextStyle(fontSize: 18.0, color: Colors.white),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.0),
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black45, width: 1),
                      borderRadius: BorderRadius.circular(16)
                  ),
                  height: 50,
                  // child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.black,
                    isExpanded: true,
                    underline: SizedBox(),
                    items: _user.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String? newValueSelected) {
                      setState(() {
                        this._currentItemSelected = newValueSelected!;
                      });
                    },

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white,),
                    iconSize: 36,
                    value: _currentItemSelected,
                  )),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: RaisedButton(
                  onPressed: () async {
                    saveUser();
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
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

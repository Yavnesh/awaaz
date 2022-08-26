import 'package:flutter/material.dart';
import 'package:awaazapp/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddContacts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddContactsState();
  }
}

class AddContactsState extends State<AddContacts> {
  // late String _contactname;
  // late String _contactnumber;
  final TextEditingController _contactname = TextEditingController();
  final TextEditingController _contactnumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Coming soon..."),
      content: Text("Feature under development."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void saveData(name,contact) {
    ContactDatabase.addContact(
        userId: userId,
        name: name,
        phoneNo: contact,
    );
  }

  Widget _buildContactName() {
    margin:
    EdgeInsets.only(
      bottom: 10.0,
    );
    return TextFormField(
      controller: _contactname,
      decoration: InputDecoration(
          labelText: 'Contact name',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFF8207DF)),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFF8207DF)),
            borderRadius: BorderRadius.circular(15),
          )),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Contact name is Required';
        }

        return null;
      },

    );
  }

  Widget _buildContactNumber() {
    margin:
    EdgeInsets.only(
      top: 10.0,
    );
    return TextFormField(
      controller: _contactnumber,
      decoration: InputDecoration(
          labelText: 'Contact number',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFF8207DF)),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFF8207DF)),
            borderRadius: BorderRadius.circular(15),
          )),
      keyboardType: TextInputType.visiblePassword,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Contact number is Required';
        }

        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ADD CONTACTS", style: GoogleFonts.lato(textStyle: TextStyle(color:Colors.white,fontSize: 22,))), backgroundColor: Color(0xFF8207DF)),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(margin: EdgeInsets.all(10), child: _buildContactName()),
                Container(margin: EdgeInsets.all(10), child: _buildContactNumber()),
                SizedBox(height: 300),
                Container(
                  height: 40.0,
                  width: 120.0,
                  child: RaisedButton(
                    child: Text(
                      'Submit',
                        style: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white, fontSize: 18,))
                    ),

                      onPressed: () {
                        saveData(_contactname.text, _contactnumber.text,);
                        // clearText();
                        Fluttertoast.showToast(
                            msg: "Post added successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM);
                        Navigator.pop(context);
                      },
                    color: Color(0xFF8207DF),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  // Future getContacts(contactName, contactNumber) async{
  //   var _uid = FirebaseAuth.instance.currentUser.uid;
  //   var b = await FirebaseFirestore.instance.collection("contact").doc(_uid).get();
  //   if(b.exists){
  //     // updateFeedData() async{
  //     CollectionReference contact = FirebaseFirestore.instance.collection("contact");
  //     QuerySnapshot querySnapshot = await contact.get();
  //     final allContacts = querySnapshot.docs.map((e) => e.data()).toList();
  //     print(allContacts);
  //     var allcontacts = contact.doc(_uid).get().then((value) => print(value.data()));
  //     DocumentReference userContacts = FirebaseFirestore.instance.collection("contact").doc(_uid);
  //
  //     userContacts.update
  //       ({'contacts':FieldValue.arrayUnion([{'contactName': contactName,'contactNumber': contactNumber}])}).then((value) => Fluttertoast.showToast(msg:"Contact saved successfully", toastLength: Toast.LENGTH_SHORT)
  //     );
  //
  //     // }
  //     return b;
  //   }
  //   print(!b.exists);
  //   if(!b.exists) {
  //     // saveFeedData(title,post) async{
  //     CollectionReference contact = FirebaseFirestore.instance.collection(
  //         "contact");
  //     QuerySnapshot querySnapshot = await contact.get();
  //     final allContacts = querySnapshot.docs.map((e) => e.data()).toList();
  //     print(allContacts);
  //     var allcontacts = contact.doc(_uid).get().then((value) =>
  //         print(value.data()));
  //     DocumentReference userContacts = FirebaseFirestore.instance.collection(
  //         "contact").doc(_uid);
  //
  //     userContacts.set
  //       ({
  //       'contacts': FieldValue.arrayUnion(
  //           [{'contactName': contactName, 'contactNumber': contactNumber}])
  //     }).then((value) =>
  //         Fluttertoast.showToast(msg: "Contact saved successfully",
  //             toastLength: Toast.LENGTH_SHORT)
  //     );
  //   }
  //   // }
  // }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactDetail extends StatelessWidget {
  final int index;
  ContactDetail(this.index);
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("CONTACT DETAILS"), backgroundColor: Color(0xFF8207DF)), body: Center(child: Text("Text")));
  }
}

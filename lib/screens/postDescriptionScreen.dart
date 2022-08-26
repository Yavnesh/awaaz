import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDescriptionScreen extends StatefulWidget {
  final document;
  const PostDescriptionScreen({Key? key, this.document}) : super(key: key);

  @override
  _PostDescriptionScreenState createState() => _PostDescriptionScreenState();
}

class _PostDescriptionScreenState extends State<PostDescriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Description",
            style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold))),
        backgroundColor: Color(0xFF8207DF),
      ),
      body: _buildPageContent(context),
    );
  }

  Widget _buildPageContent(context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              _buildItemCard(context),
              Container(
                  padding: EdgeInsets.all(30.0),
                  child: Text(
                      widget.document["description"])),
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                      child: Text( "Posted By:", style: TextStyle(fontSize: 16.0),)),
                  Container(
                      padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                      child: Text( widget.document["username"], style: TextStyle(fontSize: 16.0),)),

                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(context) {
    return Stack(
      children: <Widget>[
        Card(
          margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(widget.document["postImage"], height: MediaQuery.of(context).size.width,),
                ),
                SizedBox(height: 10.0,),
                Text(widget.document["title"], style: TextStyle(fontSize: 24.0),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
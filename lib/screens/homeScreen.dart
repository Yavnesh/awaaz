import 'package:awaazapp/screens/profileScreen.dart';
import 'package:awaazapp/screens/uploadProfileImageScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awaazapp/screens/feedScreen.dart';
import 'package:awaazapp/screens/contactsScreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    // UploadProfileImageScreen(),
    ProfileScreen(),
    FeedScreen(),
    ContactsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem
              (
                icon: Icon(Icons.person),
                title: Text("Profile"),
                backgroundColor: Color(0xFF8207DF)
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: Text("Home"),
                backgroundColor: Color(0xFF8207DF)),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.phone,
              ),
              title: Text("Contacts"),
            ),
          ],
          selectedItemColor: Color(0xFF8207DF),
          unselectedItemColor: Colors.black),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
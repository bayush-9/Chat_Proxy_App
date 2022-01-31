import 'package:chat_app/screens/group_screen_work.dart';
import 'package:chat_app/screens/groups_screen.dart';
import 'package:chat_app/screens/join_group.dart';
import 'package:chat_app/screens/new_group_form.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/screens/main_groups_screen.dart';
import 'package:flutter/material.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    Work2(),
    NewGroupForm(),
    JoinGroupScreen(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('ProxyManager'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.group,
              color: Colors.amber,
            ),
            label: 'My groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.amber,
            ),
            label: 'Create group',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.input,
              color: Colors.amber,
            ),
            label: 'Join Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_sharp,
              color: Colors.amber,
            ),
            label: 'Join Group',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
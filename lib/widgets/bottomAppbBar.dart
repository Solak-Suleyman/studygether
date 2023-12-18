import 'package:flutter/material.dart';
import 'package:studygether/pages/HomePage.dart';
import 'package:studygether/pages/ProfilePage.dart';
import 'package:studygether/pages/SearchPage.dart';
import 'package:studygether/widgets/widgets.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    SearchPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    int _selectedIndex=0;
    return BottomNavigationBar(
        onTap: (int index){
          nextScreen(context, _pages.elementAt(index));
        },
        currentIndex: _selectedIndex,
        items: const[

        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.book_outlined), label: "Search Lessons"),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined),label: "Setting")

      ]);
  }
}
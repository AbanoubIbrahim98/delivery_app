import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/pages/home.dart';
import 'package:instamarket/src/pages/category.dart';
import 'package:instamarket/src/pages/cart.dart';
import 'package:instamarket/src/pages/savings.dart';
import 'package:instamarket/translations.dart';

class BottomNavigation extends StatefulWidget {
  final VoidCallback menuClick;
  BottomNavigation({this.menuClick});

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Widget _tabs() {
    if (_selectedIndex == 0)
      return Home(menuClick: widget.menuClick);
    else if (_selectedIndex == 3)
      return Cart();
    else if (_selectedIndex == 1)
      return Category();
    else
      return Savings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _tabs(),
      ),
      bottomNavigationBar: Container(
        decoration:
            BoxDecoration(color: Theme.of(context).buttonColor, boxShadow: [
          BoxShadow(
              blurRadius: 20,
              color: Theme.of(context).primaryColor.withOpacity(0.1))
        ]),
        child: SafeArea(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  gap: 8,
                  activeColor: Theme.of(context).primaryColor,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 800),
                  tabBackgroundColor: Color.fromRGBO(33, 160, 54, 1),
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: Translations.of(context).text('home'),
                      textColor: Theme.of(context).buttonColor,
                      iconColor: Theme.of(context).primaryColor,
                      iconActiveColor: Theme.of(context).buttonColor,
                    ),
                    GButton(
                      icon: LineIcons.list,
                      text: Translations.of(context).text('category'),
                      textColor: Theme.of(context).buttonColor,
                      iconColor: Theme.of(context).primaryColor,
                      iconActiveColor: Theme.of(context).buttonColor,
                    ),
                    GButton(
                      icon: LineIcons.thList,
                      text: Translations.of(context).text('savings'),
                      textColor: Theme.of(context).buttonColor,
                      iconColor: Theme.of(context).primaryColor,
                      iconActiveColor: Theme.of(context).buttonColor,
                    ),
                    GButton(
                      icon: LineIcons.shoppingCart,
                      text: Translations.of(context).text('cart'),
                      textColor: Theme.of(context).buttonColor,
                      iconColor: Theme.of(context).primaryColor,
                      iconActiveColor: Theme.of(context).buttonColor,
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  })),
        ),
      ),
    );
  }
}

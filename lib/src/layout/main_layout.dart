import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/menu_button.dart';
import 'package:instamarket/src/layout/bottom_navigation.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/translations.dart';

class MainLayout extends StatefulWidget {
  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  AnimationController _controller;
  Animation<double> _scaleAnimation;
  Animation<double> _menuScaleAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 160, 54, 1),
      body: Stack(
        children: <Widget>[
          menu(),
          dashboard(),
        ],
      ),
    );
  }

  Widget menu() {
    User user = context.watch<AuthNotifier>().user;
    bool isAuthenticated = context.watch<AuthNotifier>().isAuthenticated;

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 50),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  width: 0.5,
                                  color: Theme.of(context)
                                      .buttonColor
                                      .withOpacity(0.5))),
                          child: Image.asset(
                            "lib/assets/images/deliveryman.png",
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          width: 0.5.sw,
                          height: 60,
                          margin: EdgeInsets.only(bottom: 10, left: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                              isAuthenticated && user != null
                                  ? "${user.name} ${user.surname}"
                                  : Translations.of(context).text('guest'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 16.sp)),
                        )
                      ],
                    ),
                    if (isAuthenticated)
                      MenuButton(
                          title: Translations.of(context).text('order_history'),
                          leftIcon: LineIcons.history,
                          onTap: () {
                            Navigator.of(context).pushNamed("/Orders");
                          },
                          rightIcon: true),
                    MenuButton(
                        title: Translations.of(context).text('liked_products'),
                        leftIcon: LineIcons.heartAlt,
                        onTap: () {
                          Navigator.of(context).pushNamed("/LikedProducts");
                        },
                        rightIcon: true),
                    if (isAuthenticated)
                      MenuButton(
                          title: Translations.of(context).text('profile'),
                          leftIcon: LineIcons.user,
                          onTap: () {
                            Navigator.of(context).pushNamed("/Profile",
                                arguments: {"user": user});
                          },
                          rightIcon: true),
                    MenuButton(
                        title: Translations.of(context).text('addresses'),
                        leftIcon: LineIcons.locationArrow,
                        onTap: () {
                          Navigator.of(context).pushNamed("/UserLocationList",
                              arguments: {"onGoBack": () {}});
                        },
                        rightIcon: true),
                    MenuButton(
                        title: Translations.of(context).text('settings'),
                        leftIcon: LineIcons.wrench,
                        onTap: () {
                          Navigator.of(context).pushNamed("/Settings");
                        },
                        rightIcon: true),
                    MenuButton(
                        title: Translations.of(context).text('qa'),
                        leftIcon: LineIcons.question,
                        onTap: () {
                          Navigator.of(context).pushNamed("/Qa");
                        },
                        rightIcon: true),
                    MenuButton(
                        title: Translations.of(context).text('about'),
                        leftIcon: LineIcons.bookmarkAlt,
                        onTap: () {
                          Navigator.of(context).pushNamed("/About");
                        },
                        rightIcon: true),
                  ],
                ),
                if (isAuthenticated)
                  MenuButton(
                      title: Translations.of(context).text('exit'),
                      leftIcon: Icons.exit_to_app,
                      onTap: () {
                        context.read<AuthNotifier>().logOut();
                      },
                      rightIcon: false),
                if (!isAuthenticated)
                  MenuButton(
                      title: Translations.of(context).text('signin'),
                      leftIcon: Icons.login_outlined,
                      onTap: () {
                        context.read<AuthNotifier>().logOut();
                        Navigator.of(context).pushNamed('/Login');
                      },
                      rightIcon: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dashboard() {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6.sw,
      right: isCollapsed ? 0 : -0.6.sw,
      child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            child: Stack(
              children: <Widget>[
                Material(
                    animationDuration: duration,
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    elevation: 8,
                    color: Theme.of(context).buttonColor,
                    child: BottomNavigation(menuClick: () {
                      setState(() {
                        if (isCollapsed)
                          _controller.forward();
                        else
                          _controller.reverse();

                        isCollapsed = !isCollapsed;
                      });
                    })),
                if (!isCollapsed)
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.transparent,
                      ))
              ],
            ),
            onTap: () {
              if (!isCollapsed)
                setState(() {
                  if (isCollapsed)
                    _controller.forward();
                  else
                    _controller.reverse();

                  isCollapsed = !isCollapsed;
                });
            },
          )),
    );
  }
}

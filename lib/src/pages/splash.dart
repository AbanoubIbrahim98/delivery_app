import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/splash_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:instamarket/src/widgets/splash_button.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/translations.dart';

const splashData = [
  {
    "title": "Select a shop",
    "image": 'lib/assets/images/deliveryman.png',
    "description":
        "This is shop description in splash screen page. Change this like you want.",
  },
  {
    "title": "Select a shop",
    "image": 'lib/assets/images/deliveryman.png',
    "description":
        "This is shop description in splash screen page. Change this like you want.",
  },
  {
    "title": "Select a shop",
    "image": 'lib/assets/images/deliveryman.png',
    "description":
        "This is shop description in splash screen page. Change this like you want.",
  },
  {
    "title": "Select a shop",
    "image": 'lib/assets/images/deliveryman.png',
    "description":
        "This is shop description in splash screen page. Change this like you want.",
  },
  {
    "title": "Select a shop",
    "image": 'lib/assets/images/deliveryman.png',
    "description":
        "This is shop description in splash screen page. Change this like you want.",
  }
];

class Splash extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  double currentPage = 0.0;
  final pageViewController = new PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 160, 54, 1),
      body: Container(
          width: 1.sw,
          height: 1.sh,
          child: Column(
            children: <Widget>[
              Container(
                height: 0.75.sh,
                padding: EdgeInsets.symmetric(vertical: 0.05.sh),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          spreadRadius: 5,
                          blurRadius: 15,
                          offset: Offset(1, 1),
                          color: Colors.black.withOpacity(0.2))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 1.sw,
                      height: 0.5.sh,
                      child: Stack(
                        children: <Widget>[
                          PageView.builder(
                            controller: pageViewController,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              pageViewController.addListener(() {
                                setState(() {
                                  currentPage = pageViewController.page;
                                });
                              });

                              return SplashPage(
                                title: splashData[index]["title"],
                                image: splashData[index]["image"],
                                description: splashData[index]["description"],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: 1.sw,
                        padding: EdgeInsets.symmetric(vertical: 0.04.sh),
                        alignment: Alignment.center,
                        child: SmoothPageIndicator(
                          controller: pageViewController,
                          count: 5,
                          effect: ExpandingDotsEffect(
                              activeDotColor: Color.fromRGBO(33, 160, 54, 1),
                              expansionFactor: 2,
                              dotHeight: 5),
                        ))
                  ],
                ),
              ),
              Container(
                height: 0.25.sh,
                padding: EdgeInsets.symmetric(horizontal: 0.075.sw),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        context.read<AuthNotifier>().makeGuest();
                      },
                      child: Container(
                        width: 0.9.sw,
                        height: 60,
                        child: Text(
                          Translations.of(context).text('getting_started'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).buttonColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SplashOutlinedButton(
                          name: Translations.of(context).text('signin'),
                          onPress: () {
                            Navigator.of(context).pushNamed('/Login');
                          },
                        ),
                        SplashOutlinedButton(
                          name: Translations.of(context).text('signup'),
                          onPress: () {
                            Navigator.of(context).pushNamed('/Registration');
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/routes.dart';
import 'package:instamarket/theme/light_theme.dart';
import 'package:instamarket/theme/dark_theme.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/pages/loading_page.dart';
import 'package:instamarket/src/pages/no_connection.dart';
import 'package:instamarket/src/pages/shops.dart';
import 'package:instamarket/src/layout/main_layout.dart';
import 'package:instamarket/src/pages/splash.dart';
import 'package:instamarket/src/models/Address.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/notifier/AppLanguage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:instamarket/translations.dart';
import 'package:instamarket/src/notifier/SettingsNotifier.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthNotifier(),
      ),
      ChangeNotifierProvider(
        create: (_) => AddressNotifier(),
      ),
      ChangeNotifierProvider(
        create: (_) => ShopNotifier(),
      ),
      ChangeNotifierProvider(
        create: (_) => SettingsNotifier(),
      ),
      ChangeNotifierProvider(
        create: (_) => AppLanguage(),
      ),
    ],
    child: MyApp(),
  ));

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark);

    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> connectivitySubscription;
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  bool loading = true;
  final List<String> supportedLanguages = ['en', 'zh', 'fr', 'it', 'ru', 'es'];

  Iterable<Locale> supportedLocales() =>
      supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  @override
  void initState() {
    super.initState();
    initConnectivity();

    connectivitySubscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) => {
              this.setState(() {
                connectivityResult = result;
                loading = false;
              })
            });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return Future.value(null);
    }

    this.setState(() {
      connectivityResult = result;
      loading = false;
    });
  }

  Widget renderContent() {
    bool isAuthenticated = context.watch<AuthNotifier>().isAuthenticated;
    bool isGuest = context.watch<AuthNotifier>().isGuest;
    List<Address> addresses = context.watch<AddressNotifier>().addresses;
    List<Shop> shops = context.watch<ShopNotifier>().shops;

    if (loading) return LoadingPage();

    if (!(connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile))
      return NoInternetConnection();

    if (!isAuthenticated && !isGuest) return Splash();

    if (shops.length == 0 || addresses.length == 0)
      return Shops(addresses: addresses);

    return MainLayout();
  }

  @override
  Widget build(BuildContext context) {
    int mode = context.watch<SettingsNotifier>().mode;
    return ScreenUtilInit(
        designSize: Size(360, 690),
        builder: () => MaterialApp(
              title: 'instamarket',
              debugShowCheckedModeBanner: false,
              theme: mode == 0 ? lightTheme() : darkTheme(),
              darkTheme: darkTheme(),
              builder: (BuildContext context, Widget child) {
                return new Directionality(
                  textDirection: TextDirection.ltr,
                  child: new Builder(
                    builder: (BuildContext context) {
                      return new MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaleFactor: 1.0,
                        ),
                        child: child,
                      );
                    },
                  ),
                );
              },
              localizationsDelegates: [
                Translations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: supportedLocales(),
              home: renderContent(),
              onGenerateRoute: Routes.routes,
            ));
  }
}

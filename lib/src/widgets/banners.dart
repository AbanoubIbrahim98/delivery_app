import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/requests/banners.dart';
import 'package:instamarket/src/widgets/banner_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:instamarket/src/widgets/effects/banner_effect.dart';

class Banners extends StatefulWidget {
  @override
  BannersState createState() => BannersState();
}

class BannersState extends State<Banners> {
  double currentPage = 0;
  final pageViewController = new PageController();
  Color indicatorColor = Colors.white;

  Future<Map<String, dynamic>> getBanners(int shopId) async {
    Map<String, dynamic> data = await bannersRequest(shopId);

    return data;
  }

  int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();

    return FutureBuilder<Map<String, dynamic>>(
        future: getBanners(shop.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> data = snapshot.data;
            List bannerData = data["data"];

            return bannerData.length > 0
                ? Stack(
                    children: <Widget>[
                      Container(
                        width: 1.sw,
                        height: 180,
                        margin: EdgeInsets.only(top: 10),
                        child: PageView.builder(
                            controller: pageViewController,
                            itemCount: bannerData.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              String imageUrl = bannerData[index]['image_url'];
                              String backgroundColorData =
                                  bannerData[index]['background_color'];
                              String titleColorData =
                                  bannerData[index]['title_color'];
                              String buttonColorData =
                                  bannerData[index]['button_color'];
                              String indicatorColorData =
                                  bannerData[index]['indicator_color'];
                              String position = bannerData[index]['position'];
                              String title =
                                  bannerData[index]['lang'][0]['title'];
                              String description =
                                  bannerData[index]['lang'][0]['description'];
                              Color backgroundColor =
                                  Color(getColorFromHex(backgroundColorData));
                              Color titleColor =
                                  Color(getColorFromHex(titleColorData));
                              Color buttonColor =
                                  Color(getColorFromHex(buttonColorData));

                              pageViewController.addListener(() {
                                setState(() {
                                  currentPage = pageViewController.page;
                                  indicatorColor = Color(
                                      getColorFromHex(indicatorColorData));
                                });
                              });

                              return InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed("/BannerDetails", arguments: {
                                    "id": bannerData[index]['id'],
                                    "title": title,
                                    "description": description,
                                    "position": position,
                                    "imageUrl": imageUrl,
                                    "backgroundColor": backgroundColor,
                                    "titleColor": titleColor
                                  });
                                },
                                child: BannerItem(
                                  id: bannerData[index]['id'],
                                  title: title,
                                  description: description,
                                  position: position,
                                  imageUrl: imageUrl,
                                  backgroundColor: backgroundColor,
                                  titleColor: titleColor,
                                  withButton: true,
                                  buttonColor: buttonColor,
                                ),
                              );
                            }),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 15,
                        child: Container(
                            width: 1.sw,
                            alignment: Alignment.center,
                            child: SmoothPageIndicator(
                              controller: pageViewController,
                              count: bannerData.length,
                              effect: SwapEffect(
                                  activeDotColor: indicatorColor,
                                  dotWidth: 7,
                                  dotHeight: 7),
                            )),
                      )
                    ],
                  )
                : Container();
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return BannerEffect();
        });
  }
}

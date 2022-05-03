import 'package:flutter/material.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandItem extends StatelessWidget {
  final String imageUrl;
  final bool isMain;
  final String name;
  final int id;

  BrandItem({this.imageUrl, this.isMain = false, this.id, this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed("/BrandProducts",
            arguments: {"id": id, "imageUrl": imageUrl, "name": name});
      },
      child: Container(
        width: isMain ? 160 : 0.5.sw - 25,
        height: isMain ? 160 : 180,
        margin: isMain
            ? EdgeInsets.only(right: 10)
            : EdgeInsets.symmetric(vertical: 5),
        decoration: isMain
            ? BoxDecoration()
            : BoxDecoration(
                boxShadow: <BoxShadow>[
                    BoxShadow(
                        offset: Offset(1, 1),
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        blurRadius: 5,
                        spreadRadius: 0)
                  ],
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).buttonColor),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "$GLOBAL_URL$imageUrl",
            fit: BoxFit.fitWidth,
            height: isMain ? 160 : 180,
            width: isMain ? 160 : 0.4.sw - 25,
            loadingBuilder: (BuildContext ctx, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Image.asset(
                  "lib/assets/images/default.png",
                  fit: BoxFit.fitWidth,
                  height: isMain ? 160 : 180,
                  width: isMain ? 160 : 0.4.sw - 25,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

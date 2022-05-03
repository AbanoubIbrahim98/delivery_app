import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:instamarket/translations.dart';

class BannerItem extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final String position;
  final String imageUrl;
  final Color backgroundColor;
  final Color titleColor;
  final Color buttonColor;
  final bool withButton;

  BannerItem(
      {this.id,
      this.title,
      this.description,
      this.position,
      this.imageUrl,
      this.backgroundColor,
      this.titleColor,
      this.buttonColor,
      this.withButton = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: 1.sw,
      padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(1, 1),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          image: DecorationImage(
            image: NetworkImage(
              "$GLOBAL_URL$imageUrl",
            ),
            fit: BoxFit.cover,
          ),
          color: backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: position == 'left'
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              title,
              textAlign: position == 'left' ? TextAlign.left : TextAlign.end,
              maxLines: 1,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              textAlign: position == 'left' ? TextAlign.left : TextAlign.end,
              maxLines: 2,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          if (withButton)
            Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 40,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(buttonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            side: BorderSide(
                                color: buttonColor,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: new BorderRadius.circular(30.0))),
                  ),
                  onPressed: () {},
                  child: Text(
                    Translations.of(context).text('show_detail'),
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: titleColor),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

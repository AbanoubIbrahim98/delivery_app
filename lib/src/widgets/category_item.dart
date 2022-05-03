import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/config/global_config.dart';

class CategoryItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int id;

  CategoryItem({this.imageUrl, this.name, this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/CategoryDetails", arguments: {"name": name, "id": id});
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: 0.3.sw,
        height: 150,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  offset: Offset(1, 1),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 1)
            ],
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).buttonColor),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "$GLOBAL_URL$imageUrl",
                fit: BoxFit.cover,
                height: 100,
                width: 0.3.sw,
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Image.asset(
                      "lib/assets/images/default.png",
                      fit: BoxFit.cover,
                      height: 100,
                      width: 0.3.sw,
                    );
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                "$name",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}

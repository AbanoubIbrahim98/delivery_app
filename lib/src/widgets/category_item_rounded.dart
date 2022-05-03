import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/config/global_config.dart';

class CategoryItemRounded extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int id;

  CategoryItemRounded({this.imageUrl, this.name, this.id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/CategoryDetails", arguments: {"name": name, "id": id});
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: 100,
        height: 130,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor.withOpacity(0.1))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  "$GLOBAL_URL$imageUrl",
                  fit: BoxFit.contain,
                  height: 100,
                  width: 100,
                  loadingBuilder: (BuildContext ctx, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Image.asset(
                        "lib/assets/images/default.png",
                        fit: BoxFit.contain,
                        height: 100,
                        width: 100,
                      );
                    }
                  },
                ),
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
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}

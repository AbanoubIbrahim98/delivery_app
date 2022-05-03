import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:instamarket/src/models/Extras.dart';

class ProductExtrasItem extends StatefulWidget {
  final List children;
  final String title;
  final int id;
  final Function(Extras) onSelected;
  final Extras extras;

  ProductExtrasItem(
      {this.children, this.title, this.id, this.onSelected, this.extras});

  @override
  ProductExtrasItemState createState() => ProductExtrasItemState();
}

class ProductExtrasItemState extends State<ProductExtrasItem> {
  int checkedId = 0;

  @override
  void initState() {
    super.initState();

    if (widget.extras != null)
      setState(() {
        checkedId = widget.extras.id;
      });
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
    return Container(
      width: 1.sw,
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  width: 1,
                  color: Theme.of(context).primaryColor.withOpacity(0.1)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 1.sw,
            child: Text(
              widget.title,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w800),
            ),
          ),
          Column(
            children: widget.children.map((child) {
              Color backgroundColor =
                  Color(getColorFromHex(child['background_color']));

              return Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1,
                        color: checkedId == child["id"]
                            ? Color.fromRGBO(33, 160, 54, 1)
                            : Theme.of(context).primaryColor.withOpacity(0.1))),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      checkedId = child["id"];
                    });

                    widget.onSelected(Extras(
                        idGroup: widget.id,
                        id: child["id"],
                        title: child["title"],
                        imageUrl: child['image_url'],
                        backgroundColor: child['background_color'],
                        price: child["price"].toString()));
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      if (child['image_url'] != null &&
                          child['image_url'].length > 3)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              "$GLOBAL_URL${child['image_url']}",
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                              loadingBuilder: (BuildContext ctx, Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Image.asset(
                                    "lib/assets/images/default.png",
                                    fit: BoxFit.cover,
                                    height: 30,
                                    width: 30,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      Text(
                        "${child["price"]} \$",
                        style: TextStyle(
                            color: checkedId == child["id"]
                                ? Color.fromRGBO(33, 160, 54, 1)
                                : Theme.of(context).primaryColor,
                            fontSize: 14.sp),
                      )
                    ],
                  ),
                  selectedTileColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                  title: Text(
                    child["title"],
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 14.sp),
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

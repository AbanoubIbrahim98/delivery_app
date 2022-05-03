import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/widgets/rounded_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instamarket/src/requests/save_comment.dart';
import 'package:instamarket/translations.dart';

class ProductCommentPanel extends StatefulWidget {
  final int productId;
  final int userId;
  final List comments;

  ProductCommentPanel({this.productId, this.userId, this.comments});

  @override
  ProductCommentPanelState createState() => ProductCommentPanelState();
}

class ProductCommentPanelState extends State<ProductCommentPanel> {
  double star = 5;
  String comment = "";
  List comments = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      comments = widget.comments;
    });
  }

  Widget commentDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Theme.of(context).buttonColor,
      child: Container(
        width: 0.8.sw,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Translations.of(context).text('enter_comment'),
                  style: TextStyle(
                      fontSize: 16.sp, color: Theme.of(context).primaryColor),
                ),
                IconButton(
                    icon: Icon(LineIcons.times,
                        size: 20.sp, color: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    })
              ],
            ),
            Divider(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
            RatingBar.builder(
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  star = rating;
                });
              },
            ),
            Container(
              width: 0.8.sw,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).primaryColor.withOpacity(0.1))),
              child: TextField(
                maxLines: 8,
                style: TextStyle(color: Theme.of(context).primaryColor),
                onChanged: (text) {
                  setState(() {
                    comment = text;
                  });
                },
                decoration: InputDecoration.collapsed(
                    hintText:
                        Translations.of(context).text('enter_your_text_here'),
                    hintStyle: TextStyle(
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.1))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                    width: 0.3.sw,
                    child: RoundedButton(
                      title: Translations.of(context).text('save'),
                      color: Color.fromRGBO(33, 160, 54, 1),
                      onClick: () async {
                        Navigator.of(context, rootNavigator: true).pop();
                        Map<String, dynamic> data = await saveCommentRequest(
                            widget.productId, widget.userId, star, comment);

                        if (mounted)
                          setState(() {
                            comments = data['data']['comments'];
                          });
                      },
                      isFilled: true,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: comments.map((item) {
              DateFormat format = new DateFormat('yyyy.MM.dd hh:mm');
              var parsedDate = DateTime.parse(item['created_at']);
              String date = format.format(parsedDate);

              return Container(
                width: 0.8.sw,
                margin: EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${item['user']['name']} ${item['user']['surname']}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        "$date",
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                            fontSize: 10.sp),
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: double.parse(item['star'].toString()),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(vertical: 4),
                      itemSize: 20,
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {},
                    ),
                    Text(
                      "${item['comment_text']}",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp),
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
          if (widget.userId != null && widget.userId > 0)
            CustomButton(
              title: Translations.of(context).text('post_comment'),
              onClick: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => commentDialog());
              },
            )
        ],
      ),
    );
  }
}

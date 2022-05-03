import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/translations.dart';

class UserLocationSearch extends StatefulWidget {
  final Function(String) onComplete;

  UserLocationSearch({this.onComplete});

  @override
  UserLocationSearchState createState() => UserLocationSearchState();
}

class UserLocationSearchState extends State<UserLocationSearch> {
  TextEditingController _controller = TextEditingController();
  String searchText = "";
  List<AutocompletePrediction> predictions = [];
  GooglePlace googlePlace =
      GooglePlace("AIzaSyAIZAHqq0Gpw0yNcq6LgsQd9EAGpee5sMg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Theme.of(context).buttonColor,
          ),
          automaticallyImplyLeading: false,
          title: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Container(
                width: 1.sw,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 0.7.sw,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2)),
                      child: TextField(
                        onChanged: (text) async {
                          if (text.isNotEmpty) {
                            var result =
                                await googlePlace.queryAutocomplete.get(text);
                            if (result != null &&
                                result.predictions != null &&
                                mounted) {
                              setState(() {
                                predictions = result.predictions;
                              });
                            }
                          } else {
                            if (predictions.length > 0 && mounted) {
                              setState(() {
                                predictions = [];
                              });
                            }
                          }
                          if (mounted)
                            setState(() {
                              searchText = text;
                            });
                        },
                        controller: _controller,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        decoration: InputDecoration(
                          hintText:
                              Translations.of(context).text('type_something'),
                          icon: Icon(
                            LineIcons.search,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              if (searchText.length > 0) _controller.clear();
                            },
                            icon: Icon(Icons.clear_rounded),
                            color: searchText.length > 0
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            padding: EdgeInsets.all(0),
                          ),
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 0.2.sw,
                        alignment: Alignment.center,
                        child: Text(
                          Translations.of(context).text('cancel'),
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Color.fromRGBO(33, 160, 54, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                  ],
                ),
              )),
          elevation: 0,
          backgroundColor: Theme.of(context).buttonColor),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).buttonColor,
                    child: Icon(Icons.pin_drop,
                        color: Theme.of(context).primaryColor),
                  ),
                  title: Text(
                    predictions[index].description,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  onTap: () {
                    setState(() {
                      searchText = predictions[index].description;
                    });
                    _controller.text = predictions[index].description;
                    _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: _controller.text.length));
                  },
                );
              },
            ),
          ),
          CustomButton(
            title: Translations.of(context).text('get_address'),
            onClick: () async {
              widget.onComplete(searchText);
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

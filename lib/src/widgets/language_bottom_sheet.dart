import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/models/Language.dart';
import 'package:instamarket/translations.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AppLanguage.dart';

class LanguageBottomSheet extends StatelessWidget {
  final List<Language> languages;

  LanguageBottomSheet({this.languages});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(1, 1),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 3)
          ],
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 4,
            width: 80,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Theme.of(context).primaryColor.withOpacity(0.1)),
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                Translations.of(context).text('select_language'),
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800),
              )),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: languages.length,
              padding: EdgeInsets.only(bottom: 40),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 40,
                    child: CheckboxListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      title: Text(
                        languages[index].name,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12.sp),
                      ),
                      value: Provider.of<AppLanguage>(context).languageCode ==
                          languages[index].shortName,
                      checkColor: Theme.of(context).buttonColor,
                      activeColor: Color.fromRGBO(232, 14, 73, 1),
                      onChanged: (newValue) {
                        context
                            .read<AppLanguage>()
                            .changeLanguage(Locale(languages[index].shortName));
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ));
              })
        ],
      ),
    );
  }
}

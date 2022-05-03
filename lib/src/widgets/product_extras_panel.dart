import 'package:flutter/material.dart';
import 'package:instamarket/src/widgets/product_extras_item.dart';
import 'package:instamarket/src/models/Extras.dart';

class ProductExtrasPanel extends StatelessWidget {
  final List extras;
  final Function(Extras) onSelected;
  final List<Extras> extraData;

  ProductExtrasPanel({this.extras, this.onSelected, this.extraData});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: extras.map((item) {
          List children = item["children"];
          int index =
              extraData.indexWhere((element) => element.idGroup == item['id']);
          return ProductExtrasItem(
              children: children,
              title: item['name'],
              id: item['id'],
              extras: index > -1 ? extraData[index] : null,
              onSelected: onSelected);
        }).toList(),
      ),
    );
  }
}

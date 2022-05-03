import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/models/Address.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/widgets/address_panel.dart';
import 'package:instamarket/translations.dart';

class UserLocationList extends StatefulWidget {
  final Function onGoBack;

  UserLocationList({this.onGoBack});

  @override
  UserLocationListState createState() => UserLocationListState();
}

class UserLocationListState extends State<UserLocationList> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  bool update = false;
  List<int> listForDelete = [];

  @override
  Widget build(BuildContext context) {
    List<Address> addresses = context.watch<AddressNotifier>().addresses;

    return WillPopScope(
        onWillPop: () {
          widget.onGoBack();
          Navigator.of(context).pop();
          return;
        },
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                Translations.of(context).text('addresses_list'),
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.sp),
              ),
              leading: BackButton(
                onPressed: () {
                  widget.onGoBack();
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                if (listForDelete.length > 0)
                  IconButton(
                    onPressed: () {
                      // context
                      //     .read<AddressNotifier>()
                      //     .deleteAddressByIndex(listForDelete);
                      setState(() {
                        update = !update;
                        listForDelete = [];
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Color.fromRGBO(232, 14, 73, 1),
                    ),
                  )
              ],
              backgroundColor: Theme.of(context).buttonColor),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 0.05.sw,
                  ),
                  child: Text(
                    Translations.of(context).text('deliver_to'),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: addresses.map((item) {
                      return InkWell(
                        onTap: () {
                          context
                              .read<AddressNotifier>()
                              .makeDefaultAddress(item);
                          setState(() {
                            update = !update;
                          });
                        },
                        child: AddressPanel(
                            address: item.address,
                            isChecked: item.isDefault,
                            onDelete: () {
                              setState(() {
                                update = !update;
                              });
                            }),
                      );
                    }).toList())
              ],
            ),
          ),
          bottomNavigationBar: Container(
            width: 0.8.sw,
            padding: EdgeInsets.only(bottom: 20, left: 0.1.sw, right: 0.1.sw),
            child: CustomButton(
                title: Translations.of(context).text('add_new_address'),
                onClick: () async {
                  Address defaultAddress =
                      context.read<AddressNotifier>().getDefaultAddress();
                  print(defaultAddress.address);
                  Navigator.of(context).pushNamed('/UserLocation', arguments: {
                    "address": defaultAddress.address,
                    "latitude": defaultAddress.latitude,
                    "longitude": defaultAddress.longitude,
                    "update": () {
                      setState(() {
                        update = !update;
                      });
                    }
                  });
                }),
          ),
        ));
  }
}

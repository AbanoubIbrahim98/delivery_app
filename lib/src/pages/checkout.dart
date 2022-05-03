import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/checkout_header_step.dart';
import 'package:instamarket/src/widgets/checkout_header_step_line.dart';
import 'package:instamarket/src/widgets/custom_button.dart';
import 'package:instamarket/src/widgets/labelled_text_field.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Product.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/src/widgets/cart_bottom_sheet.dart';
import 'package:instamarket/src/widgets/checkout_product_item.dart';
import 'package:instamarket/src/models/Address.dart';
import 'package:instamarket/src/notifier/AddressNotifier.dart';
import 'package:instamarket/src/widgets/checkout_panel_header.dart';
import 'package:instamarket/src/widgets/payments_panel.dart';
import 'package:instamarket/src/widgets/checkout_delivery_type.dart';
import 'package:instamarket/src/widgets/checkout_delivery_date.dart';
import 'package:instamarket/src/requests/save_order.dart';
import 'package:instamarket/translations.dart';

class Checkout extends StatefulWidget {
  @override
  CheckoutState createState() => CheckoutState();
}

class CheckoutState extends State<Checkout> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  int step = 0;
  int paymentMethod = 0;
  int paymentType = 0;
  int paymentStatus = 0;
  bool isPayed = false;
  int deliveryType = 0;
  String fio = "";
  String phone = "";
  String address = "";
  String comment = "";
  bool openPaymentPanel = false;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
      String text, Color color) {
    return ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      backgroundColor: color,
      content: Text(
        text,
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    List<Product> cartProduct = shop.cartProducts;
    Address defaultAddress =
        context.read<AddressNotifier>().getDefaultAddress();
    User user = context.watch<AuthNotifier>().user;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).buttonColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            if (step == 0)
              Navigator.of(context).pop();
            else if (step > 0)
              setState(() {
                step = step - 1;
              });
          },
        ),
        title: Text(
          Translations.of(context).text('checkout'),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            height: 60,
            width: 1.sw,
            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
            ),
            child: Stack(
              children: <Widget>[
                Row(
                  children: [
                    CheckoutHeaderStepLine(
                      status: step >= 1 ? 1 : 0,
                    ),
                    CheckoutHeaderStepLine(
                      status: step == 2 ? 1 : 0,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CheckOutStep(
                      title: Translations.of(context).text('shipping'),
                      position: 1,
                      status: step >= 0 ? 1 : 0,
                    ),
                    CheckOutStep(
                      title: Translations.of(context).text('payment'),
                      position: 2,
                      status: step >= 1 ? 1 : 0,
                    ),
                    CheckOutStep(
                      title: Translations.of(context).text('confirmation'),
                      position: 3,
                      status: step == 2 ? 1 : 0,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: Offset(1, 1),
                  )
                ],
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(10)),
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CheckoutDeliveryType(
                    deliveryType: deliveryType,
                    onChange: (type) {
                      setState(() {
                        deliveryType = type;
                      });
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CheckoutPanelHeader(
                      title: Translations.of(context).text('default_address'),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/UserLocationList',
                            arguments: {"onGoBack": () {}});
                      },
                      child: Text(
                        Translations.of(context).text('edit'),
                        style: TextStyle(
                            color: Color.fromRGBO(33, 160, 54, 1),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
                Container(
                  width: 1.sw - 60,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    defaultAddress.address,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Divider(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
                CheckoutPanelHeader(
                  title: Translations.of(context).text('shipping_info'),
                ),
                Divider(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                ),
                LabelledTextField(
                  title: Translations.of(context).text('full_name'),
                  onChange: (text) {
                    setState(() {
                      fio = text;
                    });
                  },
                  value: "${user.name} ${user.surname}",
                ),
                LabelledTextField(
                  title: Translations.of(context).text('phone'),
                  onChange: (text) {
                    setState(() {
                      phone = text;
                    });
                  },
                  value: "${user.phone}",
                ),
                LabelledTextField(
                  title: Translations.of(context).text('address'),
                  onChange: (text) {
                    setState(() {
                      address = text;
                    });
                  },
                  value: "${defaultAddress.address}",
                  last: true,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: Offset(1, 1),
                  )
                ],
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(10)),
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                PaymentPanel(
                    paymentMethod: paymentMethod,
                    paymentType: paymentType,
                    onChangePaymentMethod: (method) {
                      setState(() {
                        paymentMethod = method;
                      });
                    },
                    onChangePaymentType: (type) {
                      setState(() {
                        paymentType = type;
                      });
                    },
                    onPaymentComplete: () {
                      this.setState(() {
                        paymentStatus = 1;
                      });
                    }),
                if (paymentType == 1 && openPaymentPanel)
                  Column(
                    children: <Widget>[
                      CheckoutPanelHeader(
                        title: Translations.of(context).text('payment_info'),
                      ),
                      Divider(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                      LabelledTextField(
                        title:
                            Translations.of(context).text('card_holder_name'),
                        onChange: (text) {},
                        value: "Mark Twen",
                      ),
                      LabelledTextField(
                        title: Translations.of(context).text('card_number'),
                        onChange: (text) {},
                        value: "8600 8600 8600 8600",
                      ),
                      LabelledTextField(
                        title: Translations.of(context).text('expiration_date'),
                        onChange: (text) {},
                        value: "01/24",
                      ),
                      LabelledTextField(
                        title: Translations.of(context).text('ccv'),
                        onChange: (text) {},
                        value: "123",
                        last: true,
                      )
                    ],
                  )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 3,
                      offset: Offset(1, 1),
                    )
                  ],
                  color: Theme.of(context).buttonColor,
                  borderRadius: BorderRadius.circular(10)),
              width: 1.sw,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CheckoutDeliveryDate(),
                    CheckoutPanelHeader(
                      title: Translations.of(context).text('comment'),
                    ),
                    Container(
                      width: 0.9.sw,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1))),
                      child: TextField(
                        maxLines: 8,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        onChanged: (text) {
                          setState(() {
                            comment = text;
                          });
                        },
                        decoration: InputDecoration.collapsed(
                            hintText: Translations.of(context)
                                .text('enter_notes_for_order'),
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1))),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                    CheckoutPanelHeader(
                      title: Translations.of(context).text('your_order'),
                    ),
                    Column(
                        children: cartProduct.map((item) {
                      double priceWithExtra = double.parse(item.price);
                      double discountWithExtra = double.parse(item.discount);

                      if (item.extras != null)
                        for (int i = 0; i < item.extras.length; i++) {
                          priceWithExtra += double.parse(item.extras[i].price);
                          if (discountWithExtra > 0)
                            discountWithExtra +=
                                double.parse(item.extras[i].price);
                        }

                      return CheckoutProductItem(
                        title: item.title,
                        description: item.description,
                        imageUrl: item.image,
                        price: priceWithExtra.toString(),
                        id: item.id,
                        count: item.count,
                        categoryId: item.categoryId,
                        discount: discountWithExtra.toString(),
                      );
                    }).toList()),
                    CartBottomSheet(
                        onCancel: () {}, onSubmit: () {}, isCheckOut: true),
                  ])),
        ][step],
      ),
      bottomNavigationBar: Container(
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 5),
        color: Theme.of(context).buttonColor,
        child: CustomButton(
          title: step == 2
              ? Translations.of(context).text('confirm_pay')
              : Translations.of(context).text('continue'),
          onClick: () async {
            Map<String, dynamic> totalData =
                context.read<ShopNotifier>().getCartTotalInfo(shop.id);

            setState(() {
              if (step == 0) {
                if (address.length == 0) address = defaultAddress.address;
                if (fio.length == 0) fio = "${user.name} ${user.surname}";
                if (phone != null && phone.length == 0) phone = user.phone;
              }
            });

            if (step < 2)
              setState(() {
                step = step + 1;
              });
            else {
              List<Product> cartProduct = shop.cartProducts;
              List<Map<String, dynamic>> detail = [];

              if (cartProduct != null)
                for (int i = 0; i < cartProduct.length; i++) {
                  detail.add({
                    "count": cartProduct[i].count,
                    "id": cartProduct[i].id,
                    "discount_price": cartProduct[i].discount,
                    "price": cartProduct[i].price,
                    "coupon_id": cartProduct[i].couponId ?? 0,
                    "coupon_amount": cartProduct[i].couponPrice ?? 0
                  });
                }

              if (shop.deliveryDate == null || shop.deliveryDate.length == 0) {
                snackBar(Translations.of(context).text('select_delivery_date'),
                    Color.fromRGBO(232, 14, 73, 1));
                return;
              }

              Map<String, dynamic> data = await saveOrderRequest(
                  user.id,
                  fio,
                  phone,
                  address,
                  defaultAddress.longitude,
                  defaultAddress.latitude,
                  shop.id,
                  shop.tax,
                  shop.deliveryPrice,
                  totalData["total"],
                  totalData["discount"],
                  shop.deliveryDate,
                  comment,
                  deliveryType,
                  detail,
                  paymentStatus,
                  paymentType + 1);

              if (data != null &&
                  data['data'] != null &&
                  data['data']["success"] == true) {
                snackBar(
                    Translations.of(context).text('order_successfully_saved'),
                    Color.fromRGBO(33, 160, 54, 1));
                context.read<ShopNotifier>().clearCart(shop.id);
                Navigator.of(context).pop();
                return;
              } else {
                snackBar(Translations.of(context).text('order_not_saved'),
                    Color.fromRGBO(232, 14, 73, 1));
                return;
              }
            }
          },
        ),
      ),
    );
  }
}

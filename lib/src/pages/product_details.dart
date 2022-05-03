import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/config/global_config.dart';
import 'package:instamarket/src/widgets/rounded_button.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/src/requests/product_detail.dart';
import 'package:instamarket/src/widgets/product_detail_item.dart';
import 'package:instamarket/src/widgets/product_comment_panel.dart';
import 'package:instamarket/src/widgets/cart_button.dart';
import 'package:instamarket/src/notifier/ShopNotifier.dart';
import 'package:instamarket/src/models/Shop.dart';
import 'package:instamarket/src/models/Product.dart';
import 'package:provider/provider.dart';
import 'package:instamarket/src/widgets/product_extras_panel.dart';
import 'package:instamarket/src/notifier/AuthNotifier.dart';
import 'package:instamarket/src/models/User.dart';
import 'package:instamarket/src/models/Extras.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:instamarket/src/widgets/coupon_widget.dart';
import 'package:instamarket/translations.dart';

class ProductDetails extends StatefulWidget {
  final String title;
  final String description;
  final String price;
  final String discount;
  final String imageUrl;
  final int id;
  final int categoryId;
  final int count;
  final bool isLiked;
  final bool hasCoupon;
  final Function onChange;
  final List<Extras> extrasData;

  ProductDetails(
      {@required this.title,
      @required this.description,
      @required this.price,
      @required this.discount,
      @required this.imageUrl,
      @required this.id,
      @required this.categoryId,
      @required this.count,
      @required this.extrasData,
      this.isLiked,
      this.hasCoupon = false,
      this.onChange});
  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  TabController tabController;
  int tabIndex = 0;
  String title;
  String imageUrl;
  String price;
  String weight;
  int packQuantity;
  int quantity;
  String discount;
  String description;
  String unit;
  int count = 0;
  int id;
  int categoryId;
  bool isLiked = false;
  List extras = [];
  List comments = [];
  double averageStar = 0;
  List<Extras> selectedExtras = [];
  bool loading = false;
  List images = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      title = widget.title;
      imageUrl = widget.imageUrl;
      description = widget.description;
      id = widget.id;
      categoryId = widget.categoryId;
      count = widget.count;
      isLiked = widget.isLiked;
      selectedExtras = widget.extrasData;
    });

    this.calculatePrice();
    this.getMoreDetails();

    tabController = new TabController(length: 2, vsync: this);
    tabController.addListener(handleTabSelection);
  }

  handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {
        tabIndex = tabController.index;
      });
    }
  }

  void getMoreDetails() async {
    Map<String, dynamic> productDetails = await productDetailRequest(widget.id);

    if (productDetails.length > 0) {
      Map<String, dynamic> data = productDetails['data'];
      List extrasData = productDetails['extras'];
      List commentsData = productDetails['comments'];
      List edata = [];

      print(data['images']);

      if (mounted)
        setState(() {
          images = data['images'];
          if (commentsData != null && commentsData.length > 0)
            averageStar =
                commentsData.fold(0, (acc, cur) => acc + cur['star']) /
                    commentsData.length;
        });

      for (int i = 0; i < extrasData.length; i++) {
        int index = edata.indexWhere(
            (element) => element["id"] == extrasData[i]["extraGroup"]["id"]);
        if (index == -1) {
          edata.add({
            "id": extrasData[i]["extraGroup"]["id"],
            "name": extrasData[i]["extraGroup"]["lang"][0]["name"],
            "children": [
              {
                "id": extrasData[i]["id"],
                "price": extrasData[i]["price"],
                "image_url": extrasData[i]["image_url"],
                "background_color": extrasData[i]["background_color"],
                "title": extrasData[i]["lang"][0]["name"],
              }
            ]
          });
        } else {
          edata[index]["children"].add({
            "id": extrasData[i]["id"],
            "price": extrasData[i]["price"],
            "image_url": extrasData[i]["image_url"],
            "background_color": extrasData[i]["background_color"],
            "title": extrasData[i]["lang"][0]["name"],
          });
        }
      }

      if (mounted)
        setState(() {
          weight = data['weight'].toString();
          unit = data['unit'] != null ? data['unit']['lang'][0]['name'] : "";
          packQuantity = data['pack_quantity'];
          quantity = data['quantity'];
          extras = edata;
          comments = commentsData;
        });
    }
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
      text, bool isSuccess) {
    return ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      backgroundColor: isSuccess
          ? Color.fromRGBO(33, 160, 54, 1)
          : Color.fromRGBO(232, 14, 73, 1),
      content: Text(
        text,
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 12.sp, color: Theme.of(context).primaryColor),
      ),
    ));
  }

  void addToLiked() {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    context.read<ShopNotifier>().addToLiked(
        shop.id,
        Product(
            id: id,
            image: imageUrl,
            title: title,
            description: description,
            categoryId: categoryId,
            count: count,
            price: price,
            discount: discount,
            hasCoupon: widget.hasCoupon));
  }

  void addToCart() {
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    if (count <= quantity)
      context.read<ShopNotifier>().addToCart(
          shop.id,
          Product(
              id: widget.id,
              image: widget.imageUrl,
              title: widget.title,
              description: widget.description,
              categoryId: widget.categoryId,
              count: count,
              price: widget.price,
              discount: widget.discount,
              extras: selectedExtras,
              hasCoupon: widget.hasCoupon));
    else
      snackBar(
          Translations.of(context).text('reached_limit_of_product'), false);
  }

  void calculatePrice() {
    double priceWithExtra = double.parse(widget.price);
    double discountWithExtra = double.parse(widget.discount);

    for (int i = 0; i < selectedExtras.length; i++) {
      priceWithExtra += double.parse(selectedExtras[i].price);
      if (discountWithExtra > 0)
        discountWithExtra += double.parse(selectedExtras[i].price);
    }

    setState(() {
      price = priceWithExtra.toString();
      discount = discountWithExtra.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = context.watch<AuthNotifier>().user;
    double star = (averageStar * 10).round() / 10;
    Shop shop = context.read<ShopNotifier>().getActiveShop();
    List<Product> cartProduct = shop.cartProducts ?? [];

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).buttonColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).buttonColor,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        elevation: 0,
        title: Text(
          Translations.of(context).text('details'),
          style:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.sp),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/Search');
            },
            icon: Icon(
              LineIcons.search,
              size: 24.sp,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                isLiked = !isLiked;
              });
              addToLiked();
              widget.onChange();
            },
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                width: 40,
                height: 40,
                child: Icon(Icons.favorite,
                    size: 24.sp,
                    color: Color.fromRGBO(232, 14, 73, 1)
                        .withOpacity(isLiked ? 1 : 0.3))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: imageUrl,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0.1.sw, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    "$GLOBAL_URL$imageUrl",
                    fit: BoxFit.contain,
                    width: 0.8.sw,
                    height: 300,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Image.asset(
                          "lib/assets/images/default.png",
                          fit: BoxFit.contain,
                          width: 0.8.sw,
                          height: 300,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Container(
              height: 80,
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: ListView.builder(
                  itemCount: images.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          imageUrl = images[index]['image_url'];
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "$GLOBAL_URL${images[index]['image_url']}",
                          fit: BoxFit.contain,
                          width: 80,
                          height: 80,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Image.asset(
                                "lib/assets/images/default.png",
                                fit: BoxFit.contain,
                                width: 80,
                                height: 80,
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 1.sw - 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        RatingBar.builder(
                          initialRating: double.parse(
                              comments != null ? "$averageStar" : "0"),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          itemCount: 5,
                          unratedColor:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          itemPadding: EdgeInsets.symmetric(vertical: 4),
                          itemSize: 20,
                          itemBuilder: (context, _) =>
                              Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {},
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            comments != null
                                ? "$star ${Translations.of(context).text('out_of_5')}"
                                : "0",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.8),
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            double.parse(discount) > 0
                                ? "$discount \$"
                                : "$price \$",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          if (double.parse(discount) > 0 &&
                              (double.parse(price) - double.parse(discount)) >
                                  0)
                            Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(232, 14, 73, 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "${(double.parse(price) - double.parse(discount)).toStringAsFixed(2)} ${Translations.of(context).text('off')}",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Theme.of(context).buttonColor),
                              ),
                            ),
                        ],
                      ),
                      if (double.parse(discount) > 0)
                        Text(
                          "$price \$",
                          style: TextStyle(
                              color: Color.fromRGBO(232, 14, 73, 1),
                              decoration: TextDecoration.lineThrough,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400),
                        ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      if (weight != null)
                        ProductDetailItem(
                          title: Translations.of(context).text('weight'),
                          data: "$weight $unit",
                        ),
                      if (packQuantity != null)
                        ProductDetailItem(
                          title: Translations.of(context).text('package_count'),
                          data: packQuantity.toString(),
                        ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      ProductDetailItem(
                        title: Translations.of(context).text('comments'),
                        data: comments != null ? "${comments.length}" : "0",
                      )
                    ],
                  ),
                  if (widget.hasCoupon != null && widget.hasCoupon)
                    CouponWidget(
                      onApply: (bool couponApplied) {
                        setState(() {
                          loading = !loading;
                        });

                        if (couponApplied) {
                          snackBar(
                              Translations.of(context).text('coupon_applied'),
                              true);
                        } else {
                          snackBar(
                              Translations.of(context)
                                  .text('coupon_not_applied'),
                              false);
                        }
                      },
                      productId: id,
                      price: double.parse(discount) > 0
                          ? double.parse(discount)
                          : double.parse(price),
                    ),
                  ProductExtrasPanel(
                      extras: extras,
                      extraData: selectedExtras,
                      onSelected: (Extras extrasData) {
                        int index = selectedExtras.indexWhere(
                            (element) => element.idGroup == extrasData.idGroup);
                        setState(() {
                          if (index == -1) {
                            selectedExtras.add(extrasData);
                          } else {
                            selectedExtras[index] = extrasData;
                          }
                        });
                        calculatePrice();
                        addToCart();
                      })
                ],
              ),
            ),
            Container(
              width: 1.sw - 40,
              height: 50,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: Theme.of(context).primaryColor.withOpacity(0.1)),
                    top: BorderSide(
                        width: 1,
                        color:
                            Theme.of(context).primaryColor.withOpacity(0.1))),
                color: Theme.of(context).buttonColor,
              ),
              child: TabBar(
                controller: tabController,
                labelStyle:
                    TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor:
                    Theme.of(context).primaryColor.withOpacity(0.3),
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(
                    child: Text(Translations.of(context).text('description')),
                  ),
                  Tab(
                    child: Text(Translations.of(context).text('reviews')),
                  )
                ],
              ),
            ),
            Container(
              width: 1.sw - 40,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: [
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
                ProductCommentPanel(
                  productId: id,
                  userId: user != null ? user.id : -1,
                  comments: comments,
                )
              ][tabIndex],
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 80,
        width: 1.sw,
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
              offset: Offset(1, 1),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 3,
              spreadRadius: 1)
        ], color: Theme.of(context).buttonColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (cartProduct.length > 0)
              RoundedButton(
                title: Translations.of(context).text('order_now'),
                color: Color.fromRGBO(33, 160, 54, 1),
                onClick: () {
                  if (user != null && user.id != null && user.id > 0)
                    Navigator.of(context).pushNamed('/Checkout');
                  else
                    snackBar(
                        Translations.of(context).text('to_complete_your_order'),
                        false);
                },
                isFilled: false,
              ),
            if (quantity != null && quantity > 0)
              count > 0
                  ? CartButton(
                      id: id,
                      title: title,
                      description: description,
                      imageUrl: imageUrl,
                      discount: discount,
                      price: price,
                      count: count,
                      categoryId: categoryId,
                      onChange: (pcount) {
                        setState(() {
                          count = pcount;
                        });

                        widget.onChange();
                      },
                    )
                  : RoundedButton(
                      title: Translations.of(context).text('add_to_cart'),
                      color: Color.fromRGBO(33, 160, 54, 1),
                      onClick: () {
                        setState(() {
                          count = 1;
                        });
                      },
                      isFilled: true,
                    ),
            if (quantity != null && quantity == 0)
              Text(
                Translations.of(context).text('out_of_stock'),
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                    color: Color.fromRGBO(232, 14, 73, 1)),
              )
          ],
        ),
      ),
    );
  }
}

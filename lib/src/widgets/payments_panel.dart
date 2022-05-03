import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instamarket/src/widgets/checkout_panel_header.dart';
import 'package:line_icons/line_icons.dart';
import 'package:instamarket/translations.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;

class PaymentPanel extends StatefulWidget {
  final int paymentType;
  final int paymentMethod;
  final Function(int) onChangePaymentType;
  final Function(int) onChangePaymentMethod;
  final Function onPaymentComplete;

  PaymentPanel(
      {this.paymentType,
      this.paymentMethod,
      this.onChangePaymentType,
      this.onChangePaymentMethod,
      this.onPaymentComplete});

  @override
  PaymentPanelState createState() => PaymentPanelState();
}

class PaymentPanelState extends State<PaymentPanel> {
  final String tokenizationKey = 'sandbox_8hxpnkht_kzdtzv2btm4p7s5j';
  final List paymentTypes = [
    {"name": "Google pay", "icon": LineIcons.googleWallet, "id": 3},
    {"name": "Paypal", "icon": LineIcons.paypal, "id": 1},
    {"name": "Apple pay", "icon": LineIcons.apple, "id": 2},
    {"name": "Stripe", "icon": LineIcons.stripe, "id": 4},
  ];
  int paymentType;
  int paymentMethod;
  bool googlePayEnabled = false;
  bool applePayEnabled = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      paymentMethod = widget.paymentMethod;
      paymentType = widget.paymentType;
    });

    initSquarePayment();
  }

  Future<void> initSquarePayment() async {
    var canUseGooglePay = false;
    if (Platform.isAndroid) {
      await InAppPayments.initializeGooglePay(
          'sandbox-sq0idb-rTcU3u5xsRfSqkhD16sbNQ',
          google_pay_constants.environmentTest);
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    }

    var canUseApplePay = false;
    if (Platform.isIOS) {
      await InAppPayments.initializeApplePay(
          'sandbox-sq0idb-rTcU3u5xsRfSqkhD16sbNQ');
      canUseApplePay = await InAppPayments.canUseApplePay;
    }
    setState(() {
      googlePayEnabled = canUseGooglePay;
      applePayEnabled = canUseApplePay;
    });
  }

  void onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
          price: '1.00',
          priceStatus: google_pay_constants.totalPriceStatusFinal,
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayCancel);
    } on InAppPaymentsException catch (ex) {
      throw ex;
    }
  }

  void onGooglePayNonceRequestSuccess(CardDetails result) async {
    try {
      widget.onPaymentComplete();
    } on Exception catch (ex) {
      throw ex;
    }
  }

  void onGooglePayCancel() {}

  void onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {}

  void onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: '1.00',
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          paymentType: ApplePayPaymentType.finalPayment,
          onApplePayNonceRequestSuccess: onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: onApplePayNonceRequestFailure,
          onApplePayComplete: onApplePayEntryComplete);
    } on Exception catch (ex) {
      throw ex;
    }
  }

  void onApplePayNonceRequestSuccess(CardDetails result) async {
    try {
      widget.onPaymentComplete();
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } on PlatformException catch (ex) {
      await InAppPayments.completeApplePayAuthorization(
          isSuccess: false, errorMessage: ex.message);
    }
  }

  void onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(
        isSuccess: false, errorMessage: errorInfo.message);
  }

  void onApplePayEntryComplete() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CheckoutPanelHeader(
          title: Translations.of(context).text('payment_type'),
        ),
        Divider(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  paymentType = 0;
                });
                widget.onChangePaymentType(0);
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    LineIcons.moneyBill,
                    color: paymentType == 0
                        ? Color.fromRGBO(33, 160, 54, 1)
                        : Theme.of(context).primaryColor,
                    size: 30.sp,
                  ),
                  Container(
                    child: Text(
                      Translations.of(context).text('cash_on_delivery'),
                      style: TextStyle(
                          color: paymentType == 0
                              ? Color.fromRGBO(33, 160, 54, 1)
                              : Theme.of(context).primaryColor,
                          fontSize: 12.sp),
                    ),
                  )
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  paymentType = 1;
                });
                widget.onChangePaymentType(1);
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    LineIcons.creditCard,
                    color: paymentType == 1
                        ? Color.fromRGBO(33, 160, 54, 1)
                        : Theme.of(context).primaryColor,
                    size: 30.sp,
                  ),
                  Container(
                    child: Text(
                      Translations.of(context).text('card'),
                      style: TextStyle(
                          color: paymentType == 1
                              ? Color.fromRGBO(33, 160, 54, 1)
                              : Theme.of(context).primaryColor,
                          fontSize: 12.sp),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
        if (paymentType == 1)
          Container(
            width: 1.sw,
            height: 80,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
                itemCount: paymentTypes.length,
                scrollDirection: Axis.horizontal,
                itemExtent: 80,
                itemBuilder: (BuildContext context, int index) {
                  if (paymentTypes[index]["id"] == 3 && !googlePayEnabled)
                    return null;

                  if (paymentTypes[index]["id"] == 2 && !applePayEnabled)
                    return null;

                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    child: TextButton(
                      onPressed: () {
                        if (paymentTypes[index]["id"] == 3) onStartGooglePay();
                        if (paymentTypes[index]["id"] == 2) onStartApplePay();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.all(0)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.5),
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius:
                                        new BorderRadius.circular(10.0))),
                      ),
                      child: Icon(
                        paymentTypes[index]["icon"],
                        size: 30.sp,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    ),
                  );
                }),
          ),
        if (paymentType == 1)
          Divider(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
      ],
    );
  }
}

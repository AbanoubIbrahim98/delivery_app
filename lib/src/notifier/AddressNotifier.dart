import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instamarket/src/models/Address.dart';

class AddressNotifier with ChangeNotifier {
  List<Address> addresses = [];

  AddressNotifier() {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List addressesJson = prefs.getString('addresses') != null
        ? json.decode(prefs.getString('addresses'))
        : [];
    addresses = addressesJson.map((json) {
      return Address.fromJson(json);
    }).toList();
  }

  void setData(addresses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "addresses",
        json.encode(addresses.map((item) {
          return item.toJson();
        }).toList()));
  }

  void addAddress(String address, double latitude, double longitude) async {
    int index = addresses.indexWhere((element) =>
        element.latitude == latitude && element.longitude == longitude);
    if (index == -1) {
      int index = addresses.indexWhere((element) => element.isDefault == true);
      if (index > -1) addresses[index].isDefault = false;

      addresses.add(Address(
          address: address,
          latitude: latitude,
          longitude: longitude,
          isDefault: true));

      setData(addresses);

      notifyListeners();
    }
  }

  Address getDefaultAddress() {
    int index = addresses.indexWhere((element) => element.isDefault == true);

    if (addresses.length > 0)
      return index > 0 ? addresses[index] : addresses[0];
    else
      return Address();
  }

  void makeDefaultAddress(Address address) {
    int activeIndex =
        addresses.indexWhere((element) => element.isDefault == true);
    addresses[activeIndex].isDefault = false;

    int index = addresses.indexWhere((element) => element == address);
    addresses[index].isDefault = true;

    setData(addresses);

    notifyListeners();
  }

  void deleteAddressByIndex(int index) {
    addresses.removeAt(index);

    setData(addresses);

    notifyListeners();
  }
}

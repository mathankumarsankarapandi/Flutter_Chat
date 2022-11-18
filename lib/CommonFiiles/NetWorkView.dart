import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class NetWorkView {

  Future<bool> isInternetConnected(
      BuildContext context) async {
    try {
      bool isInternetConnected = false;

      ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());

      if (connectivityResult == ConnectivityResult.mobile) {
        return hitWeb(context);
      } else if (connectivityResult == ConnectivityResult.wifi) {
        return hitWeb(context);
      }
      return isInternetConnected;
    } catch (exception, stackTrace) {
      print("exception : $exception");
      print("stackTrace : $stackTrace");

      return false;
    }
  }

  Future<bool> hitWeb(BuildContext context) async {

    try {
      final internetAddressObject = await InternetAddress.lookup('google.com')
          .timeout(const Duration(milliseconds: 300000));
      if (internetAddressObject.isNotEmpty &&
          internetAddressObject[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (exception, stackTrace) {
      print("exception : $exception");
      print("stackTrace : $stackTrace");
      return false;
    }
    return false;
  }

}
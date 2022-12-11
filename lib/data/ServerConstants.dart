
import 'package:flutter/material.dart';

import '../persentation/wedgits/error_pop.dart';


class ServerConstants {
  static bool isValidResponse(int statusCode) {
    return statusCode >= 200 && statusCode <= 302;
  }

  static void showDialog1(BuildContext context, String s) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ErrorPopUp(message: '$s'),
    );
  }




  static const bool IS_DEBUG = true; // TODO: Close Debugging in Release.
  static const String API = "https://www.beta.toot.work/api";


  static const String login ='${API}/driver/auth/login';
  static const String availability ='${API}/driver/auth/availability';




  static const String logout ='${API}/driver/auth/logout';
  static const String unActive ='${API}/driver/auth/unActive';

  static const String statics ='${API}/driver/statics';
  static const String saveLocation ='${API}/driver/saveLocation';


  static const String lang ='${API}/driver/lang/change';

  static const String notification ='${API}/notification/all';
  static const String read ='${API}/notification/read';



  static const String changePassword = "${API}/driver/auth/changePassword";
  static const String details = "${API}/driver/order/details";


  static const String newOrders = "${API}/driver/orders/new";
  static const String openOrders = "${API}/driver/orders/open";
  static const String closedOrders = "${API}/driver/orders/closed";
  static const String acceptOrder = "${API}/driver/orders/accept";
  static const String rejectOrder = "${API}/driver/orders/refuse";
  static const String deliverOrder = "${API}/driver/orders/deliver";
  static const String failedOrder = "${API}/driver/orders/fail";






















}

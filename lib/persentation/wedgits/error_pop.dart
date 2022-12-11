
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../translations/locale_keys.g.dart';



class ErrorPopUp extends StatelessWidget {
  final String message;
  final bool isActivate ;
  final String? phone;

  ErrorPopUp({ required this.message,this.isActivate=false,this.phone});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text(
        LocaleKeys.sorry_translate.tr(),
        style: TextStyle(height: 2),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 2.0),
          Container(
            child: Center(
              child: Text(
                "$message",
                textAlign:  TextAlign.center,
                style: TextStyle(height: 2),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          InkWell(
            onTap: () {

  Navigator.of(context).pop();
  Navigator.of(context).pop();


            },

            child: Container(
              color: AppTheme.secondary,
              child: Center(
                child: Text(
                  isActivate? LocaleKeys.verify.tr() : LocaleKeys.ok_translate.tr(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}

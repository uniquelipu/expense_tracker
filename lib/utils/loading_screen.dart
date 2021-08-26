import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog {
  static BuildContext contextValue;

  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    contextValue = context;

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            key: key,
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  static Future<void> hideDialog() async {
    Navigator.of(contextValue, rootNavigator: true).pop();
  }
}
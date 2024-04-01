import 'package:flutter/material.dart';

alertDialogWidget(context, color, msg) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      width: MediaQuery.of(context).size.width / 2,
      behavior: SnackBarBehavior.floating,
      dismissDirection: DismissDirection.up,
      // margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: color,
      content: Center(
        child: Text(
          msg,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

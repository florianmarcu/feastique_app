import 'package:flutter/material.dart';

/// Build the new theme of the 
/// TextButton
/// Text
TextButtonThemeData textButtonTheme(BuildContext context) =>  TextButtonThemeData(
  style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(
      Theme.of(context).highlightColor
  ),
  backgroundColor: MaterialStateProperty.all<Color>(
     Theme.of(context).colorScheme.secondary
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
  ),
  padding: MaterialStateProperty.all<EdgeInsets>(
    EdgeInsets.symmetric(vertical: 15, horizontal: 30)
  ),
  textStyle: MaterialStateProperty.all<TextStyle>(
    TextStyle(
      fontSize: 30*(1/MediaQuery.of(context).textScaleFactor),
      fontWeight: FontWeight.bold,
      fontFamily: 'Raleway'
    )
  ),
  )
);
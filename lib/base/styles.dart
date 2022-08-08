import 'package:flutter/material.dart';

const Color primaryColor = Colors.orange;
const Color secondaryColor = Colors.white;
const Color additionalColor = Colors.amber;

ButtonStyle stylePrimaryButton(double wight, double height) =>
    TextButton.styleFrom(minimumSize: Size(wight, height), backgroundColor: primaryColor, primary: secondaryColor);

ButtonStyle styleSecondaryButton() => TextButton.styleFrom();

ButtonStyle styleAdditionalButton() => TextButton.styleFrom(primary: additionalColor);

import 'package:flutter/material.dart';

// Some functions and widgets that retun values that change on screen size for responsive design.

double responsiveHeaderSize(context) {  return MediaQuery.of(context).size.height.toDouble() * 0.04;}
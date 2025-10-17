import 'package:flutter/material.dart';

class PrivacyItemInfo {
  final String label;
  final Icon icon;
  final List<Color> colors;
  final String url;
  final String? showUrl;
  final String javaScriptDesign;
  final String javaScriptAction;
  final Widget? child;
  bool active;

  PrivacyItemInfo({
    required this.label,
    required this.icon,
    required this.url,
    this.javaScriptDesign = "",
    this.javaScriptAction = "",
    this.active = false,
    this.colors = const [Colors.grey, Colors.grey],
    this.showUrl,
    this.child,
  }) : assert(colors.length > 1);
}



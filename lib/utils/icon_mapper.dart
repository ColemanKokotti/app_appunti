import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIconData(String iconName) {
    switch (iconName) {
      case 'api':
        return Icons.api;
      case 'copyright':
        return Icons.copyright;
      default:
        return Icons.note;
    }
  }
}
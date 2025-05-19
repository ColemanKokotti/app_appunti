import 'package:flutter/material.dart';

class IconMapper {
  static Widget getIconWidget(String iconName, {double size = 24.0}) {
    switch (iconName) {
      case 'api':
        return Image.asset('assets/icons/api_icon.png', width: size, height: size);
      case 'copyright':
        return Image.asset('assets/icons/copyright_icon.png', width: size, height: size);
      case 'flutter':
        return Image.asset('assets/icons/flutter_icon.png', width: size, height: size);
      case 'react':
        return Image.asset('assets/icons/react_icon.png', width: size, height: size);
      case 'android':
        return Image.asset('assets/icons/android_icon.png', width: size, height: size);
      case 'ios':
        return Image.asset('assets/icons/ios_icon.png', width: size, height: size);
      case 'database':
        return Image.asset('assets/icons/database_icon.png', width: size, height: size);
      case 'web':
        return Image.asset('assets/icons/web_icon.png', width: size, height: size);
      case 'app_architecture':
        return Image.asset('assets/icons/app_architecture_icon.png', width: size, height: size);
      case 'programming_fundamentals':
        return Image.asset('assets/icons/programming_fundamentals_icon.png', width: size, height: size);
      case 'ux_ui':
        return Image.asset('assets/icons/ux_ui_icon.png', width: size, height: size);
      case 'linux':
        return Image.asset('assets/icons/linux_icon.png', width: size, height: size);
      case 'cybersecurity':
        return Image.asset('assets/icons/cybersecurity_icon.png', width: size, height: size);
      default:
        return Icon(Icons.note, size: size);
    }
  }
}
import 'package:evoke/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';
import 'menu_of_drawer.dart';

class ExpDrawer extends StatefulWidget {
  const ExpDrawer({super.key});

  @override
  State<ExpDrawer> createState() => _ExpDrawerState();
}

ThemeManager themeManager = ThemeManager();

class _ExpDrawerState extends State<ExpDrawer> {
  @override
  Widget build(BuildContext context) =>
      Consumer<ThemeManager>(builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: themeManager.themeMode != ThemeMode.dark
              ? Colors.white
              : Color(0xff19191E),
          body: ZoomDrawer(
              menuScreenTapClose: true,
              androidCloseOnBackTap: true,
              style: DrawerStyle.defaultStyle,
              angle: -1,
              slideWidth: MediaQuery.of(context).size.width * 0.75,
              mainScreenScale: 0.15,
              menuScreen: Menu(),
              mainScreen: ChatScreen()),
        );
      });
}

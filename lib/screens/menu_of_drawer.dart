import 'dart:async';

import 'package:evoke/constants/constants.dart';
import 'package:evoke/screens/image_maker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:evoke/theme/theme_manager.dart';

import '../providers/chats_provider.dart';
import 'all_notes.dart';
import 'chat_screen.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  ChatScreenState chatScreen = ChatScreenState();
  ThemeManager _themeManager = ThemeManager();

  bool _isImagePressed = false;
  bool _isNewChatPressed = false;
  bool _isSavedNotesPressed = false;
  void _onPressed() {
    setState(() {
      _isImagePressed = !_isImagePressed;
      _isNewChatPressed = !_isNewChatPressed;
      _isSavedNotesPressed = !_isSavedNotesPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Consumer<ThemeManager>(builder: (context, themeManager, child) {
      return Scaffold(
        backgroundColor: themeManager.themeMode != ThemeMode.dark
            ? Colors.white70
            : Color(0xff19191E),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 70,
                left: 35,
              ),
              child: GestureDetector(
                onTap: (() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePage(),
                    ),
                  );
                }),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    color: themeManager.themeMode != ThemeMode.dark
                        ? Colors.white
                        : Color(0xff19191E),
                    shape: NeumorphicShape.flat,
                    intensity: 0.3,
                    shadowDarkColor: Colors.black,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(12),
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'Generate Image',
                      style: themeManager.themeMode != ThemeMode.dark
                          ? darkText
                          : lightText,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 35,
              ),
              child: GestureDetector(
                onTap: (() {
                  setState(() {
                    chatScreen.messages.clear();
                    chatProvider.getChatList.clear();
                    chatScreen.initState();
                    ZoomDrawer.of(context)?.close();
                  });
                }),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    color: themeManager.themeMode != ThemeMode.dark
                        ? Colors.white
                        : Color(0xff19191E),
                    shape: NeumorphicShape.flat,
                    intensity: 0.3,
                    shadowDarkColor: Colors.black,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(12),
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'New Chat',
                      style: themeManager.themeMode != ThemeMode.dark
                          ? darkText
                          : lightText,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 35,
              ),
              child: GestureDetector(
                onTap: (() {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotesGrid(),
                      ),
                    );
                  });
                }),
                child: Neumorphic(
                  style: NeumorphicStyle(
                    color: themeManager.themeMode != ThemeMode.dark
                        ? Colors.white
                        : Color(0xff19191E),
                    shape: NeumorphicShape.flat,
                    intensity: 0.3,
                    shadowDarkColor: Colors.black,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(12),
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      'Saved Notes',
                      style: themeManager.themeMode != ThemeMode.dark
                          ? darkText
                          : lightText,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 35,
              ),
              child: GestureDetector(
                onTap: () {
                  // Get the current theme manager instance
                  final themeManager = context.read<ThemeManager>();
                  // Toggle the theme mode
                  themeManager
                      .toggleTheme(themeManager.themeMode == ThemeMode.light);
                },
                child: Neumorphic(
                  style: NeumorphicStyle(
                    color: themeManager.themeMode != ThemeMode.dark
                        ? Colors.white
                        : Color(0xff19191E),
                    shape: NeumorphicShape.flat,
                    intensity: 0.3,
                    shadowDarkColor: Colors.black,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(12),
                    ),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      themeManager.themeMode != ThemeMode.dark
                          ? 'Dark'
                          : 'Light',
                      style: themeManager.themeMode != ThemeMode.dark
                          ? darkText
                          : lightText,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}


///LISTVIEW IN THIS PAGE IS NOT UPDATING WITHOUT HOTRESTART 
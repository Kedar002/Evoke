import 'package:evoke/constants/constants.dart';
import 'package:evoke/theme/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import '../database/db_helper.dart';
import '../database/db_model.dart';
import 'notes_screen.dart';

class Settings extends StatefulWidget {
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();

  List<Note> filteredNotes = List<Note>.empty(growable: true);
  bool _searching = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  ThemeManager themeManager = ThemeManager();
  @override
  late List<Note> _notes;

  @override
  void initState() {
    super.initState();
    _notes = [];
    DatabaseHelper.instance.getAllNotes().then((value) {
      setState(() {
        _notes = value;
      });
    });
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Set up the scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, themeManager, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              UniconsLine.angle_left,
              color: themeManager.themeMode != ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              size: 30,
            ),
          ),
          title: Text(
            "EVOKE",
            style:
                themeManager.themeMode != ThemeMode.dark ? darkLogo : lightLogo,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [],
        ),
      );
    });
  }
}

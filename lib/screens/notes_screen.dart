import 'package:evoke/constants/constants.dart';
import 'package:evoke/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import '../database/db_model.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;

  NoteDetailPage({required this.note});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  ThemeManager themeManager = ThemeManager();
  @override
  void initState() {
    super.initState();

    // Set up the animation controller
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

    // Start the animation
    _controller.forward();
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Center(
                child: Text(widget.note.title,
                    style: GoogleFonts.dmSans(
                        color: themeManager.themeMode != ThemeMode.dark
                            ? Colors.black
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
              ),
              SizedBox(height: 16.0),
              Text(
                widget.note.description,
                style: GoogleFonts.dmSans(
                    color: themeManager.themeMode != ThemeMode.dark
                        ? Colors.black
                        : Colors.white,
                    fontSize: 18),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'created on ${widget.note.time.split('.').first}',
                style: GoogleFonts.dmSans(
                    color: themeManager.themeMode != ThemeMode.dark
                        ? Colors.grey[800]
                        : Colors.grey[400],
                    fontSize: 15),
              ),
            ],
          ),
        ),
      );
    });
  }
}

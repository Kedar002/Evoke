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

class NotesGrid extends StatefulWidget {
  @override
  State<NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends State<NotesGrid>
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
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    themeManager.themeMode != ThemeMode.dark
                        ? BoxShadow(
                            // offset: Offset(0, 0),
                            blurRadius: 15,
                            // spreadRadius: 2,
                            color: Colors.grey.shade500,
                          )
                        : BoxShadow()
                  ],
                  color: themeManager.themeMode != ThemeMode.dark
                      ? Colors.white
                      : Color(0xff19191E),
                  borderRadius: BorderRadius.circular(
                      12), // Rounded corners for the chat input area
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 1), // Left margin for the avatar icon
                    IconButton(
                      onPressed: () {
                        // TODO: Trigger voice message recording
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/Search.svg',
                        color: themeManager.themeMode != ThemeMode.dark
                            ? darkScaffoldBackgroundColor
                            : lightScaffoldBackgroundColor,
                        width: 21,
                        height: 21,
                      ),
                    ),
                    const SizedBox(
                        width: 15), // Spacing between avatar and text field
                    Expanded(
                      child: TextField(
                        key: const ValueKey('search_field'),
                        onChanged: (value) {
                          setState(() {
                            _searching = true;
                            filteredNotes = _notes
                                .where((note) =>
                                    note.title
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    note.description
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        maxLines: null,
                        style: const TextStyle(color: Colors.black),
                        controller: _searchController,
                        decoration: const InputDecoration.collapsed(
                          hintText: "Search",
                          hintStyle: TextStyle(
                              color: Color(
                                  0xFFB1AEA5)), // WhatsApp hint text color
                        ),
                      ),
                    ),

                    const SizedBox(width: 15), // Right margin for the send icon
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            // childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount:
                        _searching ? filteredNotes.length : _notes.length,
                    itemBuilder: (BuildContext ctx, index) {
                      final note =
                          _searching ? filteredNotes[index] : _notes[index];
                      return InkWell(
                        onLongPress: () {
                          openDialogue(index);
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return NoteDetailPage(note: note);
                              },
                            ),
                          );
                        },
                        child: Neumorphic(
                          padding: EdgeInsets.all(8),
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(15),
                            ),
                            depth: themeManager.themeMode != ThemeMode.dark
                                ? 4
                                : 0,
                            lightSource: LightSource.topLeft,
                            color: themeManager.themeMode != ThemeMode.dark
                                ? Colors.white
                                : Color(0xff19191E),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                note.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                note.description,
                                style: TextStyle(fontSize: 16),
                                maxLines: 7,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future openDialogue(int index) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          title: Center(
            child: Text(
              'Are you sure you want to delete this note?',
              style: GoogleFonts.dmSans(color: Colors.black, fontSize: 20),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'No',
                style: GoogleFonts.dmSans(color: Colors.black, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteNoteAtIndex(index);
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
  void _deleteNoteAtIndex(int index) async {
    final note = _notes.removeAt(index);
    await DatabaseHelper.instance.delete(note.id!);

    setState(() {});
  }
}

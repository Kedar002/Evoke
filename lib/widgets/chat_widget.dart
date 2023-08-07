import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:evoke/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../providers/chats_provider.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final _controller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  late String _title;
  late String _description;

  @override
  void initState() {
    super.initState();
    _title = 'Note from Previous Page';
    _description = widget.msg;
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Column(
      children: [
        Material(
          color: widget.chatIndex == 0
              ? lightScaffoldBackgroundColor
              : lightCardColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: widget.chatIndex != 0
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                // Icon(
                //   chatIndex != 0 ? UniconsLine.atom : UniconsLine.user,
                //   color: Colors.black,
                //   // height: 30,
                //   // width: 30,
                // ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: widget.chatIndex == 0
                      ? UserText(
                          label: widget.msg,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                          ),
                          child: DefaultTextStyle(
                            style: GoogleFonts.dmSans(
                                color: Colors.black,
                                // fontWeight: FontWeight.w300,
                                fontSize: 16),
                            child: AnimatedTextKit(
                                isRepeatingAnimation: false,
                                repeatForever: false,
                                displayFullTextOnTap: true,
                                totalRepeatCount: 1,
                                animatedTexts: [
                                  TyperAnimatedText(
                                    utf8.decode(
                                        widget.msg.trim().runes.toList()),
                                  ),
                                ]),
                          ),
                        ),
                ),
                widget.chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: const [],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Future openDialogue(TextEditingController controller) => showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //         contentPadding: EdgeInsets.only(top: 10.0),
  //         title: Center(
  //           child: Text(
  //             'Give Title for your Note',
  //             style: GoogleFonts.dmSans(color: Colors.black, fontSize: 20),
  //           ),
  //         ),
  //         content: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Container(
  //             // width: 200,
  //             // height: 200,
  //             decoration: BoxDecoration(
  //               border:
  //                   Border.all(color: Colors.black, style: BorderStyle.solid),
  //               borderRadius: BorderRadius.circular(10),
  //             ),
  //             child: TextField(
  //               controller: controller,
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text(
  //               'close',
  //               style: GoogleFonts.dmSans(color: Colors.black, fontSize: 16),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Note note = Note(
  //                 title: (controller.text == null || controller.text == '')
  //                     ? 'Note'
  //                     : controller.text,
  //                 description: _description,
  //                 time: DateTime.now().toString(),
  //               );
  //               DatabaseHelper.instance.insert(note);
  //               Navigator.pop(context);
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(
  //                   duration: const Duration(milliseconds: 200),
  //                   content: Center(
  //                     child: Text(
  //                       "Saved succesfully",
  //                       style: GoogleFonts.dmSans(
  //                           color: Colors.black, fontSize: 30),
  //                     ),
  //                   ),
  //                   backgroundColor: Colors.green,
  //                 ),
  //               );
  //               // ZoomDrawer.of(context)?.open();
  //             },
  //             child: Text('Save'),
  //           ),
  //         ],
  //       ),
  //     );
  // speak(dynamic message) async {
  //   await flutterTts.setLanguage("en-US");
  //   await flutterTts.setPitch(1);
  //   await flutterTts.speak(message);
  // }
}

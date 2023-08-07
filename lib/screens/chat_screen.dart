import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:evoke/constants/constants.dart';
import 'package:evoke/database/db_model.dart';
import 'package:evoke/screens/settings.dart';
import 'package:evoke/theme/theme_manager.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';
import '../Utils/image_cropper_page.dart';
import '../Utils/image_picker_class.dart';
import '../database/db_helper.dart';
import '../providers/chats_provider.dart';
import '../providers/models_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/modal_dialog.dart';
import '../widgets/text_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<String> messages = [];
  Random random = Random();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  TextEditingController _textController = TextEditingController();
  TextEditingController _titleTextController = TextEditingController();
  bool isPlayed = false;
  final FlutterTts flutterTts = FlutterTts();

  Color _color = Colors.green;
  bool textSend = false;
  bool _isTyping = false;
  stt.SpeechToText? _speech;
  bool isSpeaking = false;
  bool _isListening = false;
  String _text = '';
  late ScrollController _scrollController;
  late FocusNode focusNode;
  late String _title;
  late String _description;
  ThemeManager themeManager = ThemeManager();

  @override
  void initState() {
    // refresh();
    _speech = stt.SpeechToText();
    _scrollController = ScrollController();
    _textController = TextEditingController();
    focusNode = FocusNode();
    _title = 'Note from Previous Page';

    focusNode.addListener(() {
      setState(() {
        textSend = focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    messages.clear();
    _textController.dispose();
    // chatProvider.getChatList.clear();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int _randomNumber1 = random.nextInt(71);

    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Consumer<ThemeManager>(builder: (context, themeManager, child) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () => ZoomDrawer.of(context)?.toggle(),
                  // chatProvider.getChatList.clear();
                  // setState(() {});

                  icon: ImageIcon(
                    const AssetImage("assets/icons/menu.png"),
                    color: themeManager.themeMode != ThemeMode.dark
                        ? darkCardColor
                        : lightCardColor,
                  ),
                )),
            centerTitle: true,
            title: GestureDetector(
              onTap: () {
                _textController.text = randomQuestions[_randomNumber1];
                setState(() {});
              },
              child: Text(
                "EVOKE",
                style: themeManager.themeMode != ThemeMode.dark
                    ? darkLogo
                    : lightLogo,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Settings(),
                      ),
                    );
                  });
                },
                icon: SvgPicture.asset(
                  'assets/icons/Setting.svg',
                  width: 28,
                  height: 28,
                  color: themeManager.themeMode != ThemeMode.dark
                      ? darkScaffoldBackgroundColor
                      : lightScaffoldBackgroundColor,
                ),
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: AnimatedList(
                  controller: _scrollController,
                  key: _listKey,
                  reverse: true,
                  initialItemCount: messages.length,
                  itemBuilder: (
                    context,
                    index,
                    animation,
                  ) {
                    return Container(
                        alignment
                            // :
                            // messages[index].contains('\u200B')
                            //     ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: _buildItem(
                            messages[index], animation, index, chatProvider));
                  },
                ),
              ),
              if (_isTyping) ...[
                SpinKitThreeBounce(
                  color: themeManager.themeMode != ThemeMode.dark
                      ? Colors.black
                      : Colors.white,
                  size: 18,
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
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
                    color: themeManager.themeMode == ThemeMode.dark
                        ? Colors.black
                        : lightCardColor, // WhatsApp background color
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for the chat input area
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                          width: 15), // Left margin for the avatar icon

                      const SizedBox(
                          width: 15), // Spacing between avatar and text field
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          focusNode: focusNode,
                          style: GoogleFonts.roboto(
                              color: themeManager.themeMode != ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white),
                          controller: _textController,
                          decoration: InputDecoration.collapsed(
                            hintText: "Write...",
                            hintStyle: GoogleFonts.roboto(
                                color: Color(
                                    0xFFB1AEA5)), // WhatsApp hint text color
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          imagePickerModal(context, onCameraTap: () {
                            pickImage(source: ImageSource.camera).then((value) {
                              if (value != '') {
                                imageCropperView(value, context).then((value) {
                                  if (value != '') {
                                    final InputImage inputImage =
                                        InputImage.fromFilePath(value);

                                    processImage(inputImage);
                                  }
                                });
                              }
                            });
                          }, onGalleryTap: () {
                            pickImage(source: ImageSource.gallery)
                                .then((value) {
                              if (value != '') {
                                imageCropperView(value, context).then((value) {
                                  if (value != '') {
                                    final InputImage inputImage =
                                        InputImage.fromFilePath(value);

                                    processImage(inputImage);
                                  }
                                });
                              }
                            });
                          });
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/Camera.svg',
                          color: themeManager.themeMode != ThemeMode.dark
                              ? darkScaffoldBackgroundColor
                              : lightScaffoldBackgroundColor,
                          width: 28,
                          height: 28,
                        ),
                      ),
                      const SizedBox(width: 10), //
                      textSend == true || _textController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () async {
                                await sendMessageFCT(
                                  modelsProvider: modelsProvider,
                                  chatProvider: chatProvider,
                                );
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/Send.svg',
                                width: 28,
                                height: 28,
                                color: themeManager.themeMode != ThemeMode.dark
                                    ? darkScaffoldBackgroundColor
                                    : lightScaffoldBackgroundColor,
                              ),
                            )
                          : IconButton(
                              onPressed: () async {
                                _listen(
                                  modelsProvider: modelsProvider,
                                  chatProvider: chatProvider,
                                );
                              },
                              icon: _isListening != true
                                  ? SvgPicture.asset(
                                      'assets/icons/Voice.svg',
                                      width: 28,
                                      height: 28,
                                      color: themeManager.themeMode !=
                                              ThemeMode.dark
                                          ? darkScaffoldBackgroundColor
                                          : lightScaffoldBackgroundColor,
                                    )
                                  : SvgPicture.asset(
                                      'assets/icons/Voice 2.svg',
                                      width: 28,
                                      height: 28,
                                      color: themeManager.themeMode !=
                                              ThemeMode.dark
                                          ? darkScaffoldBackgroundColor
                                          : lightScaffoldBackgroundColor,
                                    )),
                      const SizedBox(
                          width: 15), // Right margin for the send icon
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _buildItem(String message, Animation<double> animation, int index,
      ChatProvider chatProvider) {
    return Consumer<ThemeManager>(builder: (context, themeManager, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic, // Set a slower animation curve
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: messages[index].contains('\u200B')
              ? Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFF85809F), Color(0xFF3D3B47)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      message,
                      style: lightText,
                    ),
                  ),
                )
              : Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          message,
                          style: themeManager.themeMode != ThemeMode.dark
                              ? darkText
                              : lightText,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              if (_title != null) {
                                _description = message;
                                openDialogue(_titleTextController);
                              } else {
                                print('luffy');
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/Plus.svg',
                              width: 24,
                              height: 24,
                              color: themeManager.themeMode != ThemeMode.dark
                                  ? darkScaffoldBackgroundColor
                                  : lightScaffoldBackgroundColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              toggleSpeak(message);
                              setState(() {});
                            },
                            icon: isSpeaking
                                ? SvgPicture.asset(
                                    'assets/icons/Pause.svg',
                                    width: 24,
                                    height: 24,
                                    color:
                                        themeManager.themeMode != ThemeMode.dark
                                            ? darkScaffoldBackgroundColor
                                            : lightScaffoldBackgroundColor,
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/Play.svg',
                                    width: 24,
                                    height: 24,
                                    color:
                                        themeManager.themeMode != ThemeMode.dark
                                            ? darkScaffoldBackgroundColor
                                            : lightScaffoldBackgroundColor,
                                  ),
                          ),
                          IconButton(
                            onPressed: () async {
                              Share.share(message);
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/Send.svg',
                              width: 24,
                              height: 24,
                              color: themeManager.themeMode != ThemeMode.dark
                                  ? darkScaffoldBackgroundColor
                                  : lightScaffoldBackgroundColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      );
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      // messages.add(text);
      // _listKey.currentState!.insertItem(messages.length - 1);
      messages.insert(0, text);

      _listKey.currentState!.insertItem(0);
    });
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: UserText(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: UserText(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = _textController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: _textController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        _textController.clear();
        focusNode.unfocus();
        _handleSubmitted('\u200B ${msg}');
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);

      _handleSubmitted(
        utf8.decode(chatProvider
            .getChatList[chatProvider.getChatList.length - 1].msg
            .trim()
            .runes
            .toList()),
      );

      // Timer(Duration(seconds: 0), () {
      //   setState(() {
      //     // Create a random number generator.
      //     final random = Random();

      //     // Generate a random width and height.
      //     _width = random.nextInt(300).toDouble();
      //     _height = random.nextInt(300).toDouble();

      //     // Generate a random color.
      //     _color = Color.fromRGBO(
      //       random.nextInt(256),
      //       random.nextInt(256),
      //       random.nextInt(256),
      //       1,
      //     );
      //   });
      // });
      setState(() {
        _isListening = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: UserText(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  void toggleSpeak(String message) async {
    if (isSpeaking) {
      // Stop TTS if it is currently speaking
      await flutterTts.stop();
      isSpeaking = false;
    } else {
      // Start TTS if it is not currently speaking
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1);
      await flutterTts.speak(message);
      isSpeaking = true;
    }
  }

  Future openDialogue(TextEditingController controller) => showDialog(
        context: context,
        builder: (context) =>
            Consumer<ThemeManager>(builder: (context, themeManager, child) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            contentPadding: const EdgeInsets.only(top: 10.0),
            title: Center(
              child: Text(
                'Give Title for your Note',
                style: GoogleFonts.roboto(color: Colors.black, fontSize: 20),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  // boxShadow: [
                  //   themeManager.themeMode != ThemeMode.dark
                  //       ? BoxShadow(
                  //           // offset: Offset(0, 0),
                  //           blurRadius: 15,
                  //           // spreadRadius: 2,
                  //           color: Colors.grey.shade500,
                  //         )
                  //       : BoxShadow()
                  // ],
                  color: themeManager.themeMode == ThemeMode.dark
                      ? darkScaffoldBackgroundColor
                      : lightScaffoldBackgroundColor, // WhatsApp background color
                  borderRadius: BorderRadius.circular(
                      12), // Rounded corners for the chat input area
                ),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'close',
                  style: GoogleFonts.roboto(color: Colors.black, fontSize: 16),
                ),
              ),
              TextButton(
                onPressed: () {
                  Note note = Note(
                    title: (controller.text == null || controller.text == '')
                        ? 'Note'
                        : controller.text,
                    description: _description,
                    time: DateTime.now().toString(),
                  );
                  DatabaseHelper.instance.insert(note);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(milliseconds: 200),
                      content: Center(
                        child: Text(
                          "Saved succesfully",
                          style: GoogleFonts.roboto(
                              color: Colors.black, fontSize: 30),
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                  // ZoomDrawer.of(context)?.open();
                },
                child: const Text('Save'),
              ),
            ],
          );
        }),
      );

  ///IMAGE
  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {});

    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    _textController.text = recognizedText.text;

    ///End busy state
    setState(() {
      Navigator.pop(context);
    });
  }

  ///  TEXT TO SPEECH
  speak(dynamic message) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(message);
  }

  /// SPEECH TO TEXT
  void _listen(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (!_isListening) {
      bool? available = await _speech?.initialize(
        onStatus: (status) {
          print('onStatus: $status');
        },
        onError: (error) {
          print('onError: $error');
        },
      );

      if (available ?? false) {
        setState(() {
          _isListening = true;
        });

        _speech?.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
              _textController.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _speech?.stop();
      });
    }

    ///UNCOMMENT BELOW CODE TO SEND THE MESSAGE DIRECTLY
    // await sendMessageFCT(
    //   modelsProvider: modelsProvider,
    //   chatProvider: chatProvider,
    // );
  }
}

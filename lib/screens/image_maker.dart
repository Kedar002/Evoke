import 'dart:convert';
import 'dart:io';
import 'package:evoke/constants/constants.dart';
import 'package:evoke/providers/chats_provider.dart';
import 'package:evoke/theme/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../Utils/image_cropper_page.dart';
import '../Utils/image_picker_class.dart';
import '../constants/api_consts.dart';
import '../providers/models_provider.dart';
import '../widgets/modal_dialog.dart';

class ImagePage extends StatefulWidget {
  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  TextEditingController inputText = TextEditingController();

  String url = 'https://api.openai.com/v1/images/generations';
  String? image;
  ThemeManager themeManager = ThemeManager();
  FocusNode focusNode = FocusNode();
  bool textSend = false;
  bool _isListening = false;
  stt.SpeechToText? _speech;
  String _text = '';
  String temp = '';

  String imageRes = '256x256';
  void getAIImage() async {
    if (inputText.text.isNotEmpty) {
      var data = {
        "prompt": inputText.text,
        "n": 1,
        "size": imageRes,
      };

      var res = await http.post(Uri.parse(url),
          headers: {
            "Authorization": "Bearer ${API_KEY}",
            "Content-Type": "application/json"
          },
          body: jsonEncode(data));

      var jsonResponse = jsonDecode(res.body);

      image = jsonResponse['data'][0]['url'];
      setState(() {});
    } else {
      print("Enter something");
    }
  }

  @override
  void initState() {
    focusNode.addListener(() {
      setState(() {
        textSend = focusNode.hasFocus;
      });
    });
    super.initState();
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
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                cardColor: Colors.black,
              ),
              child: PopupMenuButton(
                  // add icon, by default "3 dot" icon
                  // icon: Icon(Icons.book)
                  itemBuilder: (context) {
                return [
                  PopupMenuItem<String>(
                    value: '0',
                    child: Text(
                      "My imageRes = '256x256'",
                      style:
                          GoogleFonts.dmSans(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: '1',
                    child: Text(
                      "imageRes = '512x512'",
                      style:
                          GoogleFonts.dmSans(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: '2',
                    child: Text(
                      "imageRes = '1024x1024'",
                      style:
                          GoogleFonts.dmSans(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ];
              }, onSelected: (value) {
                if (value == 0) {
                  setState(() {
                    imageRes = '256x256';
                  });
                } else if (value == 1) {
                  setState(() {
                    imageRes = '512x512';
                  });
                } else if (value == 2) {
                  setState(() {
                    imageRes = '1024x1024';
                  });
                }
              }),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            image != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: darkScaffoldBackgroundColor,
                            ), //Border.all
                            /*** The BorderRadius widget  is here ***/
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight:
                                    Radius.circular(12)), //BorderRadius.all
                          ),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image(
                                image: NetworkImage(image!),
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                onPressed: () async {
                                  shareImage(image);
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/Send.svg',
                                  width: 24,
                                  height: 24,
                                  color:
                                      themeManager.themeMode != ThemeMode.dark
                                          ? darkScaffoldBackgroundColor
                                          : lightScaffoldBackgroundColor,
                                ),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  temp,
                                  style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: themeManager.themeMode !=
                                              ThemeMode.dark
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.9,
                    child: Center(
                        child: Text(
                      "Please Enter Text To Generate AI image",
                      style: GoogleFonts.roboto(
                          color: themeManager.themeMode != ThemeMode.dark
                              ? Colors.black
                              : Colors.white),
                    )),
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.27,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20,
              ),
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
                        : const BoxShadow()
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
                        controller: inputText,
                        decoration: InputDecoration.collapsed(
                          hintText: "Write...",
                          hintStyle: GoogleFonts.roboto(
                              color: const Color(
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
                          pickImage(source: ImageSource.gallery).then((value) {
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
                    textSend == true || inputText.text.isNotEmpty
                        ? IconButton(
                            onPressed: () async {
                              getAIImage();
                              temp = inputText.text;
                              inputText.clear();
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
                              _listen();
                            },
                            icon: _isListening != true
                                ? SvgPicture.asset(
                                    'assets/icons/Voice.svg',
                                    width: 28,
                                    height: 28,
                                    color:
                                        themeManager.themeMode != ThemeMode.dark
                                            ? darkScaffoldBackgroundColor
                                            : lightScaffoldBackgroundColor,
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/Voice 2.svg',
                                    width: 28,
                                    height: 28,
                                    color:
                                        themeManager.themeMode != ThemeMode.dark
                                            ? darkScaffoldBackgroundColor
                                            : lightScaffoldBackgroundColor,
                                  )),
                    const SizedBox(width: 15), // Right margin for the send icon
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  shareImage(urlImage) async {
    final url = Uri.parse(urlImage);
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);

    await Share.shareFiles([path], text: '');
  }

  ///IMAGE
  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {});

    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    inputText.text = recognizedText.text;

    ///End busy state
    setState(() {
      Navigator.pop(context);
    });
  }

  /// SPEECH TO TEXT
  void _listen() async {
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
              inputText.text = result.recognizedWords;
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
  }
}

import 'package:evoke/providers/chats_provider.dart';
import 'package:evoke/providers/models_provider.dart';
import 'package:evoke/screens/animated_drawer.dart';
import 'package:evoke/theme/theme_constants.dart';
import 'package:evoke/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeManager>(
      create: (_) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ModelsProvider(),
            ),
            ChangeNotifierProvider(
              create: (_) => ChatProvider(),
            ),
          ],
          child: MaterialApp(
            title: 'EVOKE',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeManager.themeMode,
            home: const ExpDrawer(),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';
import 'settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = await SharedPreferences.getInstance();

  runApp( MainApp( settings: settings ) );
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
    required this.settings
  });

  final SharedPreferences settings;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currPage = 0;
  PageController pageController = PageController( initialPage: 0 );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text( "DuoCast" )
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (selectedPage) => setState( () => currPage = selectedPage ),
          children: [
            Chat( settings: widget.settings ),
            Settings( settings: widget.settings )
          ]
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currPage,
          items: [
            BottomNavigationBarItem(
              icon: Icon( Icons.message ),
              label: "Chat"
            ),
            BottomNavigationBarItem(
              icon: Icon( Icons.settings ),
              label: "Settings"
            )
          ],
          onTap: (selectedPage) {
            setState( () => currPage = selectedPage );
            pageController.jumpToPage( selectedPage );
          }
        )
      ),
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          centerTitle: true
        )
      )
    );
  }
}

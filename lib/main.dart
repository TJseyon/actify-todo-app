import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:actify/ui/page_done.dart';
import 'package:actify/ui/page_settings.dart';
import 'package:actify/ui/page_task.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  User? currentUser;

  try {
    await Firebase.initializeApp();
    final UserCredential credential = await FirebaseAuth.instance.signInAnonymously();
    currentUser = credential.user;
  } catch (e) {
    print("Firebase error: $e");
    // Continue without Firebase - use a dummy user
    currentUser = null;
  }

  runApp(ActifyApp(user: currentUser));
}

/// -------------------- APP ROOT --------------------
class ActifyApp extends StatelessWidget {
  final User? user;

  const ActifyApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Actify',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(user: user),
    );
  }
}

/// -------------------- HOME PAGE --------------------
class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({Key? key, this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      DonePage(user: widget.user),
      TaskPage(user: widget.user),
      SettingsPage(user: widget.user),
    ];

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calendarCheck),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.calendar),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.slidersH),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
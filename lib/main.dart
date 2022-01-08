import 'package:chat3/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatScreen(),
    theme: ThemeData(
        primaryColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.blue,
        )),
  ));
}

import 'package:chat3/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ChatScreen(),
    theme: ThemeData(
        primaryColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.blue,
        )),
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

import 'package:chat3/chat_message.dart';
import 'package:chat3/text.composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User _currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  Future<User> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user;
      return user;
    } catch (error) {
      return null;
    }
  }

  void _sendMessage({String text, File imgFile}) async {
    final User user = await _getUser();

    if (user == null) {
      _scaffoldKey.currentState.showSnackBar(
        const SnackBar(
          content: Text('Não foi possivel fazer o login. Tente novamenete!'),
          backgroundColor: Colors.red,
        ),
      );
    }
    Map<String, dynamic> data = {
      'uid': user.uid,
      'senderName': user.displayName,
      'senderPhotoUrl': user.photoURL,
      'time': Timestamp.now(),
    };

    if (imgFile != null) {
      StorageUploadTask task = FirebaseStorage.instance
          .ref()
          .child(user.uid + DateTime.now().microsecondsSinceEpoch.toString())
          .putFile(imgFile);

      setState(() {
        isLoading = true;
      });

      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;

      setState(() {
        isLoading = false;
      });
    }

    if (text != null) data['text'] = text;

    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_currentUser != null
            ? 'Olá, ${_currentUser.displayName}'
            : 'Chat App'),
        elevation: 0,
        centerTitle: true,
        actions: [
          _currentUser != null
              ? IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    googleSignIn.signOut();
                    _scaffoldKey.currentState.showSnackBar(
                      const SnackBar(
                        content: Text('Você saiu com sucesso'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                )
              : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    List<DocumentSnapshot> documents =
                        snapshot.data.docs.reversed.toList();
                    return ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ChatMessage(
                            documents[index].data(),
                            documents[index]['uid'] == _currentUser?.uid,
                          );
                        });
                }
              },
            ),
          ),
          isLoading ? const LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginWithGoogle extends StatefulWidget {
  const LoginWithGoogle({Key? key}) : super(key: key);

  @override
  _LoginWithGoogleState createState() => _LoginWithGoogleState();
}

class _LoginWithGoogleState extends State<LoginWithGoogle> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Iniciar Sesión"),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://thumbs.gfycat.com/SecondaryActualFishingcat-size_restricted.gif'),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Container(
              decoration: new BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                  //logo
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://i.pinimg.com/originals/0f/51/fc/0f51fcc3153f0c62c9b2e89514bec5c4.gif'),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (FirebaseAuth.instance.currentUser == null) {
                          await signInWithGoogle();
                        } else {
                          Navigator.pushNamed(context, 'home');
                        }

                        setState(() {});
                      },
                      child: Text("Inicio de Sesión con Google")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential and add user to firestore
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) => {
              Navigator.pushNamed(context, 'home'),
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(value.user!.uid)
                  .set({
                'name': value.user!.displayName,
                'email': value.user!.email,
                'photo': value.user!.photoURL,
                'uid': value.user!.uid,
              }, SetOptions(merge: true))
            });
  }
}

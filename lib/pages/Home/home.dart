import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:practica1/pages/Favorites/favorites.dart';
import 'package:practica1/pages/Home/sign_in.dart';

import 'bloc/listen_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool glow = false;
  String msg = "Toque para escuchar";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF454443),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocConsumer<ListenBloc, ListenState>(
          listener: (context, state) {
            if (state is ListenSuccess) {
              Navigator.pushNamed(context, 'song', arguments: {
                'title': state.title,
                'album': state.album,
                'artista': state.artista,
                'fecha': state.fecha,
                'apple': state.apple,
                'spotify': state.spotify,
                'image': state.image,
                'link': state.link
              });

              glow = false;
              msg = 'Toque para escuchar';
            } else if (state is ListenListening) {
              glow = true;
              msg = 'Escuchando...';
            } else if (state is ListenError) {
              glow = false;
              msg = 'Toque para escuchar';
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  msg,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 100,
                ),
                AvatarGlow(
                  animate: glow,
                  endRadius: 180.0,
                  glowColor: Colors.white,
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<ListenBloc>(context).add(ListenStart());
                    },
                    child: Material(
                      shape: CircleBorder(),
                      color: Colors.white,
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(30),
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/music.png'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FavoritesPage()));
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.favorite,
                          size: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Cerrar Sesión'),
                                content: Text(
                                    '¿Está seguro que desea cerrar sesión?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel')),
                                  TextButton(
                                      onPressed: () async {
                                        await FirebaseAuth.instance.signOut();
                                        await GoogleSignIn().signOut();
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginWithGoogle()));
                                      },
                                      child: Text('Sign Out'))
                                ],
                              );
                            });

                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.logout,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

//make a widget for the favorites page
//and its a listview with an image because we will have a list of favorites

// Compare this snippet from lib\pages\Favorites\favorites.dart:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:practica1/providers/favorites_provider.dart';

import '../Song/song.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<FavoriteSongs>(context, listen: false)
        .getFavorites()
        .then((value) => {setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: context.watch<FavoriteSongs>().favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(
                context.watch<FavoriteSongs>().favorites[index]['image']),
            title:
                Text(context.watch<FavoriteSongs>().favorites[index]['title']),
            subtitle: Text(Provider.of<FavoriteSongs>(context, listen: false)
                .favorites[index]['artista']),
            trailing: Wrap(
              spacing: 12,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    context.read<FavoriteSongs>().removeFavorite(
                        Provider.of<FavoriteSongs>(context, listen: false)
                            .favorites[index]['title'],
                        Provider.of<FavoriteSongs>(context, listen: false)
                            .favorites[index]['artista']);
                    setState(() {});
                  },
                  icon: Icon(Icons.favorite),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'song', arguments: {
                      'title':
                          Provider.of<FavoriteSongs>(context, listen: false)
                              .favorites[index]['title'],
                      'album':
                          Provider.of<FavoriteSongs>(context, listen: false)
                              .favorites[index]['album'],
                      'artista':
                          Provider.of<FavoriteSongs>(context, listen: false)
                              .favorites[index]['artista'],
                      'fecha':
                          Provider.of<FavoriteSongs>(context, listen: false)
                              .favorites[index]['fecha'],
                      'apple':
                          Provider.of<FavoriteSongs>(context, listen: false)
                              .favorites[index]['apple'],
                      'spotify':
                          Provider.of<FavoriteSongs>(context, listen: false)
                              .favorites[index]['spotify'],
                      'image':
                          Provider.of<FavoriteSongs>(context, listen: false)
                              .favorites[index]['image'],
                      'link': Provider.of<FavoriteSongs>(context, listen: false)
                          .favorites[index]['link'],
                    });
                  },
                  icon: Icon(Icons.info),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

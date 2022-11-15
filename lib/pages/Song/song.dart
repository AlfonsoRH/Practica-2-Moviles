import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practica1/providers/favorites_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Home/home.dart';
import 'package:url_launcher/url_launcher.dart';

class SongPage extends StatefulWidget {
  SongPage({Key? key}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    final song = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomePage()));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Here you go'),
        actions: [
          IconButton(
              onPressed: () {
                if (context
                    .read<FavoriteSongs>()
                    .searchFavorite(song['title'], song['artista'])) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Eliminar de favoritos'),
                            content: Text(
                                'El elemento será eliminado de tus favoritos ¿Quieres continuar?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<FavoriteSongs>().removeFavorite(
                                      song['title'], song['artista']);
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: Text('Eliminar'),
                              ),
                            ],
                          ));
                } else {
                  context.read<FavoriteSongs>().addFavorite(song);
                  Navigator.pushNamed(context, 'favorites');
                  setState(() {});
                }
              },
              icon: Icon(
                context
                        .watch<FavoriteSongs>()
                        .searchFavorite(song['title'], song['artista'])
                    ? Icons.favorite
                    : Icons.favorite_border,
              )),
        ],
      ),
      body: Container(
        //image half of screen then column with song info

        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                song['image'],
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              child: Column(
                children: [
                  Text(
                    song['title'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    song['album'],
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    song['artista'],
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Text(
                    song['fecha'],
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              'Abrir con:',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Tooltip(
                      message: 'Abrir en Spotify',
                      child: IconButton(
                        onPressed: () {
                          launchUrl(Uri.parse(song['spotify']));
                        },
                        icon: FaIcon(FontAwesomeIcons.spotify),
                        iconSize: 40,
                      )),
                  Tooltip(
                      message: 'Abrir Link',
                      child: IconButton(
                        onPressed: () {
                          launchUrl(Uri.parse(song['link']));
                        },
                        icon: FaIcon(FontAwesomeIcons.podcast),
                        iconSize: 40,
                      )),
                  Tooltip(
                      message: 'Abrir en iTunes',
                      child: IconButton(
                        onPressed: () {
                          launchUrl(Uri.parse(song['apple']));
                        },
                        icon: FaIcon(FontAwesomeIcons.apple),
                        iconSize: 40,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

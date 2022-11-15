import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

part 'listen_event.dart';
part 'listen_state.dart';

class ListenBloc extends Bloc<ListenEvent, ListenState> {
  ListenState get initialState => ListenInitial();

  ListenBloc() : super(ListenInitial()) {
    on<ListenEvent>(_listenSong);
  }

  void _listenSong(event, emit) async {
    //crear path temporal
    final path = await getPath();
    //Path donde se guarda la grabación
    final songpath = await recordSong(path, emit);

    //Convertir archivo a base64
    File file = File(songpath!);
    List<int> fileBytes = await file.readAsBytes();
    String finalFile = base64Encode(fileBytes);

    //Se guarda el json de la respuesta
    var resJson = await recieveSong(finalFile);

    if (resJson['result'] == null || resJson == null) {
      emit(ListenError());
    } else {
      try {
        print('ListenSuccess');

        final String title = resJson['result']['title'];
        final String album = resJson['result']['album'];
        final String artista = resJson['result']['artist'];
        final String fecha = resJson['result']['release_date'];
        final String apple = resJson['result']['apple_music']['url'];
        final String spotify =
            resJson['result']['spotify']['external_urls']['spotify'];
        final String image =
            resJson['result']['spotify']['album']['images'][0]['url'];
        final String link = resJson['result']['song_link'];

        emit(ListenSuccess(
            title: title,
            album: album,
            artista: artista,
            fecha: fecha,
            apple: apple,
            spotify: spotify,
            image: image,
            link: link));
      } catch (e) {
        emit(ListenError());
      }
    }
  }

  Future<String> getPath() async {
    Directory directory = await getTemporaryDirectory();
    print(directory);
    return directory.path;
  }

  Future<String?> recordSong(String path, Emitter<dynamic> emit) async {
    final record = Record();
    print("2. path: $path");
    try {
      emit(ListenListening());
      if (await record.hasPermission()) {
        await record.start(
          path: '${path}/song.mp3',
          encoder: AudioEncoder.aacHe,
          bitRate: 128000,
          samplingRate: 44100,
        );
        await Future.delayed(Duration(seconds: 7));
        return await record.stop();
      }
    } catch (e) {
      emit(ListenError());
      return null;
    }
  }

  Future<dynamic> recieveSong(String song) async {
    emit(ListenFinished());

    http.Response res = await http.post(
      Uri.parse('https://api.audd.io/'),
      headers: {
        'Content-Type': 'multipart/form-data',
      },
      body: jsonEncode(
        <String, dynamic>{
          'api_token': '58b909d477df7f4d0873f1e090f7d503',
          'return': 'apple_music,spotify',
          'audio': song,
          'method': 'recognize',
        },
      ),
    );

    if (res.statusCode == 200) {
      print(res.body);
      return jsonDecode(res.body);
    } else {
      emit(ListenError());
      return null;
    }
  }
}

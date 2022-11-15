import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteSongs with ChangeNotifier {
  List<dynamic> _favorites = [];

  List<dynamic> get favorites => _favorites;

  Future<void> getFavorites() async {
    final user = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final favorites = await user.get();
    if (favorites.exists && favorites.data()!['favorites'] != null) {
      print(favorites.data()!['favorites']);
      _favorites = [];
      _favorites = favorites.data()!['favorites'];
    } else {
      _favorites = [];
    }
  }

  void addFavorite(song) {
    _favorites.add(song);
    print('favoritos: $_favorites');
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'favorites': _favorites});
    notifyListeners();
  }

  void removeFavorite(title, artist) {
    _favorites.removeWhere(
        (element) => element['title'] == title && element['artista'] == artist);
    print('favoritos: $_favorites');
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'favorites': _favorites});
    notifyListeners();
  }

  bool searchFavorite(title, artist) {
    for (var i = 0; i < _favorites.length; i++) {
      if (_favorites[i]['title'] == title &&
          _favorites[i]['artista'] == artist) {
        return true;
      }
    }
    return false;
  }
}

import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StateControl extends ChangeNotifier {
  //hier muss eigentlich die _data rein, wenn es später als json decodiert wurde
  final List<Map<String, dynamic>> _rooms = [];
  List<String> urls = [];

  // so I can return _rooms globally
  UnmodifiableListView<Map<String, dynamic>> get rooms =>
      UnmodifiableListView(_rooms);

  void addRoom(Map<String, dynamic> roomData) {
    //to prevent double scanning
    List<String> titles = [];
    for (var room in _rooms) {
      titles.add(room["title"]);
    }

    if (!titles.contains(roomData["title"])) {
      _rooms.add(roomData);
      notifyListeners();
    }
  }

  void addUrl(String url) {
    urls.add(url);
    String jsonList = json.encode(urls);
    saveData('urlList', jsonList);
    notifyListeners();
  }

  saveData(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<List<String>> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String storedUrls = prefs.getString(key);
    if (storedUrls != null) {
      print(storedUrls);
      print(json.decode(storedUrls));
      List<dynamic> decoded = json.decode(storedUrls) ?? [];
      List<String> urlList = [];
      decoded.forEach((url) {
        urlList.add(url.toString());
      });
      urls = urlList;
      return urlList;
    } else {
      return [];
    }
  }
}

import 'package:flutter/material.dart';

class ZaloUser {
  String name;
  String id;
  int error;
  String message;
  Picture picture;

  ZaloUser({
    required this.name,
    required this.id,
    required this.error,
    required this.message,
    required this.picture,
  });

  factory ZaloUser.fromJson(Map<String, dynamic> json) {
    return ZaloUser(
      name: json['name'],
      id: json['id'],
      error: json['error'],
      message: json['message'],
      picture: Picture.fromJson(json['picture']),
    );
  }
}

class Picture {
  Data data;

  Picture({
    required this.data,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      data: Data.fromJson(json['data']),
    );
  }
}

class Data {
  String url;

  Data({
    required this.url,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      url: json['url'],
    );
  }
}

class UserModel extends ChangeNotifier {
  Future<ZaloUser>? future;

  void newFuture(Future<ZaloUser> future) {
    this.future = future;
    notifyListeners();
  }
}

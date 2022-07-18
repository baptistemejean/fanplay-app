import 'package:flutter/material.dart';

class Franchise {
  String id;
  String cityName;
  String franchiseName;
  String code;
  String confName;
  String divName;
  Color colorPrimary;
  Color colorSecondary;
  String logoURL;
  String rId;

  bool isEmpty = false;

  Franchise({
    required this.id,
    required this.cityName,
    required this.franchiseName,
    required this.code,
    required this.confName,
    required this.divName,
    required this.colorPrimary,
    required this.colorSecondary,
    required this.logoURL,
    required this.rId,
    this.isEmpty = false,
  });

  factory Franchise.fromJson(Map<String, dynamic> json) {
    return Franchise(
      id: json['id'],
      cityName: json['cityName'],
      franchiseName: json['franchiseName'],
      code: json['code'],
      confName: json['confName'],
      divName: json['divName'],
      colorPrimary: Color(int.parse(json['colorPrimary'])),
      colorSecondary: Color(int.parse(json['colorSecondary'])),
      logoURL: json['logoURL'],
      rId: json['rId'],
    );
  }

  factory Franchise.empty() {
    return Franchise(
        id: '',
        cityName: '',
        franchiseName: '',
        code: '',
        confName: '',
        divName: '',
        colorPrimary: Colors.black,
        colorSecondary: Colors.black,
        logoURL: '',
        rId: '',
        isEmpty: true);
  }
}

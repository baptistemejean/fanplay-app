import 'dart:ffi';

import 'franchise.dart';

class NbaPlayer {
  String? firstName;
  String? lastName;
  Franchise? franchise;

  String? realFullPosition;
  String? realCondensedPosition;
  String? currentPosition;
  int? currentEnergy;

  int? age;
  double? heightMeters;
  int? heightFeet;
  int? heightInches;
  double weightKilograms;
  int? weightPounds;

  NbaPlayer({
    required this.firstName,
    required this.lastName,
    this.franchise,
    this.realFullPosition,
    required this.realCondensedPosition,
    required this.currentPosition,
    required this.currentEnergy,
    required this.age,
    required this.heightMeters,
    required this.heightFeet,
    required this.heightInches,
    required this.weightKilograms,
    required this.weightPounds,
  });

  factory NbaPlayer.fromJson(Map<String, dynamic> json) {
    return NbaPlayer(
        firstName: json['firstName'],
        lastName: json['lastName'],
        realCondensedPosition: json['pos'],
        currentPosition: json['pos'],
        currentEnergy: 0,
        age: (DateTime.now().difference(DateTime.parse(json['dateOfBirthUTC'])))
            .inDays,
        heightMeters: json['heightMeters'],
        heightFeet: json['heightFeet'],
        heightInches: json['heightInches'],
        weightKilograms: json['weightKilograms'].toDouble(),
        weightPounds: json['weightPounds']);
  }
}

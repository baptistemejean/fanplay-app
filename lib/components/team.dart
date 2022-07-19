import 'package:fanplay/components/franchise.dart';

import 'nba_player.dart';

class Team {
  List<dynamic> roster;

  int wins;
  int losses;
  double winPercentage;

  String ownerId;

  Franchise franchise;

  Team(
      {required this.roster,
      required this.wins,
      required this.losses,
      required this.winPercentage,
      required this.ownerId,
      required this.franchise});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      roster: json['roster'],
      wins: json['wins'],
      losses: json['losses'],
      winPercentage: json['winPercentage'].toDouble(),
      ownerId: json['ownerId'],
      franchise: Franchise.fromJson(json['franchise']),
    );
  }
}

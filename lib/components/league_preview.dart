import 'package:fanplay/components/team.dart';

import 'league.dart';

class LeaguePreview {
  String name;
  bool isPrivate;
  int playerCount;
  List<dynamic> playerTeams;
  String id;
  String condensedId;

  LeaguePreview({
    required this.name,
    required this.isPrivate,
    required this.playerCount,
    required this.playerTeams,
    required this.id,
    required this.condensedId,
  });

  factory LeaguePreview.fromJson(Map<String, dynamic> json) {
    return LeaguePreview(
        name: json['name'],
        isPrivate: json['isPrivate'],
        playerCount: json['playerCount'],
        playerTeams: json['playerTeams'],
        id: json['_id'],
        condensedId: json['condensedId']);
  }
}

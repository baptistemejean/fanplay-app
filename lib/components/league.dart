import 'team.dart';

class League {
  String id;
  String name;
  bool isPrivate;
  bool isSingleTeam;
  String condensedId;
  /*late Team? selectedTeam;
  late List<dynamic>? playerTeams = [];*/
  List<Team> teams;
  Team? selectedTeam;

  League(
      {required this.id,
      required this.name,
      required this.isPrivate,
      required this.isSingleTeam,
      required this.condensedId,
      required this.teams,
      this.selectedTeam});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
        id: json['id'],
        name: json['name'],
        isPrivate: json['isPrivate'],
        isSingleTeam: json['isSingleTeam'],
        condensedId: json['condensedId'],
        teams: json['teams'].map<Team>((dynamic team) {
          return Team.fromJson(team);
        }).toList());
  }

  League withSelectedTeam(Team selectedTeam) {
    final league = this;
    league.selectedTeam = selectedTeam;

    return league;
  }
}

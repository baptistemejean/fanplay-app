import 'dart:ffi';

import 'package:fanplay/components/nba_player.dart';
import 'package:fanplay/components/user.dart';
import 'package:flutter/foundation.dart';
import 'package:fanplay/components/franchise.dart';
import 'dart:convert';
import 'package:fanplay/components/league.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'http_exception.dart';
import 'tokens.dart';

class HttpRequests {
  static const String PORT = '5000';
}

class TokenRequests extends HttpRequests {
  static Future<bool> tryRefreshToken() async {
    final result = await refreshToken() as Map<String, dynamic>;
    final exception = result['exception'] as HttpException;

    return exception.success;
  }

  static Future<Map<String, dynamic>> refreshToken() async {
    final refreshToken = await Tokens.getToken('refresh_token');

    final http.Response response = await http.get(
      Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/auth/v1/token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $refreshToken'
      },
    );

    final exception = HttpException.fromResponse(response);

    if (exception.success) {
      final accessToken = jsonDecode(response.body)['access_token'];
      final refreshToken = jsonDecode(response.body)['refresh_token'];

      await Tokens.saveToken('access_token', accessToken);
      await Tokens.saveToken('refresh_token', refreshToken);
    }

    return {'exception': exception, 'body': null};
  }
}

class AuthRequests extends HttpRequests {
  static Future<Map<String, dynamic>> signup(
      String email, String username, String password) async {
    final http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/auth/v1/signup'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'username': username,
          'password': password
        }));

    final exception = HttpException.fromResponse(response, response.body);

    if (exception.success) {
      final accessToken = jsonDecode(response.body)['access_token'];
      final refreshToken = jsonDecode(response.body)['refresh_token'];

      await Tokens.saveToken('access_token', accessToken);
      await Tokens.saveToken('refresh_token', refreshToken);
    }

    return {'exception': exception, 'body': null};
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String username,
    String password,
  ) async {
    final http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/auth/v1/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'username': username,
          'password': password
        }));

    final exception = HttpException.fromResponse(response, response.body);

    if (exception.success) {
      final accessToken = jsonDecode(response.body)['access_token'];
      final refreshToken = jsonDecode(response.body)['refresh_token'];

      await Tokens.saveToken('access_token', accessToken);
      await Tokens.saveToken('refresh_token', refreshToken);
    }

    return {'exception': exception, 'body': null};
  }

  static Future<Map<String, dynamic>> logout() async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.post(
      Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/auth/v1/logout'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );

    final exception = HttpException.fromResponse(response);

    if (exception.success) {
      await Tokens.removeTokens();
    }

    return {'exception': exception, 'body': null};
  }

  static Future<Map<String, dynamic>> getUser() async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.get(
      Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/api/v1/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );

    var user;

    final exception = HttpException.fromResponse(response);

    if (exception.success) {
      user = User.fromJson(jsonDecode(response.body));
    }

    return {'exception': exception, 'body': user};
  }
}

class LeagueRequests {
  static Future<Map<String, dynamic>> getLeagues() async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/api/v1/leagues'),
        headers: {'Authorization': 'Bearer $accessToken'});

    List<League> leagues = [];

    final exception = HttpException.fromResponse(response);

    if (exception.success) {
      var leaguesList = jsonDecode(response.body) as List;

      for (int i = 0; i < leaguesList.length; i++) {
        leagues.add(League.fromJson(leaguesList.elementAt(i)));
      }
    }

    return {'exception': exception, 'body': leagues};
  }

  static Future<Map<String, dynamic>> getLeague(String id) async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.get(
      Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/api/v1/leagues/$id'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken'
      },
    );

    var league;

    final exception = HttpException.fromResponse(response);

    if (exception.success) {
      league = League.fromJson(jsonDecode(response.body));
    }

    return {'exception': exception, 'body': league};
  }

  static Future<Map<String, dynamic>> createLeague(
      String name, bool isPrivate, bool isSingleTeam) async {
    final accessToken = await Tokens.getToken('access_token');
    final http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/api/v1/leagues'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, dynamic>{
          'name': name,
          'isPrivate': isPrivate,
          'isSingleTeam': isSingleTeam
        }));

    final exception = HttpException.fromResponse(response);

    return {'exception': exception, 'body': null};
  }

  static Future<Map<String, dynamic>> joinLeague(String condensedId) async {
    final accessToken = await Tokens.getToken('access_token');
    final http.Response response = await http.post(
        Uri.parse(
            'http://10.0.2.2:${HttpRequests.PORT}/api/v1/leagues/join/$condensedId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        });

    final exception = HttpException.fromResponse(response);

    return {'exception': exception, 'body': null};
  }

  static Future<Map<String, dynamic>> deleteLeague(String id) async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.delete(
        Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/api/v1/leagues/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        });

    final exception = HttpException.fromResponse(response);

    return {'exception': exception, 'body': null};
  }

  static Future<Map<String, dynamic>> renameLeague(
      League league, String newName) async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/api/v1/leagues/rename'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, dynamic>{
          'newName': newName,
          'isPrivate': league.isPrivate,
          '_id': league.id
        }));

    final exception = HttpException.fromResponse(response);

    return {'exception': exception, 'body': null};
  }
}

class TeamRequests {
  static Future<Map<String, dynamic>> getFranchises() async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.get(
        Uri.parse('http://10.0.2.2:${HttpRequests.PORT}/api/v1/franchises'),
        headers: {'Authorization': 'Bearer $accessToken'});

    final exception = HttpException.fromResponse(response);

    List<Franchise> franchises = [];

    if (exception.success) {
      var franchiseList = jsonDecode(response.body);

      for (int i = 0; i < franchiseList.length; i++) {
        franchises.add(Franchise.fromJson(franchiseList.elementAt(i)));
      }
    }

    return {
      'exception': exception,
      'body': exception.success ? franchises : null
    };
  }

  static Future<Map<String, dynamic>> getPlayersByFranchise(
      String franchiseRId) async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.get(
        Uri.parse(
            'http://10.0.2.2:${HttpRequests.PORT}/api/v1/players/$franchiseRId'),
        headers: {'Authorization': 'Bearer $accessToken'});

    final exception = HttpException.fromResponse(response);

    List<NbaPlayer> players = [];

    if (exception.success) {
      var playerList = jsonDecode(response.body);

      for (int i = 0; i < playerList.length; i++) {
        players.add(NbaPlayer.fromJson(playerList.elementAt(i)));
      }
    }

    return {'exception': exception, 'body': exception.success ? players : null};
  }

  static Future<Map<String, dynamic>> createTeam(
      String franchiseId, String leagueId) async {
    final accessToken = await Tokens.getToken('access_token');

    final http.Response response = await http.post(
        Uri.parse(
            'http://10.0.2.2:${HttpRequests.PORT}/api/v1/leagues/$leagueId/teams'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
        body: jsonEncode(<String, dynamic>{
          'franchiseId': franchiseId,
        }));

    final exception = HttpException.fromResponse(response);

    return {'exception': exception, 'body': null};
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_app/model/http_execption.dart';

class Auth with ChangeNotifier {
  var _token;
  var _exparydate = DateTime.now();
  var _userid = '';
  Timer? _timer;

  bool get isauth {
    return _token != null;
  }

  String get userid {
    return _userid;
  }

  String get token {
    if (_exparydate != DateTime.now() &&
        _exparydate.isAfter(DateTime.now()) &&
        _token != 'null') {
      return _token;
    } else {
      return 'null';
    }
  }

  Future<void> auth(String email, String password, String urls) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urls?key=AIzaSyCfXRwdEAGbUnXRj6CD3hqsyDJG_rFPYvs');
    try {
      final responce = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responcedata = jsonDecode(responce.body);

      if (responcedata['error'] != null) {
        throw HttpError(responcedata['error']['message']);
      }
      _exparydate = DateTime.now()
          .add(Duration(seconds: int.parse(responcedata['expiresIn'])));
      _token = responcedata['idToken'];
      _userid = responcedata['localId'];
      autologout();

      final prifs = await SharedPreferences.getInstance();

      // final logindata = jsonEncode({
      //   'token': _token,
      //   'userid': _userid,
      //   'expdate': _exparydate.toIso8601String()
      // });

      prifs.setString('token', _token);
      prifs.setString('userid', _userid);
      prifs.setString('expdate', _exparydate.toIso8601String());

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password, BuildContext ctx) async {
    return auth(email, password, 'signUp');
  }

  Future<void> login(String email, String password, BuildContext ctx) async {
    return auth(email, password, 'signInWithPassword');
  }

  Future<bool> autologin() async {
    print('autologin called');
    final prifs = await SharedPreferences.getInstance();
    if (!prifs.containsKey('token') ||
        !prifs.containsKey('userid') ||
        !prifs.containsKey('expdate')) {
      print('no data');
      return false;
    }

    final token = prifs.getString('token');
    final userid = prifs.getString('userid');
    final time = prifs.getString('expdate');
    final expdate = DateTime.parse(time!);
    if (expdate.isBefore(DateTime.now())) {
      print('Time out');
      return false;
    }
    _token = token;
    _userid = userid!;
    _exparydate = expdate;
    autologout();
    notifyListeners();
    print('finish');
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _exparydate = DateTime.now();
    _userid = '';
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }

    notifyListeners();
    final prifs = await SharedPreferences.getInstance();
    // prifs.remove('Logindata');
    prifs.clear();
  }

  void autologout() {
    if (_timer != null) {
      _timer!.cancel();
    }
    final timetoexp = _exparydate.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: timetoexp), logout);

    notifyListeners();
  }
}

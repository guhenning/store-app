import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:store/data/store.dart';
import 'package:store/exceptions/auth_exeption.dart';
import 'package:store/utils/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=${Constants.webApiKey}';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
  }

  Future<void> signinwithgoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.credential is AuthCredential) {
          final accessToken = await userCredential.user!.getIdToken();
          _token = accessToken;

          final idTokenResult = await userCredential.user!.getIdTokenResult();
          if (idTokenResult.expirationTime != null) {
            final expiryTime = idTokenResult.expirationTime!
                .difference(DateTime.now())
                .inSeconds;
            _expiryDate = DateTime.now()
                .add(Duration(seconds: int.parse(expiryTime.toString())));
          } else {
            _expiryDate = null;
          }
        } else {
          _token = null;
          _expiryDate = null;
        }

        _email = userCredential.user?.email;
        _userId = userCredential.user?.uid;

        Store.saveMap('userData', {
          'token': _token,
          'email': _email,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        });

        _autoLogout();
        notifyListeners();
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Center(
            child: Text(
              'Error',
              style: TextStyle(
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
          content: const Text(
            'An error occurred while signing in with Google.',
          ),
          actions: [
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headlineLarge?.color,
                  fontSize: 14,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  // Future<void> signinwithfacebook(BuildContext context) async {

  // }

  Future<void> resetPassword(BuildContext context, String email) async {
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=${Constants.webApiKey}';
    bool goodResponde = false;
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'requestType': 'PASSWORD_RESET',
        }),
      );
      if (response.statusCode == 200) {
        goodResponde = true;
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Error',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color),
                ),
              ),
              content: Text(e.toString()),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    } finally {
      if (goodResponde == true) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Password Reset',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color),
                ),
              ),
              content: const Text(
                  'A password reset email has been sent to your email address.'),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium?.color),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to send password reset email.');
      }
    }
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogout ?? 0),
      logout,
    );
  }
}

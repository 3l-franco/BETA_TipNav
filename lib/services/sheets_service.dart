import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';


// ================================================================
//  SHEETS SERVICE
//  Dito lahat ng code para mag-connect sa Google Sheets
//
//  checkLogin()  → ginagamit ng login.dart
//  signUpUser()  → ginagamit ng signup.dart
// ================================================================

const String sheetCsvUrl = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRYhyBIdsF_2roqgyxSlXkmhxo87gHuLYoEVd-YK8t70BSyj0Py5LSfMwBoOynYFc4dy5coTcXQiGWi/pub?gid=0&single=true&output=csv";
const String scriptUrl   = "https://script.google.com/macros/s/AKfycbwDqlN5TphhCDOc6OLcHsGdP8vIx6OigY6FBvLhdJ7ZKcQk26oMD2I9UKNs7LL4ZFbk/exec";


// ----------------------------------------------------------------
// HELPER - i-hash yung password gamit SHA-256
// para hindi plain text yung naka-save sa sheet
// ----------------------------------------------------------------
String hashPassword(String password) {
  var bytes  = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}


// ----------------------------------------------------------------
// CHECK LOGIN
// - kinukuha yung CSV data ng sheet
// - ini-compare yung email + hashed password
// - returns true kung tama, false kung mali
// ----------------------------------------------------------------
Future<bool> checkLogin(String email, String password) async {
  try {
    String hashed = hashPassword(password);

    // kuhanin lahat ng data mula sa sheet (CSV format)
    final response = await http.get(Uri.parse(sheetCsvUrl));

    if (response.statusCode != 200) {
      return false;
    }

    // i-split per row tapos per column
    List<String> rows = response.body.trim().split('\n');

    for (int i = 1; i < rows.length; i++) {    // i=1 para preskipin ang header row
      List<String> cols = rows[i].split(',');

      if (cols.length >= 2) {
        String sheetEmail    = cols[0].trim().toLowerCase();
        String sheetPassword = cols[1].trim();

        if (sheetEmail == email.trim().toLowerCase() &&
            sheetPassword == hashed) {
          return true; // MATCH! pwede na mag-login
        }
      }
    }

    return false; // wala sa sheet

  } catch (e) {
    return false;
  }
}


// ----------------------------------------------------------------
// SIGN UP USER
// - FIX: Google Apps Script nagre-redirect ng POST requests (302)
//   Ginagamit natin ang http.Client para ma-follow yung redirect
//   properly at makuha yung tamang response
// ----------------------------------------------------------------
Future<String> signUpUser(String email, String password) async {
  try {
    String hashed = hashPassword(password);

    // http.Client ang ginagamit — hindi yung simple http.post
    // kasi yung http.post hindi laging nag-fofollow ng redirect
    // pero ang http.Client ay nag-fofollow ng redirect by default
    final client = http.Client();

    final request = http.Request('POST', Uri.parse(scriptUrl));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode({
      'email'   : email.trim().toLowerCase(),
      'password': hashed,
    });

    // i-send tapos i-convert sa normal response
    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    client.close(); // laging isara para walang memory leak

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);

      if (result['status'] == 'success') {
        return "success";
      } else if (result['status'] == 'exists') {
        return "Email is already registered!";
      } else {
        return "Something went wrong. Try again.";
      }

    } else {
      return "Server error. Try again later.";
    }

  } catch (e) {
    return "No internet connection!";
  }
}
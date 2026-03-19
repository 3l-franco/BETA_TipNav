import 'package:shared_preferences/shared_preferences.dart';


// ================================================================
//  SESSION SERVICE
//  Dito lahat ng code para sa pag-save ng login session
//
//  saveSession()   → tinatawag pagkatapos mag-login
//  isLoggedIn()    → tinatawag sa splash screen para mag-check
//  clearSession()  → tinatawag pag nag-logout (future use)
// ================================================================


// key na ginagamit natin para sa SharedPreferences
const String _sessionKey = 'logged_in_email';


// ----------------------------------------------------------------
// SAVE SESSION
// - sino-save yung email ng naka-login
// - tinatawag sa login.dart pagkatapos mag-checkLogin()
// ----------------------------------------------------------------
Future<void> saveSession(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_sessionKey, email);
}


// ----------------------------------------------------------------
// IS LOGGED IN
// - nagche-check kung may naka-save na session
// - returns yung email kung naka-login pa, null kung hindi
// - tinatawag sa splash_screen.dart para malaman kung saan mag-route
// ----------------------------------------------------------------
Future<String?> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_sessionKey); // null kung wala
}


// ----------------------------------------------------------------
// CLEAR SESSION
// - dine-delete yung saved session (para sa logout)
// - pwede gamitin sa profile page pag may logout button na
// ----------------------------------------------------------------
Future<void> clearSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_sessionKey);
}
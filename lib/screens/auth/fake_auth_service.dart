import 'package:flutter_dotenv/flutter_dotenv.dart';

class FakeAuthService {
  static Map<String, Map<String, String>> get _users => {
    dotenv.env['WARDEN_EMAIL']!: {
      "password": dotenv.env['WARDEN_PASSWORD']!,
      "role": "warden",
    },
    dotenv.env['GUARD_EMAIL']!: {
      "password": dotenv.env['GUARD_PASSWORD']!,
      "role": "guard",
    },
    dotenv.env['STUDENT_EMAIL']!: {
      "password": dotenv.env['STUDENT_PASSWORD']!,
      "role": "student",
    },
  };

  static Map<String, String>? login(String email, String password) {
    if (_users.containsKey(email)) {
      if (_users[email]!["password"] == password) {
        return _users[email];
      }
    }
    return null;
  }
}

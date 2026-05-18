import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/explanation_model.dart';

class AiService {
  /// Returns the base URL depending on the platform.
  /// On web, use localhost directly.
  /// On Android emulator, use 10.0.2.2 to reach host localhost.
  /// On iOS simulator and others, use localhost directly.
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    // For mobile platforms, we can conditionally import dart:io
    // but for now default to localhost which works for web + iOS
    return 'http://localhost:8000';
  }

  /// Sends code to the backend for analysis and returns a parsed [ExplanationModel].
  static Future<ExplanationModel> explainCode({
    required String code,
    required bool isEli5,
  }) async {
    final uri = Uri.parse('$_baseUrl/explain');
    final mode = isEli5 ? 'eli5' : 'normal';

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'code': code, 'mode': mode}),
          )
          .timeout(const Duration(seconds: 120));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ExplanationModel.fromJson(json);
      } else {
        // Try to extract error detail from FastAPI response
        String errorMsg = 'Server error (${response.statusCode})';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          if (errorJson.containsKey('detail')) {
            errorMsg = errorJson['detail'].toString();
          }
        } catch (_) {}
        throw Exception(errorMsg);
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Exception:')) {
        rethrow;
      }
      throw Exception(
          'Connection error. Make sure the backend server is running on http://localhost:8000');
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/utils/logger.dart';

abstract class TolgeeService {
  /// Raw JSON export body for a locale, as returned by Tolgee.
  Future<String> exportLocaleRaw(String languageCode);
}

class TolgeeServiceImpl implements TolgeeService {
  static const List<String> _filterStates = <String>['TRANSLATED', 'REVIEWED'];

  final Dio _dio;

  TolgeeServiceImpl({Dio? dio, String? apiUrl, String? apiKey}) : _dio = dio ?? Dio() {
    final url = apiUrl ?? dotenv.maybeGet('TOLGEE_API_URL');
    final key = apiKey ?? dotenv.maybeGet('TOLGEE_API_KEY');

    if (url == null || key == null) {
      logger.w('TolgeeService: TOLGEE_API_URL or TOLGEE_API_KEY is not set');
    }

    _dio.options
      ..baseUrl = url ?? 'https://app.tolgee.io'
      ..connectTimeout = const Duration(seconds: 6)
      ..receiveTimeout = const Duration(seconds: 6)
      ..headers = <String, dynamic>{'X-API-Key': key}
      ..responseType = ResponseType.plain;
  }

  @override
  Future<String> exportLocaleRaw(String languageCode) async {
    final response = await _dio.get<String>(
      '/v2/projects/export',
      queryParameters: <String, dynamic>{
        'languages': languageCode,
        'format': 'JSON',
        'zip': 'false',
        'filterState': _filterStates,
      },
    );

    return response.data ?? '{}';
  }
}

/// Shared instance. Created lazily on first access,
/// dotenv is already loaded by then.
final TolgeeService tolgeeService = TolgeeServiceImpl();

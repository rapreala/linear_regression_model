import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/prediction_request_model.dart';
import '../models/prediction_response_model.dart';

class PredictionService {
  final http.Client _client;

  PredictionService({http.Client? client}) : _client = client ?? http.Client();

  Future<PredictionResponseModel> predict(PredictionRequestModel request) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.predictEndpoint}');

    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PredictionResponseModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    // Parse FastAPI validation errors for user-friendly messages
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final detail = body['detail'];
    String message;
    if (detail is List && detail.isNotEmpty) {
      final first = detail.first as Map<String, dynamic>;
      final field = (first['loc'] as List?)?.lastOrNull ?? 'field';
      message = '$field: ${first['msg']}';
    } else {
      message = detail?.toString() ?? 'Prediction failed (${response.statusCode})';
    }
    throw PredictionException(message);
  }
}

class PredictionException implements Exception {
  final String message;
  const PredictionException(this.message);

  @override
  String toString() => message;
}

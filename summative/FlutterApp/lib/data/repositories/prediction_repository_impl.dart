import '../../domain/entities/prediction_result.dart';
import '../../domain/repositories/prediction_repository.dart';
import '../models/prediction_request_model.dart';
import '../services/prediction_service.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  final PredictionService _service;

  const PredictionRepositoryImpl({required PredictionService service})
      : _service = service;

  @override
  Future<PredictionResult> predict(PredictionRequestModel request) async {
    final model = await _service.predict(request);
    return model.toEntity();
  }
}

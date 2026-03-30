import '../entities/prediction_result.dart';
import '../../data/models/prediction_request_model.dart';

abstract class PredictionRepository {
  Future<PredictionResult> predict(PredictionRequestModel request);
}

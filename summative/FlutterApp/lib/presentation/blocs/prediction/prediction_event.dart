import 'package:equatable/equatable.dart';
import '../../../data/models/prediction_request_model.dart';

abstract class PredictionEvent extends Equatable {
  const PredictionEvent();

  @override
  List<Object?> get props => [];
}

class PredictionRequested extends PredictionEvent {
  final PredictionRequestModel request;

  const PredictionRequested(this.request);

  @override
  List<Object?> get props => [request];
}

class PredictionReset extends PredictionEvent {
  const PredictionReset();
}

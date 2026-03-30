import 'package:equatable/equatable.dart';
import '../../../domain/entities/prediction_result.dart';

abstract class PredictionState extends Equatable {
  const PredictionState();

  @override
  List<Object?> get props => [];
}

class PredictionInitial extends PredictionState {
  const PredictionInitial();
}

class PredictionLoading extends PredictionState {
  const PredictionLoading();
}

class PredictionSuccess extends PredictionState {
  final PredictionResult result;

  const PredictionSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class PredictionFailure extends PredictionState {
  final String message;

  const PredictionFailure(this.message);

  @override
  List<Object?> get props => [message];
}

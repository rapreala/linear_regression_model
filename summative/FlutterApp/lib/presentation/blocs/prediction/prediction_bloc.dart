import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/prediction_repository.dart';
import '../../../data/services/prediction_service.dart';
import 'prediction_event.dart';
import 'prediction_state.dart';

class PredictionBloc extends Bloc<PredictionEvent, PredictionState> {
  final PredictionRepository _repository;

  PredictionBloc({required PredictionRepository repository})
      : _repository = repository,
        super(const PredictionInitial()) {
    on<PredictionRequested>(_onRequested);
    on<PredictionReset>(_onReset);
  }

  Future<void> _onRequested(
    PredictionRequested event,
    Emitter<PredictionState> emit,
  ) async {
    emit(const PredictionLoading());
    try {
      final result = await _repository.predict(event.request);
      emit(PredictionSuccess(result));
    } on PredictionException catch (e) {
      emit(PredictionFailure(e.message));
    } catch (e) {
      emit(PredictionFailure(
        'Could not reach the prediction service. Check your connection and try again.',
      ));
    }
  }

  void _onReset(PredictionReset event, Emitter<PredictionState> emit) {
    emit(const PredictionInitial());
  }
}

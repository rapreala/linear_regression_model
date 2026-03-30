import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/room_entry.dart';
import 'rooms_event.dart';
import 'rooms_state.dart';

class RoomsBloc extends Bloc<RoomsEvent, RoomsState> {
  RoomsBloc()
      : super(RoomsState(rooms: _seedRooms())) {
    on<RoomAdded>((event, emit) {
      emit(state.copyWith(rooms: [...state.rooms, event.room]));
    });
  }

  /// Hardcoded rooms — always present on every app start/hot-restart.
  static List<RoomEntry> _seedRooms() => const [
        RoomEntry(
          name: 'Executive Suite 101',
          type: 'Hotel room',
          accommodates: 4,
          bedrooms: 2,
          district: 'Kimihurura',
          finalPrice: 195.00,
          predictedPrice: 187.50,
        ),
        RoomEntry(
          name: 'Luxury King 202',
          type: 'Entire home / apt',
          accommodates: 2,
          bedrooms: 1,
          district: 'Nyarutarama',
          finalPrice: 210.00,
          predictedPrice: 209.00,
        ),
        RoomEntry(
          name: 'Standard Room 301',
          type: 'Private room',
          accommodates: 2,
          bedrooms: 1,
          district: 'Remera',
          finalPrice: 110.00,
          predictedPrice: 102.30,
        ),
        RoomEntry(
          name: 'Budget Twin 401',
          type: 'Private room',
          accommodates: 2,
          bedrooms: 1,
          district: 'Nyamirambo',
          finalPrice: 85.00,
          predictedPrice: 88.40,
        ),
        RoomEntry(
          name: 'Family Suite 501',
          type: 'Hotel room',
          accommodates: 6,
          bedrooms: 3,
          district: 'Kacyiru',
          finalPrice: 220.00,
          predictedPrice: 215.60,
        ),
      ];
}

import 'package:equatable/equatable.dart';
import '../../../domain/entities/room_entry.dart';

class RoomsState extends Equatable {
  final List<RoomEntry> rooms;
  const RoomsState({required this.rooms});

  RoomsState copyWith({List<RoomEntry>? rooms}) =>
      RoomsState(rooms: rooms ?? this.rooms);

  @override
  List<Object?> get props => [rooms];
}

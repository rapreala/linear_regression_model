import 'package:equatable/equatable.dart';
import '../../../domain/entities/room_entry.dart';

abstract class RoomsEvent extends Equatable {
  const RoomsEvent();
  @override
  List<Object?> get props => [];
}

class RoomAdded extends RoomsEvent {
  final RoomEntry room;
  const RoomAdded(this.room);
  @override
  List<Object?> get props => [room];
}

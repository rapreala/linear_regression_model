import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_theme.dart';
import '../../../domain/entities/room_entry.dart';
import '../../blocs/rooms/rooms_bloc.dart';
import '../../blocs/rooms/rooms_state.dart';
import 'add_room_screen.dart';

class ManageRoomsScreen extends StatelessWidget {
  const ManageRoomsScreen({super.key});

  void _navigateToAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddRoomScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Rooms'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => _navigateToAdd(context),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Room'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<RoomsBloc, RoomsState>(
        builder: (context, state) {
          if (state.rooms.isEmpty) {
            return _EmptyState(onAdd: () => _navigateToAdd(context));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: state.rooms.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _RoomCard(room: state.rooms[i]),
          );
        },
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final RoomEntry room;
  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    final wasAdjusted = room.predictedPrice != null &&
        (room.finalPrice - room.predictedPrice!).abs() > 0.01;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.stone50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.stone200),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bed_rounded,
                    color: AppTheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppTheme.textPrimary)),
                    const SizedBox(height: 2),
                    Text(room.type,
                        style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${room.finalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text('/ night',
                      style: TextStyle(
                          color: AppTheme.textSecondary, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Pill(
                  icon: Icons.people_outline,
                  label: '${room.accommodates} guests'),
              _Pill(
                  icon: Icons.bedroom_parent_outlined,
                  label:
                      '${room.bedrooms} bed${room.bedrooms != 1 ? 's' : ''}'),
              _Pill(
                  icon: Icons.location_on_outlined, label: room.district),
              if (wasAdjusted)
                _Pill(
                  icon: Icons.tune_rounded,
                  label:
                      'AI \$${room.predictedPrice!.toStringAsFixed(0)} → adjusted',
                  highlight: true,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;

  const _Pill({
    required this.icon,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: highlight
            ? AppTheme.primary.withValues(alpha: 0.08)
            : AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: highlight
              ? AppTheme.primary.withValues(alpha: 0.3)
              : AppTheme.stone200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 13,
              color:
                  highlight ? AppTheme.primary : AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: highlight
                      ? AppTheme.primary
                      : AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bed_rounded,
                  color: AppTheme.primary, size: 36),
            ),
            const SizedBox(height: 18),
            const Text('No rooms yet',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 6),
            const Text(
              'Add your first room and get an AI-powered\nnightly price recommendation.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Your First Room'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../config/theme/app_theme.dart';
import 'add_room_screen.dart';

class _RoomEntry {
  final String name;
  final String type;
  final int accommodates;
  final int bedrooms;
  final String district;
  final double? predictedPrice;

  const _RoomEntry({
    required this.name,
    required this.type,
    required this.accommodates,
    required this.bedrooms,
    required this.district,
    this.predictedPrice,
  });
}

class ManageRoomsScreen extends StatefulWidget {
  const ManageRoomsScreen({super.key});

  @override
  State<ManageRoomsScreen> createState() => _ManageRoomsScreenState();
}

class _ManageRoomsScreenState extends State<ManageRoomsScreen> {
  final List<_RoomEntry> _rooms = [
    const _RoomEntry(
      name: 'Deluxe Suite 101',
      type: 'Hotel room',
      accommodates: 4,
      bedrooms: 2,
      district: 'Kimihurura',
      predictedPrice: 187.50,
    ),
    const _RoomEntry(
      name: 'Standard Room 201',
      type: 'Private room',
      accommodates: 2,
      bedrooms: 1,
      district: 'Remera',
      predictedPrice: 102.30,
    ),
  ];

  void _onRoomAdded(_RoomEntry room) => setState(() => _rooms.add(room));

  void _navigateToAdd() {
    Navigator.push<_RoomEntry>(
      context,
      MaterialPageRoute(builder: (_) => const AddRoomScreen()),
    ).then((room) {
      if (room != null) _onRoomAdded(room);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Rooms'),
        actions: [
          // Pill "Add room" button — matches outside-web CTA style
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: _navigateToAdd,
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
      body: _rooms.isEmpty
          ? _EmptyState(onAdd: _navigateToAdd)
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: _rooms.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _RoomCard(room: _rooms[i]),
            ),
    );
  }
}

// ── Room card — stone-50 bg, rounded-3xl border, matching outside-web list style
class _RoomCard extends StatelessWidget {
  final _RoomEntry room;
  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
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
              if (room.predictedPrice != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${room.predictedPrice!.toStringAsFixed(0)}',
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
  const _Pill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.stone200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppTheme.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary)),
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_theme.dart';
import '../../../core/constants/kigali_districts.dart';
import '../../../data/models/prediction_request_model.dart';
import '../../../data/repositories/prediction_repository_impl.dart';
import '../../../data/services/prediction_service.dart';
import '../../../domain/entities/room_entry.dart';
import '../../blocs/prediction/prediction_bloc.dart';
import '../../blocs/prediction/prediction_event.dart';
import '../../blocs/prediction/prediction_state.dart';
import '../../blocs/rooms/rooms_bloc.dart';
import '../../blocs/rooms/rooms_event.dart';
import '../../widgets/prediction_result_card.dart';

class AddRoomScreen extends StatelessWidget {
  const AddRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PredictionBloc(
        repository: PredictionRepositoryImpl(service: PredictionService()),
      ),
      child: const _AddRoomView(),
    );
  }
}

class _AddRoomView extends StatefulWidget {
  const _AddRoomView();

  @override
  State<_AddRoomView> createState() => _AddRoomViewState();
}

class _AddRoomViewState extends State<_AddRoomView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // ── Basic info ──────────────────────────────────────────────
  final _nameCtrl = TextEditingController();

  // ── Feature controllers (match API fields exactly) ──────────
  KigaliDistrict? _selectedDistrict;

  // room_type: 0=Entire home/apt | 1=Hotel room | 2=Private | 3=Shared
  int _roomType = 1;
  static const _roomTypeLabels = [
    'Entire home / apt',
    'Hotel room',
    'Private room',
    'Shared room',
  ];

  final _accommodatesCtrl = TextEditingController(text: '2');
  final _bedroomsCtrl = TextEditingController(text: '1');
  final _bathroomsCtrl = TextEditingController(text: '1.0');
  final _bedsCtrl = TextEditingController(text: '1');

  int _hostIsSuperhost = 0;
  final _reviewScoresCtrl = TextEditingController(text: '90.0');
  final _reviewsPerMonthCtrl = TextEditingController(text: '1.0');
  final _numberOfReviewsCtrl = TextEditingController(text: '10');
  final _minNightsCtrl = TextEditingController(text: '1');
  final _availability365Ctrl = TextEditingController(text: '200');
  int _instantBookable = 1;
  final _guestsIncludedCtrl = TextEditingController(text: '2');

  // Less-variable fields
  int _propertyType = 1;
  int _bedType = 0;
  int _hostResponseTime = 0;
  final _hostListingsCtrl = TextEditingController(text: '1');
  int _cancellationPolicy = 1;

  // ── Post-prediction: editable final price ───────────────────
  final _finalPriceCtrl = TextEditingController();
  double? _predictedPrice; // AI baseline, stored for the pill label

  @override
  void dispose() {
    _scrollController.dispose();
    _nameCtrl.dispose();
    _accommodatesCtrl.dispose();
    _bedroomsCtrl.dispose();
    _bathroomsCtrl.dispose();
    _bedsCtrl.dispose();
    _reviewScoresCtrl.dispose();
    _reviewsPerMonthCtrl.dispose();
    _numberOfReviewsCtrl.dispose();
    _minNightsCtrl.dispose();
    _availability365Ctrl.dispose();
    _guestsIncludedCtrl.dispose();
    _hostListingsCtrl.dispose();
    _finalPriceCtrl.dispose();
    super.dispose();
  }

  void _saveRoom() {
    final price = double.tryParse(_finalPriceCtrl.text.trim());
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid final price first')),
      );
      return;
    }

    final roomTypeLabel = _roomTypeLabels[_roomType];
    final room = RoomEntry(
      name: _nameCtrl.text.trim(),
      type: roomTypeLabel,
      accommodates: int.parse(_accommodatesCtrl.text.trim()),
      bedrooms: int.parse(_bedroomsCtrl.text.trim()),
      district: _selectedDistrict!.name,
      finalPrice: price,
      predictedPrice: _predictedPrice,
    );

    // Dispatch to the root RoomsBloc so the listing survives navigation
    context.read<RoomsBloc>().add(RoomAdded(room));
    Navigator.pop(context);
  }

  void _predict() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDistrict == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Kigali district')),
      );
      return;
    }

    final request = PredictionRequestModel(
      latitude: _selectedDistrict!.lat,
      longitude: _selectedDistrict!.lon,
      accommodates: int.parse(_accommodatesCtrl.text.trim()),
      bedrooms: int.parse(_bedroomsCtrl.text.trim()),
      bathrooms: double.parse(_bathroomsCtrl.text.trim()),
      beds: int.parse(_bedsCtrl.text.trim()),
      roomType: _roomType,
      hostIsSuperhost: _hostIsSuperhost,
      reviewScoresRating: double.parse(_reviewScoresCtrl.text.trim()),
      reviewsPerMonth: double.parse(_reviewsPerMonthCtrl.text.trim()),
      numberOfReviews: int.parse(_numberOfReviewsCtrl.text.trim()),
      minimumNights: int.parse(_minNightsCtrl.text.trim()),
      availability365: int.parse(_availability365Ctrl.text.trim()),
      instantBookable: _instantBookable,
      guestsIncluded: int.parse(_guestsIncludedCtrl.text.trim()),
      propertyType: _propertyType,
      bedType: _bedType,
      hostResponseTime: _hostResponseTime,
      calculatedHostListingsCount: int.parse(_hostListingsCtrl.text.trim()),
      cancellationPolicy: _cancellationPolicy,
    );

    // Reset any previous price so the save section hides until new result
    setState(() {
      _predictedPrice = null;
      _finalPriceCtrl.clear();
    });

    context.read<PredictionBloc>().add(PredictionRequested(request));

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Room')),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            // ── Room name ──────────────────────────────────────
            _SectionHeader(title: 'Room Details', icon: Icons.bed_rounded),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Room Name',
                hintText: 'e.g. Deluxe Suite 101',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a room name' : null,
            ),
            const SizedBox(height: 16),

            // ── Room type ──────────────────────────────────────
            _DropdownField<int>(
              label: 'Room Type',
              icon: Icons.category_outlined,
              value: _roomType,
              items: List.generate(
                _roomTypeLabels.length,
                (i) => DropdownMenuItem(value: i, child: Text(_roomTypeLabels[i])),
              ),
              onChanged: (v) => setState(() => _roomType = v!),
            ),
            const SizedBox(height: 16),

            // ── Location ───────────────────────────────────────
            _SectionHeader(title: 'Location', icon: Icons.location_on_outlined),
            const SizedBox(height: 12),
            _DropdownField<KigaliDistrict?>(
              label: 'Kigali District',
              icon: Icons.map_outlined,
              value: _selectedDistrict,
              hint: 'Select district',
              items: kKigaliDistricts.map((d) {
                return DropdownMenuItem(
                  value: d,
                  child: Row(
                    children: [
                      Expanded(child: Text(d.name)),
                      const SizedBox(width: 8),
                      Text(
                        d.tier,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedDistrict = v),
            ),
            if (_selectedDistrict != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(children: [
                  const Icon(Icons.info_outline,
                      size: 15, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Lat ${_selectedDistrict!.lat}  ·  Lon ${_selectedDistrict!.lon}',
                    style: const TextStyle(
                        fontSize: 12, color: AppTheme.primary),
                  ),
                ]),
              ),
            ],
            const SizedBox(height: 16),

            // ── Capacity ───────────────────────────────────────
            _SectionHeader(
                title: 'Capacity & Beds', icon: Icons.people_outline),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _NumField(
                  ctrl: _accommodatesCtrl,
                  label: 'Accommodates',
                  hint: '1–16',
                  min: 1,
                  max: 16,
                  isInt: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NumField(
                  ctrl: _bedroomsCtrl,
                  label: 'Bedrooms',
                  hint: '0–10',
                  min: 0,
                  max: 10,
                  isInt: true,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _NumField(
                  ctrl: _bathroomsCtrl,
                  label: 'Bathrooms',
                  hint: '0.5–8',
                  min: 0,
                  max: 8,
                  isInt: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NumField(
                  ctrl: _bedsCtrl,
                  label: 'Beds',
                  hint: '1–20',
                  min: 1,
                  max: 20,
                  isInt: true,
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // ── Guests & terms ─────────────────────────────────
            _SectionHeader(
                title: 'Booking Terms', icon: Icons.calendar_today_outlined),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _NumField(
                  ctrl: _guestsIncludedCtrl,
                  label: 'Guests Included',
                  hint: '1–16',
                  min: 1,
                  max: 16,
                  isInt: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NumField(
                  ctrl: _minNightsCtrl,
                  label: 'Min Nights',
                  hint: '1–365',
                  min: 1,
                  max: 365,
                  isInt: true,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            _NumField(
              ctrl: _availability365Ctrl,
              label: 'Availability (days/year)',
              hint: '0–365',
              min: 0,
              max: 365,
              isInt: true,
            ),
            const SizedBox(height: 12),
            _ToggleField(
              label: 'Instant Bookable',
              value: _instantBookable == 1,
              onChanged: (v) => setState(() => _instantBookable = v ? 1 : 0),
            ),
            const SizedBox(height: 16),

            // ── Reviews ────────────────────────────────────────
            _SectionHeader(
                title: 'Reviews & Rating', icon: Icons.star_outline_rounded),
            const SizedBox(height: 12),
            _NumField(
              ctrl: _reviewScoresCtrl,
              label: 'Review Score (20–100)',
              hint: 'e.g. 90.0',
              min: 20,
              max: 100,
              isInt: false,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: _NumField(
                  ctrl: _numberOfReviewsCtrl,
                  label: 'No. of Reviews',
                  hint: '0–1000',
                  min: 0,
                  max: 1000,
                  isInt: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NumField(
                  ctrl: _reviewsPerMonthCtrl,
                  label: 'Reviews / Month',
                  hint: '0–30',
                  min: 0,
                  max: 30,
                  isInt: false,
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // ── Host profile ───────────────────────────────────
            _SectionHeader(
                title: 'Host Profile', icon: Icons.person_outline_rounded),
            const SizedBox(height: 12),
            _ToggleField(
              label: 'Superhost Status',
              value: _hostIsSuperhost == 1,
              onChanged: (v) => setState(() => _hostIsSuperhost = v ? 1 : 0),
            ),
            const SizedBox(height: 12),
            _NumField(
              ctrl: _hostListingsCtrl,
              label: 'Host Total Listings',
              hint: '1–300',
              min: 1,
              max: 300,
              isInt: true,
            ),
            const SizedBox(height: 12),
            _DropdownField<int>(
              label: 'Host Response Time',
              icon: Icons.schedule_outlined,
              value: _hostResponseTime,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Within an hour')),
                DropdownMenuItem(value: 1, child: Text('Within a few hours')),
                DropdownMenuItem(value: 2, child: Text('Within a day')),
                DropdownMenuItem(value: 3, child: Text('A few days or more')),
                DropdownMenuItem(value: 4, child: Text('Unknown')),
              ],
              onChanged: (v) => setState(() => _hostResponseTime = v!),
            ),
            const SizedBox(height: 16),

            // ── Property details ───────────────────────────────
            _SectionHeader(
                title: 'Property Details', icon: Icons.apartment_outlined),
            const SizedBox(height: 12),
            _DropdownField<int>(
              label: 'Property Type',
              icon: Icons.home_outlined,
              value: _propertyType,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Apartment')),
                DropdownMenuItem(value: 1, child: Text('House')),
                DropdownMenuItem(value: 2, child: Text('Hotel')),
                DropdownMenuItem(value: 3, child: Text('Hostel')),
                DropdownMenuItem(value: 4, child: Text('Guest suite')),
                DropdownMenuItem(value: 5, child: Text('Guesthouse')),
                DropdownMenuItem(value: 6, child: Text('Bed & Breakfast')),
                DropdownMenuItem(value: 7, child: Text('Boutique hotel')),
                DropdownMenuItem(value: 8, child: Text('Loft')),
                DropdownMenuItem(value: 9, child: Text('Villa')),
              ],
              onChanged: (v) => setState(() => _propertyType = v!),
            ),
            const SizedBox(height: 12),
            _DropdownField<int>(
              label: 'Bed Type',
              icon: Icons.bed_outlined,
              value: _bedType,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Real Bed')),
                DropdownMenuItem(value: 1, child: Text('Pull-out Sofa')),
                DropdownMenuItem(value: 2, child: Text('Futon')),
                DropdownMenuItem(value: 3, child: Text('Couch')),
                DropdownMenuItem(value: 4, child: Text('Airbed')),
              ],
              onChanged: (v) => setState(() => _bedType = v!),
            ),
            const SizedBox(height: 12),
            _DropdownField<int>(
              label: 'Cancellation Policy',
              icon: Icons.cancel_outlined,
              value: _cancellationPolicy,
              items: const [
                DropdownMenuItem(value: 0, child: Text('Flexible')),
                DropdownMenuItem(value: 1, child: Text('Moderate')),
                DropdownMenuItem(value: 2, child: Text('Strict')),
                DropdownMenuItem(value: 3, child: Text('Super strict 30')),
                DropdownMenuItem(value: 4, child: Text('Super strict 60')),
              ],
              onChanged: (v) => setState(() => _cancellationPolicy = v!),
            ),
            const SizedBox(height: 28),

            // ── Predict button ─────────────────────────────────
            BlocBuilder<PredictionBloc, PredictionState>(
              builder: (context, state) {
                return ElevatedButton.icon(
                  onPressed: state is PredictionLoading ? null : _predict,
                  icon: state is PredictionLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_graph_rounded),
                  label: Text(state is PredictionLoading
                      ? 'Predicting…'
                      : 'Predict Optimal Room Price'),
                );
              },
            ),
            const SizedBox(height: 20),

            // ── Result / error / save area ─────────────────────
            BlocConsumer<PredictionBloc, PredictionState>(
              listener: (context, state) {
                if (state is PredictionSuccess) {
                  // Pre-fill editable price with AI suggestion
                  final price = state.result.predictedUsdNight;
                  setState(() {
                    _predictedPrice = price;
                    _finalPriceCtrl.text =
                        price.toStringAsFixed(2);
                  });
                }
              },
              builder: (context, state) {
                if (state is PredictionLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is PredictionFailure) {
                  return _ErrorBanner(message: state.message);
                }
                if (state is PredictionSuccess) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PredictionResultCard(result: state.result),
                      const SizedBox(height: 20),

                      // ── Editable final price ────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.stone50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.stone200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.tune_rounded,
                                    size: 16,
                                    color: AppTheme.primary),
                                SizedBox(width: 8),
                                Text(
                                  'Adjust Your Final Price',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'The AI gives you a data-anchored baseline. '
                              'Apply your local knowledge and adjust below.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _finalPriceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              decoration: const InputDecoration(
                                labelText: 'Final Nightly Price (USD)',
                                prefixIcon: Icon(Icons.attach_money),
                                hintText: 'e.g. 150.00',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // ── Save room button ────────────────────
                      ElevatedButton.icon(
                        onPressed: _saveRoom,
                        icon: const Icon(Icons.check_circle_outline,
                            size: 18),
                        label: const Text('Save Room'),
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Reusable form widgets ────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _NumField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final num min;
  final num max;
  final bool isInt;

  const _NumField({
    required this.ctrl,
    required this.label,
    required this.hint,
    required this.min,
    required this.max,
    required this.isInt,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      ],
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Required';
        final n = num.tryParse(v.trim());
        if (n == null) return 'Enter a number';
        if (n < min || n > max) return '$min – $max';
        return null;
      },
    );
  }
}

class _ToggleField extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.stone200),
      ),
      child: SwitchListTile(
        title: Text(label, style: const TextStyle(fontSize: 14)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppTheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? hint;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        hintText: hint,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.error, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Prediction Error',
                    style: TextStyle(
                        color: AppTheme.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 4),
                Text(message,
                    style: const TextStyle(
                        color: AppTheme.error, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

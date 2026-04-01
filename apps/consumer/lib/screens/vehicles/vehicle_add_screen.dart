import 'package:consumer/auth_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oc_ui/oc_ui.dart';

const _addCarHeroAsset = 'assets/images/add_car_hero.png';

const _brands = <String>[
  'BMW',
  'Mercedes-Benz',
  'Toyota',
  'Hyundai',
  'Tesla',
];

const _brandModels = <String, List<String>>{
  'BMW': ['3 Series', '5 Series', 'X3', 'X5'],
  'Mercedes-Benz': ['C-Class', 'E-Class', 'GLC', 'GLE'],
  'Toyota': ['Corolla', 'Camry', 'RAV4', 'Land Cruiser'],
  'Hyundai': ['Elantra', 'Sonata', 'Tucson', 'Santa Fe'],
  'Tesla': ['Model 3', 'Model Y', 'Model S', 'Model X'],
};

class VehicleAddScreen extends ConsumerStatefulWidget {
  const VehicleAddScreen({super.key});

  @override
  ConsumerState<VehicleAddScreen> createState() => _VehicleAddScreenState();
}

class _VehicleAddScreenState extends ConsumerState<VehicleAddScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _plateController;
  late final TextEditingController _vinController;
  late final AnimationController _controller;
  EngineType? _engineType;

  List<int> get _years => [
        for (int year = DateTime.now().year; year >= 1990; year--) year,
      ];

  @override
  void initState() {
    super.initState();
    final vehicle = ref.read(authFlowProvider).vehicle;
    _brandController = TextEditingController(text: vehicle.brand ?? '');
    _modelController = TextEditingController(text: vehicle.model ?? '');
    _yearController = TextEditingController(
      text: vehicle.year?.toString() ?? '',
    );
    _plateController = TextEditingController(text: vehicle.plate);
    _vinController = TextEditingController(text: vehicle.vin);
    _engineType = vehicle.engineType;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    )..forward();
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    _vinController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickBrand() async {
    final selected = await _showPicker<String>(
      title: 'Select Brand',
      options: _brands,
      labelBuilder: (value) => value,
    );
    if (selected == null) {
      return;
    }

    setState(() {
      _brandController.text = selected;
      if (!_brandModels[selected]!.contains(_modelController.text)) {
        _modelController.clear();
      }
    });
  }

  Future<void> _pickModel() async {
    final brand = _brandController.text.trim();
    if (brand.isEmpty) {
      await _pickBrand();
      return;
    }

    final models = _brandModels[brand] ?? const <String>[];
    final selected = await _showPicker<String>(
      title: 'Select Model',
      options: models,
      labelBuilder: (value) => value,
    );
    if (selected != null) {
      setState(() => _modelController.text = selected);
    }
  }

  Future<void> _pickYear() async {
    final selected = await _showPicker<int>(
      title: 'Select Year',
      options: _years,
      labelBuilder: (value) => '$value',
    );
    if (selected != null) {
      setState(() => _yearController.text = '$selected');
    }
  }

  Future<T?> _showPicker<T>({
    required String title,
    required List<T> options,
    required String Function(T value) labelBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 72,
                    height: 5,
                    decoration: BoxDecoration(
                      color: OcColors.textMuted.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF17314F),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: Color(0xFFE5EAF2)),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      return ListTile(
                        title: Text(
                          labelBuilder(option),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF17314F),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF7A8796),
                        ),
                        onTap: () => Navigator.of(context).pop(option),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit() {
    final brand = _brandController.text.trim();
    final model = _modelController.text.trim();
    final year = int.tryParse(_yearController.text.trim());
    final plate = _plateController.text.trim();
    final vin = _vinController.text.trim();

    final formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid || year == null || _engineType == null) {
      setState(() {});
      return;
    }

    ref.read(authFlowProvider.notifier).setVehicle(
          VehicleDraft(
            brand: brand,
            model: model,
            year: year,
            engineType: _engineType,
            plate: plate,
            vin: vin,
          ),
        );
    context.go('/auth/complete');
  }

  void _skipForNow() {
    ref.read(authFlowProvider.notifier).skipVehicle();
    context.go('/auth/complete');
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final value = disableAnimations
                    ? 1.0
                    : Curves.easeOutCubic.transform(_controller.value);
                return Transform.translate(
                  offset: Offset(0, disableAnimations ? 0 : 28 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        OcCircleBackButton(
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                              return;
                            }
                            context.go('/auth/sign-up');
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Add Your Car',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF17314F),
                              letterSpacing: -0.05,
                            ),
                          ),
                        ),
                        const SizedBox(width: 72),
                      ],
                    ),
                    const SizedBox(height: 26),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Stack(
                        children: [
                          OcImmersiveHeroBackground(
                            assetPath: _addCarHeroAsset,
                            heroTag: 'addCarHero',
                            height: 220,
                            fallbackIcon: Icons.directions_car_filled_rounded,
                            fallbackColors: const [
                              Color(0xFF5A0C0C),
                              Color(0xFF971D18),
                              Color(0xFFC54322),
                            ],
                            overlayGradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.06),
                                Colors.black.withValues(alpha: 0.14),
                                Colors.black.withValues(alpha: 0.6),
                              ],
                              stops: const [0, 0.42, 1],
                            ),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.28),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.add_photo_alternate_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Add Your Car',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.05,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Get personalized services & parts',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: Colors.white.withValues(alpha: 0.96),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: -0.02,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    OcAnimatedAuthField(
                      key: const Key('vehicleBrandField'),
                      label: '',
                      controller: _brandController,
                      hintText: 'Select Brand',
                      readOnly: true,
                      onTap: _pickBrand,
                      prefix: const _PickerPrefixIcon(),
                      suffix: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 34,
                        color: Color(0xFF2F3640),
                      ),
                      validator: (value) =>
                          (value?.trim().isEmpty ?? true) ? 'Select a brand' : null,
                    ),
                    const SizedBox(height: 22),
                    OcAnimatedAuthField(
                      key: const Key('vehicleModelField'),
                      label: '',
                      controller: _modelController,
                      hintText: 'Select Model',
                      readOnly: true,
                      onTap: _pickModel,
                      prefix: const _PickerPrefixIcon(),
                      suffix: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 34,
                        color: Color(0xFF2F3640),
                      ),
                      validator: (value) =>
                          (value?.trim().isEmpty ?? true) ? 'Select a model' : null,
                    ),
                    const SizedBox(height: 22),
                    OcAnimatedAuthField(
                      key: const Key('vehicleYearField'),
                      label: '',
                      controller: _yearController,
                      hintText: 'Select Year',
                      readOnly: true,
                      onTap: _pickYear,
                      prefix: const _PickerPrefixIcon(),
                      suffix: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 34,
                        color: Color(0xFF2F3640),
                      ),
                      validator: (value) =>
                          (value?.trim().isEmpty ?? true) ? 'Select a year' : null,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Engine Type',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: OcColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    OcEngineTypeChips<EngineType>(
                      options: EngineType.values,
                      selected: _engineType,
                      labelBuilder: (value) => value.label,
                      onSelected: (value) => setState(() => _engineType = value),
                    ),
                    if (_engineType == null) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Select an engine type',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    Text(
                      'Confirm Plate',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: OcColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    OcAnimatedAuthField(
                      key: const Key('vehiclePlateField'),
                      label: '',
                      controller: _plateController,
                      hintText: 'DOHA-1321',
                      textInputAction: TextInputAction.next,
                      prefix: const _PickerPrefixIcon(),
                      suffix: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 14),
                        child: Align(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFBEBEBE),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Scan Plate',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      validator: (value) =>
                          (value?.trim().isEmpty ?? true) ? 'Enter a plate number' : null,
                    ),
                    const SizedBox(height: 20),
                    OcAnimatedAuthField(
                      key: const Key('vehicleVinField'),
                      label: '',
                      controller: _vinController,
                      hintText: 'Vehicle Identification Number (Optional)',
                      maxLines: 1,
                      suffix: const Padding(
                        padding: EdgeInsetsDirectional.only(end: 16),
                        child: Align(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: Icon(
                            Icons.error_outline_rounded,
                            color: Color(0xFF2F3640),
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: const Color(0xFFD8DCE3),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Used for accurate parts match',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF8E8E8E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    OcPillButton(
                      key: const Key('vehicleAddSubmitButton'),
                      label: 'Add Car',
                      filled: true,
                      width: double.infinity,
                      height: 78,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      key: const Key('vehicleSkipButton'),
                      onPressed: _skipForNow,
                      child: Text(
                        'Skip for now',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: OcColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerPrefixIcon extends StatelessWidget {
  const _PickerPrefixIcon();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
      child: Align(
        widthFactor: 1,
        heightFactor: 1,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE8EEF8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.directions_car_filled_rounded,
            color: Color(0xFF17314F),
            size: 24,
          ),
        ),
      ),
    );
  }
}

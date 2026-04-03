import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum DriverVehicleType {
  car(Icons.directions_car_filled_rounded),
  motorcycle(Icons.two_wheeler_rounded),
  van(Icons.airport_shuttle_rounded);

  const DriverVehicleType(this.icon);

  final IconData icon;
}

enum DriverServiceArea {
  downtownDistrict,
  industrialArea,
  westBay,
  alSadd,
  airportZone,
}

@immutable
class DriverRegistrationDraft {
  const DriverRegistrationDraft({
    this.fullName = '',
    this.phone = '',
    this.vehicleType,
    this.serviceArea,
    this.driversLicenseImagePath,
    this.acceptedPrivacy = false,
  });

  final String fullName;
  final String phone;
  final DriverVehicleType? vehicleType;
  final DriverServiceArea? serviceArea;
  final String? driversLicenseImagePath;
  final bool acceptedPrivacy;

  bool get hasDraft =>
      fullName.trim().isNotEmpty ||
      phone.trim().isNotEmpty ||
      vehicleType != null ||
      serviceArea != null ||
      driversLicenseImagePath != null;

  DriverRegistrationDraft copyWith({
    String? fullName,
    String? phone,
    DriverVehicleType? vehicleType,
    bool clearVehicleType = false,
    DriverServiceArea? serviceArea,
    bool clearServiceArea = false,
    String? driversLicenseImagePath,
    bool clearDriversLicenseImage = false,
    bool? acceptedPrivacy,
  }) {
    return DriverRegistrationDraft(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      vehicleType: clearVehicleType ? null : vehicleType ?? this.vehicleType,
      serviceArea: clearServiceArea ? null : serviceArea ?? this.serviceArea,
      driversLicenseImagePath: clearDriversLicenseImage
          ? null
          : driversLicenseImagePath ?? this.driversLicenseImagePath,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
    );
  }
}

class DriverRegistrationDraftNotifier
    extends Notifier<DriverRegistrationDraft> {
  @override
  DriverRegistrationDraft build() => const DriverRegistrationDraft();

  void saveDraft(DriverRegistrationDraft draft) {
    state = draft;
  }

  void clear() {
    state = const DriverRegistrationDraft();
  }
}

final driverRegistrationDraftProvider =
    NotifierProvider<DriverRegistrationDraftNotifier, DriverRegistrationDraft>(
      DriverRegistrationDraftNotifier.new,
    );

abstract class DriverLicensePicker {
  Future<String?> pickImage({required ImageSource source});
}

class DeviceDriverLicensePicker implements DriverLicensePicker {
  DeviceDriverLicensePicker({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();

  final ImagePicker _imagePicker;

  @override
  Future<String?> pickImage({required ImageSource source}) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 88,
    );
    return image?.path;
  }
}

final driverLicensePickerProvider = Provider<DriverLicensePicker>(
  (_) => DeviceDriverLicensePicker(),
);

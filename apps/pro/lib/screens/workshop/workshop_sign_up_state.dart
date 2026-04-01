import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum WorkshopSpecialty {
  engine(Icons.engineering_rounded),
  electrical(Icons.bolt_rounded),
  tires(Icons.tire_repair_rounded),
  paint(Icons.format_paint_rounded),
  oil(Icons.oil_barrel_rounded),
  other(Icons.add_rounded);

  const WorkshopSpecialty(this.icon);

  final IconData icon;
}

@immutable
class WorkshopRegistrationDraft {
  const WorkshopRegistrationDraft({
    this.workshopName = '',
    this.ownerName = '',
    this.phone = '',
    this.location = '',
    this.selectedSpecialties = const <WorkshopSpecialty>{},
    this.tradeLicenseImagePath,
    this.acceptedPrivacy = false,
  });

  final String workshopName;
  final String ownerName;
  final String phone;
  final String location;
  final Set<WorkshopSpecialty> selectedSpecialties;
  final String? tradeLicenseImagePath;
  final bool acceptedPrivacy;

  bool get hasDraft =>
      workshopName.trim().isNotEmpty ||
      ownerName.trim().isNotEmpty ||
      phone.trim().isNotEmpty ||
      location.trim().isNotEmpty ||
      selectedSpecialties.isNotEmpty ||
      tradeLicenseImagePath != null;

  WorkshopRegistrationDraft copyWith({
    String? workshopName,
    String? ownerName,
    String? phone,
    String? location,
    Set<WorkshopSpecialty>? selectedSpecialties,
    String? tradeLicenseImagePath,
    bool clearTradeLicenseImage = false,
    bool? acceptedPrivacy,
  }) {
    return WorkshopRegistrationDraft(
      workshopName: workshopName ?? this.workshopName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      selectedSpecialties: Set.unmodifiable(
        selectedSpecialties ?? this.selectedSpecialties,
      ),
      tradeLicenseImagePath: clearTradeLicenseImage
          ? null
          : tradeLicenseImagePath ?? this.tradeLicenseImagePath,
      acceptedPrivacy: acceptedPrivacy ?? this.acceptedPrivacy,
    );
  }
}

class WorkshopRegistrationDraftNotifier
    extends Notifier<WorkshopRegistrationDraft> {
  @override
  WorkshopRegistrationDraft build() => const WorkshopRegistrationDraft();

  void saveDraft(WorkshopRegistrationDraft draft) {
    state = draft;
  }

  void setAcceptedPrivacy(bool value) {
    state = state.copyWith(acceptedPrivacy: value);
  }

  void clear() {
    state = const WorkshopRegistrationDraft();
  }
}

final workshopRegistrationDraftProvider =
    NotifierProvider<
      WorkshopRegistrationDraftNotifier,
      WorkshopRegistrationDraft
    >(WorkshopRegistrationDraftNotifier.new);

abstract class WorkshopTradeLicensePicker {
  Future<String?> pickImage({required ImageSource source});
}

class DeviceWorkshopTradeLicensePicker implements WorkshopTradeLicensePicker {
  DeviceWorkshopTradeLicensePicker({ImagePicker? imagePicker})
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

final workshopTradeLicensePickerProvider = Provider<WorkshopTradeLicensePicker>(
  (_) => DeviceWorkshopTradeLicensePicker(),
);

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../discovery/discovery_content.dart';

class RoadsideRequestDraft {
  const RoadsideRequestDraft({
    this.context = RoadsideRequestContext.roadside,
    this.selectedWorkshopId,
    this.selectedWorkshopName,
    this.selectedVehicleId,
    this.breakdownLocation = '',
    this.issueNote = '',
    this.returnDropOff = true,
    this.estimatedTowingFee = 250,
  });

  final RoadsideRequestContext context;
  final String? selectedWorkshopId;
  final String? selectedWorkshopName;
  final String? selectedVehicleId;
  final String breakdownLocation;
  final String issueNote;
  final bool returnDropOff;
  final double estimatedTowingFee;

  bool get canSubmit =>
      selectedWorkshopId != null &&
      selectedVehicleId != null &&
      breakdownLocation.trim().isNotEmpty;

  RoadsideRequestDraft copyWith({
    RoadsideRequestContext? context,
    String? selectedWorkshopId,
    String? selectedWorkshopName,
    String? selectedVehicleId,
    String? breakdownLocation,
    String? issueNote,
    bool? returnDropOff,
    double? estimatedTowingFee,
    bool clearWorkshop = false,
    bool clearVehicle = false,
  }) {
    return RoadsideRequestDraft(
      context: context ?? this.context,
      selectedWorkshopId: clearWorkshop
          ? null
          : selectedWorkshopId ?? this.selectedWorkshopId,
      selectedWorkshopName: clearWorkshop
          ? null
          : selectedWorkshopName ?? this.selectedWorkshopName,
      selectedVehicleId: clearVehicle
          ? null
          : selectedVehicleId ?? this.selectedVehicleId,
      breakdownLocation: breakdownLocation ?? this.breakdownLocation,
      issueNote: issueNote ?? this.issueNote,
      returnDropOff: returnDropOff ?? this.returnDropOff,
      estimatedTowingFee: estimatedTowingFee ?? this.estimatedTowingFee,
    );
  }
}

class SubmittedRoadsideRequest {
  const SubmittedRoadsideRequest({
    required this.id,
    required this.createdAt,
    required this.context,
    required this.workshopId,
    required this.workshopName,
    required this.vehicleName,
    required this.plateNumber,
    required this.breakdownLocation,
    required this.issueNote,
    required this.returnDropOff,
    required this.estimatedTowingFee,
    required this.pickupEstimateMinutes,
    required this.capacityLabel,
    required this.specialtyLabel,
    this.imageUrl,
  });

  final String id;
  final DateTime createdAt;
  final RoadsideRequestContext context;
  final String workshopId;
  final String workshopName;
  final String vehicleName;
  final String plateNumber;
  final String breakdownLocation;
  final String issueNote;
  final bool returnDropOff;
  final double estimatedTowingFee;
  final int pickupEstimateMinutes;
  final String capacityLabel;
  final String specialtyLabel;
  final String? imageUrl;
}

class RoadsideRequestState {
  const RoadsideRequestState({
    this.draft = const RoadsideRequestDraft(),
    this.submittedRequests = const [],
  });

  final RoadsideRequestDraft draft;
  final List<SubmittedRoadsideRequest> submittedRequests;

  RoadsideRequestState copyWith({
    RoadsideRequestDraft? draft,
    List<SubmittedRoadsideRequest>? submittedRequests,
  }) {
    return RoadsideRequestState(
      draft: draft ?? this.draft,
      submittedRequests: submittedRequests ?? this.submittedRequests,
    );
  }
}

class RoadsideRequestNotifier extends Notifier<RoadsideRequestState> {
  @override
  RoadsideRequestState build() => const RoadsideRequestState();

  void setContext(RoadsideRequestContext context) {
    state = state.copyWith(draft: state.draft.copyWith(context: context));
  }

  void selectWorkshop({
    required String workshopId,
    required String workshopName,
  }) {
    state = state.copyWith(
      draft: state.draft.copyWith(
        selectedWorkshopId: workshopId,
        selectedWorkshopName: workshopName,
      ),
    );
  }

  void selectVehicle(String vehicleId) {
    state = state.copyWith(
      draft: state.draft.copyWith(selectedVehicleId: vehicleId),
    );
  }

  void setBreakdownLocation(String value) {
    state = state.copyWith(
      draft: state.draft.copyWith(breakdownLocation: value),
    );
  }

  void setIssueNote(String value) {
    state = state.copyWith(draft: state.draft.copyWith(issueNote: value));
  }

  void setReturnDropOff(bool value) {
    state = state.copyWith(
      draft: state.draft.copyWith(returnDropOff: value),
    );
  }

  void prefillBreakdownLocation(String value) {
    if (state.draft.breakdownLocation.trim().isNotEmpty || value.trim().isEmpty) {
      return;
    }
    setBreakdownLocation(value);
  }

  void prefillVehicle(String? vehicleId) {
    if (state.draft.selectedVehicleId != null || vehicleId == null) {
      return;
    }
    selectVehicle(vehicleId);
  }

  void submit({
    required String workshopId,
    required String workshopName,
    required String vehicleName,
    required String plateNumber,
    required int pickupEstimateMinutes,
    required String capacityLabel,
    required String specialtyLabel,
    String? imageUrl,
  }) {
    final timestamp = DateTime.now();
    final request = SubmittedRoadsideRequest(
      id: 'rr-${timestamp.microsecondsSinceEpoch}',
      createdAt: timestamp,
      context: state.draft.context,
      workshopId: workshopId,
      workshopName: workshopName,
      vehicleName: vehicleName,
      plateNumber: plateNumber,
      breakdownLocation: state.draft.breakdownLocation.trim(),
      issueNote: state.draft.issueNote.trim(),
      returnDropOff: state.draft.returnDropOff,
      estimatedTowingFee: state.draft.estimatedTowingFee,
      pickupEstimateMinutes: pickupEstimateMinutes,
      capacityLabel: capacityLabel,
      specialtyLabel: specialtyLabel,
      imageUrl: imageUrl,
    );

    state = state.copyWith(
      draft: RoadsideRequestDraft(context: state.draft.context),
      submittedRequests: [request, ...state.submittedRequests],
    );
  }

  void clearDraft() {
    state = state.copyWith(draft: const RoadsideRequestDraft());
  }
}

final roadsideRequestProvider =
    NotifierProvider<RoadsideRequestNotifier, RoadsideRequestState>(
      RoadsideRequestNotifier.new,
    );

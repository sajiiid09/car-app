import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum WorkshopShellTab { dashboard, jobs, messages, profile }

enum WorkshopJobsFilter {
  all('all'),
  newRequests('new'),
  approval('approval'),
  handover('handover');

  const WorkshopJobsFilter(this.queryValue);

  final String queryValue;

  static WorkshopJobsFilter fromQuery(String? value) {
    return WorkshopJobsFilter.values.firstWhere(
      (filter) => filter.queryValue == value,
      orElse: () => WorkshopJobsFilter.all,
    );
  }
}

enum WorkshopJobStage {
  newRequest,
  driverAssignment,
  incomingTracking,
  activeJob,
  approvalPending,
  serviceInProgress,
  handoverPrep,
  requestReturnDelivery,
  returnTracking,
  completed,
}

enum WorkshopHandoverMode { workshopDriver, customerPickup }

@immutable
class WorkshopDiagnosisDraft {
  const WorkshopDiagnosisDraft({
    this.summary = '',
    this.notes = '',
    this.laborCost = 0,
    this.partsCost = 0,
    this.photoUrls = const <String>[],
  });

  final String summary;
  final String notes;
  final double laborCost;
  final double partsCost;
  final List<String> photoUrls;

  double get totalCost => laborCost + partsCost;

  WorkshopDiagnosisDraft copyWith({
    String? summary,
    String? notes,
    double? laborCost,
    double? partsCost,
    List<String>? photoUrls,
  }) {
    return WorkshopDiagnosisDraft(
      summary: summary ?? this.summary,
      notes: notes ?? this.notes,
      laborCost: laborCost ?? this.laborCost,
      partsCost: partsCost ?? this.partsCost,
      photoUrls: photoUrls ?? this.photoUrls,
    );
  }
}

@immutable
class WorkshopDriverAssignment {
  const WorkshopDriverAssignment({
    required this.name,
    required this.phone,
    required this.vehicleLabel,
    required this.etaMinutes,
    required this.note,
    this.avatarUrl,
  });

  final String name;
  final String phone;
  final String vehicleLabel;
  final int etaMinutes;
  final String note;
  final String? avatarUrl;
}

@immutable
class WorkshopJobRecord {
  const WorkshopJobRecord({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.vehicleName,
    required this.licensePlate,
    required this.location,
    required this.issueSummary,
    required this.statusHeadline,
    required this.statusBody,
    required this.distanceLabel,
    required this.requestedAtLabel,
    required this.requestTypeLabel,
    required this.specialtyLabel,
    required this.capacityLabel,
    required this.imageUrl,
    required this.rating,
    required this.stage,
    this.discountLabel,
    this.pickupEstimateMinutes = 20,
    this.driverAssignment,
    this.diagnosisDraft = const WorkshopDiagnosisDraft(),
    this.handoverMode,
    this.requiresApproval = false,
    this.returnRequested = false,
  });

  final String id;
  final String customerName;
  final String customerPhone;
  final String vehicleName;
  final String licensePlate;
  final String location;
  final String issueSummary;
  final String statusHeadline;
  final String statusBody;
  final String distanceLabel;
  final String requestedAtLabel;
  final String requestTypeLabel;
  final String specialtyLabel;
  final String capacityLabel;
  final String imageUrl;
  final double rating;
  final WorkshopJobStage stage;
  final String? discountLabel;
  final int pickupEstimateMinutes;
  final WorkshopDriverAssignment? driverAssignment;
  final WorkshopDiagnosisDraft diagnosisDraft;
  final WorkshopHandoverMode? handoverMode;
  final bool requiresApproval;
  final bool returnRequested;

  bool get isActive =>
      stage != WorkshopJobStage.completed &&
      stage != WorkshopJobStage.handoverPrep &&
      stage != WorkshopJobStage.approvalPending;

  WorkshopJobRecord copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? vehicleName,
    String? licensePlate,
    String? location,
    String? issueSummary,
    String? statusHeadline,
    String? statusBody,
    String? distanceLabel,
    String? requestedAtLabel,
    String? requestTypeLabel,
    String? specialtyLabel,
    String? capacityLabel,
    String? imageUrl,
    double? rating,
    WorkshopJobStage? stage,
    String? discountLabel,
    int? pickupEstimateMinutes,
    WorkshopDriverAssignment? driverAssignment,
    WorkshopDiagnosisDraft? diagnosisDraft,
    WorkshopHandoverMode? handoverMode,
    bool clearHandoverMode = false,
    bool? requiresApproval,
    bool? returnRequested,
  }) {
    return WorkshopJobRecord(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      vehicleName: vehicleName ?? this.vehicleName,
      licensePlate: licensePlate ?? this.licensePlate,
      location: location ?? this.location,
      issueSummary: issueSummary ?? this.issueSummary,
      statusHeadline: statusHeadline ?? this.statusHeadline,
      statusBody: statusBody ?? this.statusBody,
      distanceLabel: distanceLabel ?? this.distanceLabel,
      requestedAtLabel: requestedAtLabel ?? this.requestedAtLabel,
      requestTypeLabel: requestTypeLabel ?? this.requestTypeLabel,
      specialtyLabel: specialtyLabel ?? this.specialtyLabel,
      capacityLabel: capacityLabel ?? this.capacityLabel,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      stage: stage ?? this.stage,
      discountLabel: discountLabel ?? this.discountLabel,
      pickupEstimateMinutes: pickupEstimateMinutes ?? this.pickupEstimateMinutes,
      driverAssignment: driverAssignment ?? this.driverAssignment,
      diagnosisDraft: diagnosisDraft ?? this.diagnosisDraft,
      handoverMode: clearHandoverMode
          ? null
          : handoverMode ?? this.handoverMode,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      returnRequested: returnRequested ?? this.returnRequested,
    );
  }
}

@immutable
class WorkshopProfileState {
  const WorkshopProfileState({
    required this.workshopName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.specialties,
    required this.operatingHours,
    required this.currentBalanceLabel,
    required this.pendingPayoutLabel,
    required this.monthlyRevenueLabel,
    required this.completionRateLabel,
    required this.responseTimeLabel,
    required this.bankLabel,
    required this.ibanLabel,
    required this.avatarUrl,
    required this.coverImageUrl,
    required this.mapImageUrl,
  });

  final String workshopName;
  final String ownerName;
  final String email;
  final String phone;
  final String address;
  final List<String> specialties;
  final String operatingHours;
  final String currentBalanceLabel;
  final String pendingPayoutLabel;
  final String monthlyRevenueLabel;
  final String completionRateLabel;
  final String responseTimeLabel;
  final String bankLabel;
  final String ibanLabel;
  final String avatarUrl;
  final String coverImageUrl;
  final String mapImageUrl;
}

@immutable
class WorkshopWorkflowState {
  const WorkshopWorkflowState({
    required this.jobs,
    required this.profile,
  });

  final List<WorkshopJobRecord> jobs;
  final WorkshopProfileState profile;

  WorkshopJobRecord? jobById(String id) {
    try {
      return jobs.firstWhere((job) => job.id == id);
    } catch (_) {
      return null;
    }
  }

  WorkshopWorkflowState copyWith({
    List<WorkshopJobRecord>? jobs,
    WorkshopProfileState? profile,
  }) {
    return WorkshopWorkflowState(
      jobs: jobs ?? this.jobs,
      profile: profile ?? this.profile,
    );
  }
}

class WorkshopWorkflowNotifier extends Notifier<WorkshopWorkflowState> {
  @override
  WorkshopWorkflowState build() {
    return WorkshopWorkflowState(
      jobs: _seedJobs,
      profile: const WorkshopProfileState(
        workshopName: 'OnlyCars Workshop',
        ownerName: 'Marcus Hale',
        email: 'ops@onlycars-workshop.qa',
        phone: '+974 5550 0199',
        address: '22 Motorsport Avenue, Lusail Industrial District',
        specialties: <String>[
          'Performance',
          'Diagnostics',
          'Electrical',
          'Premium Delivery',
        ],
        operatingHours: 'Sat-Thu • 08:00 - 20:00',
        currentBalanceLabel: 'QAR 28,450',
        pendingPayoutLabel: 'QAR 8,200',
        monthlyRevenueLabel: 'QAR 124,900',
        completionRateLabel: '98.6%',
        responseTimeLabel: '4 mins avg.',
        bankLabel: 'QNB Business Premium',
        ibanLabel: 'QA94 •••• •••• 1184',
        avatarUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCrL-Tf3E9-vs0Jravam2_evgl4TUwPqZx6IQlbqNmd1jgrp7bkigkYJxDMw_pXYag4TahVXKsBMKFcpM03nfMNw6hZcSghXBB-2vwwZxcLGLypjwXwO7wyILKHhTkQf7LpCJiNW8ISvetbpSs4aFkBXaCjmvXqb9w3x5K9aKdDXFcVAPOtXNNOeNrrkGpX7AuSBvV1uLiY1yMQ0wGHP9L8FbilBtpj7wTUBBRMmrMxChVeaxrxi6VRBnAcSkjQArhB9ZxzKrLuvy9o',
        coverImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDoK3RPtCfYcTq7O_2jxJ3o0OIMddtVWPzpqwm3KyzgFk2TmMWOJgHCGXpiGA1UoWgeLuodO3rvkPMuHx8urWHqykmk8G4_RSI5-LBDJRiESH3KA3Wp60aUXZGcVxWoq42qT6oQzTrQqWbxSZIu1trqnLQHhC_-jaByLc98-EaQPhzdWxQ_KoTigJdIHyVseBb-4rzprUyR2_2O25GUZxlvK7Qu2d_grpXOp6QhKO1oJ8mhHG8p1_hX0K1X-AnxRDIOO0PqXjIlzGHQ',
        mapImageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB6dsDrpCZ5_e-JKS1q0RwK3yu9e2W0n3QkC3p1OALCs_DlWFpRt-d_hqQo9sX7bw1GdkLk9fRWeKT-9382BP8RI_iODjA_tR-lX6rYwsEoIwUNvS6nIXZNhRIygxtVAdin54YZirJVUdVKVOJuj5XlQxi5V15NDxenOSVMVP-Rz2KHAmtGl2L505PYZO57egeCk_Ubh-FOkp3PpvIWDe4Su3YViF6ibss8yUAONMf9zGoQXDjjUbjnuOcYT2dVU_ZAEDudEI82IIj4',
      ),
    );
  }

  void acceptRequest(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.driverAssignment,
        statusHeadline: 'Pickup accepted',
        statusBody: 'The customer has been notified that pickup is in motion.',
      ),
    );
  }

  void assignDriver(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.incomingTracking,
        statusHeadline: 'Driver assigned',
        statusBody: 'Nasser is en route to the customer location.',
        driverAssignment: const WorkshopDriverAssignment(
          name: 'Nasser A.',
          phone: '+974 6600 4421',
          vehicleLabel: 'Workshop Flatbed',
          etaMinutes: 18,
          note: 'Handle the vehicle with a low-clearance loading angle.',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCfEqBpKf31Y4s439TrlWXVuJCf2hhGIc0cr_nd3rcTgtxkC-5GHP8-kUWmhOPuMFLf_NBmBcTIsw50cbmfhPycLHTsMQi2YtluG_qFWwTcD25gOYsgzIp2XTn84rdE_WMtV_vBx2-vma_1SlHS3iEh_9sv6ZOSlm9fdrAdllg5HNGogeeYHrIoJ_P3G8vlLKZiVFn-DLu1NwNJjmTIa4M4d06QJZNxHOsKZHON6ayGfAFuDd-JxVYydSKjuOfj6mDdwde8SJgOgDN-',
        ),
      ),
    );
  }

  void markIncomingArrived(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.activeJob,
        statusHeadline: 'Vehicle received',
        statusBody: 'The vehicle is on-site and ready for diagnosis.',
      ),
    );
  }

  void saveDiagnosisDraft(String id, WorkshopDiagnosisDraft diagnosisDraft) {
    _updateJob(id, (job) => job.copyWith(diagnosisDraft: diagnosisDraft));
  }

  void submitDiagnosis(String id, WorkshopDiagnosisDraft diagnosisDraft) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.approvalPending,
        diagnosisDraft: diagnosisDraft,
        statusHeadline: 'Awaiting customer approval',
        statusBody: 'The diagnosis report is pending customer confirmation.',
        requiresApproval: true,
      ),
    );
  }

  void markApproved(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.serviceInProgress,
        statusHeadline: 'Service started',
        statusBody: 'Technicians have started the approved repair plan.',
        requiresApproval: false,
      ),
    );
  }

  void markServiceComplete(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.handoverPrep,
        statusHeadline: 'Ready for handover',
        statusBody: 'Choose the final delivery method for the customer.',
      ),
    );
  }

  void chooseHandoverMode(String id, WorkshopHandoverMode mode) {
    _updateJob(id, (job) => job.copyWith(handoverMode: mode));
  }

  void requestReturnDelivery(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.requestReturnDelivery,
        handoverMode: WorkshopHandoverMode.workshopDriver,
        returnRequested: true,
        statusHeadline: 'Return delivery requested',
        statusBody: 'A workshop driver is being requested for the return leg.',
      ),
    );
  }

  void startReturnTracking(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.returnTracking,
        statusHeadline: 'Vehicle outbound',
        statusBody: 'The return driver has collected the vehicle.',
        driverAssignment: const WorkshopDriverAssignment(
          name: 'Khalid M.',
          phone: '+974 6611 8892',
          vehicleLabel: 'Workshop Enclosed Carrier',
          etaMinutes: 24,
          note: 'Customer requested a delivery call 10 minutes before arrival.',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuAHVMTjKc1iZ4N_ixjLw1uduTr5EkrirUhitxwDh3Zr8HlKnS0I_weBlJRuGm7KCenNUfahQnixjh4Bo3PBiiWkxBuzg_5UH_7QyevG868kzlBNCq76ywdMZjLl1wjJna0S8sQqHP_sGcLCyOONTu_2np---kSUxtwAA9us6fmQiC-x5eeJTRVosiD2WrNFhOvHOiK9mr4-91FsywWzoM8A4KzLV1h8Z6Z2p9DJo9qfTDG56DZA6b4H_ZSRKbsTnBkkpCHUAdOGdEH3',
        ),
      ),
    );
  }

  void markReturnDelivered(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.completed,
        statusHeadline: 'Job completed',
        statusBody: 'The vehicle has been returned and the job is closed.',
      ),
    );
  }

  void markCustomerPickupComplete(String id) {
    _updateJob(
      id,
      (job) => job.copyWith(
        stage: WorkshopJobStage.completed,
        handoverMode: WorkshopHandoverMode.customerPickup,
        statusHeadline: 'Customer collected vehicle',
        statusBody: 'The customer completed the workshop pickup.',
      ),
    );
  }

  void _updateJob(String id, WorkshopJobRecord Function(WorkshopJobRecord job) map) {
    state = state.copyWith(
      jobs: [
        for (final job in state.jobs)
          if (job.id == id) map(job) else job,
      ],
    );
  }
}

final workshopWorkflowProvider =
    NotifierProvider<WorkshopWorkflowNotifier, WorkshopWorkflowState>(
      WorkshopWorkflowNotifier.new,
    );

final workshopJobProvider = Provider.family<WorkshopJobRecord?, String>((
  ref,
  id,
) {
  return ref.watch(workshopWorkflowProvider).jobById(id);
});

final workshopFilteredJobsProvider =
    Provider.family<List<WorkshopJobRecord>, WorkshopJobsFilter>((ref, filter) {
      final jobs = List<WorkshopJobRecord>.from(
        ref.watch(workshopWorkflowProvider).jobs,
      );
      final filtered = switch (filter) {
        WorkshopJobsFilter.newRequests => jobs
            .where((job) => job.stage == WorkshopJobStage.newRequest)
            .toList(),
        WorkshopJobsFilter.approval => jobs
            .where((job) => job.stage == WorkshopJobStage.approvalPending)
            .toList(),
        WorkshopJobsFilter.handover => jobs
            .where((job) => job.stage == WorkshopJobStage.handoverPrep)
            .toList(),
        WorkshopJobsFilter.all => jobs,
      };

      filtered.sort(_stageSort);
      return filtered;
    });

int _stageSort(WorkshopJobRecord a, WorkshopJobRecord b) {
  return a.stage.index.compareTo(b.stage.index);
}

const _seedJobs = <WorkshopJobRecord>[
  WorkshopJobRecord(
    id: 'request-911',
    customerName: 'Marcus Sterling',
    customerPhone: '+974 5500 2201',
    vehicleName: 'Porsche 911 Carrera S',
    licensePlate: 'QA-91100',
    location: 'The Pearl, Tower 4',
    issueSummary: 'Steering fault and non-start condition after a roadside stop.',
    statusHeadline: 'New roadside pickup',
    statusBody: 'Roadside assistance requested with premium plan coverage.',
    distanceLabel: '1.2 km away',
    requestedAtLabel: 'Requested 5 mins ago',
    requestTypeLabel: 'Roadside Pickup',
    specialtyLabel: 'German Engineering',
    capacityLabel: 'Available Now',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDfAv4SBNll4d5awqE8F1IIQnzhRl-guDeTVxgJV3opgOkhQcaKewKpZCRGAy-fexCXHI82lt4GM0X0kyJ6D4K_Z1IQdYjqeKH_ndhsusIec9F7IKMt3Km9om6UNZNPxr-yIVSRFJFe-Rv4wH06hR_G6bM036WxAw7St87MGuOF0cUnZD3V7f9uo2rwbNp34lg3RAfx88lAqz5zne0CauNJQ75vmWDGgSeorR_xXjIlKMlGTRd-1lqVk8H04Wl67JXozBjO7zYNFKII',
    rating: 4.9,
    stage: WorkshopJobStage.newRequest,
    discountLabel: 'Priority',
    pickupEstimateMinutes: 20,
  ),
  WorkshopJobRecord(
    id: 'request-bmw',
    customerName: 'Sarah Jenkins',
    customerPhone: '+974 6600 9912',
    vehicleName: 'BMW M4 Competition',
    licensePlate: 'GT-9981',
    location: 'West Bay Lagoon',
    issueSummary: 'Brake performance diagnostics and full inspection report.',
    statusHeadline: 'Awaiting diagnosis approval',
    statusBody: 'The estimate was sent 4 hours ago and is pending approval.',
    distanceLabel: '4.8 km away',
    requestedAtLabel: 'Submitted 4h ago',
    requestTypeLabel: 'Premium Inspection',
    specialtyLabel: 'Brake Systems',
    capacityLabel: 'Awaiting Approval',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDL7P7Z8kThIA9FuoeRVyvwsg2wuaPoilxlAV-ijCZtYWIGfO5omhwnse_zo30s8wFKdyfp-zONMVAEPdfqBL1dlmmxtoPb6NFSBAdAAXFk1GT3x8Xsfhns3H_OjmLQp2LKXlKSWRAHUfEwDVCijSFD8p1wjrORPi1byaNYKya8pOisPPBr1lJoZLpn3E8RNf1QfrGUoANGRvldmKq8Bh8qPpqTVTMAaE-DEA647vXb4_OTbBh89pMx2MXng8h3JYxJAw0W4h1aNamP',
    rating: 4.7,
    stage: WorkshopJobStage.approvalPending,
    pickupEstimateMinutes: 35,
    requiresApproval: true,
    diagnosisDraft: WorkshopDiagnosisDraft(
      summary: 'Front brake pad replacement and fluid service recommended.',
      notes:
          'Wear pattern indicates the pads are below tolerance and the fluid is heat stressed.',
      laborCost: 950,
      partsCost: 1800,
    ),
  ),
  WorkshopJobRecord(
    id: 'request-audi',
    customerName: 'Elena Rodriguez',
    customerPhone: '+974 4400 7788',
    vehicleName: 'Audi RS6 Avant',
    licensePlate: 'RS-0006',
    location: 'Lusail Boulevard',
    issueSummary: 'Vehicle service completed and awaiting delivery preference.',
    statusHeadline: 'Ready for handover',
    statusBody: 'The job is complete and handover mode still needs to be chosen.',
    distanceLabel: '6.3 km away',
    requestedAtLabel: 'Ready 18 mins ago',
    requestTypeLabel: 'Scheduled Service',
    specialtyLabel: 'Performance Wagon',
    capacityLabel: 'Handover Pending',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCZlicB7Oj81zy_mkCUOROQRAm1lIg8_mXO0FRIGKqEYFz3sB2ospVDPQDMEC6RQxPvI06m2qzJ5W26gsYTy9jWa13s9QvOWEFN2bZHVhoBSG07ou0G9xbjiiW3J5T_GN6Hhg9oA4axjnDWk0Slr2PiuN5_StZwr9uT_gsgYVRYYBhfwWoTajOa3nrvYly60krmlHSt_OaFYQvyS75bS45WMDQ5h1oFYbjw24rV6s0FawGMEBz12LMD8T6uhJEYUJu5k-ycwLhs_Ufi',
    rating: 4.8,
    stage: WorkshopJobStage.handoverPrep,
    pickupEstimateMinutes: 28,
    diagnosisDraft: WorkshopDiagnosisDraft(
      summary: 'Oil service, adaptive suspension inspection, and wheel alignment complete.',
      notes: 'All post-service checks passed and the vehicle is cleaned.',
      laborCost: 1400,
      partsCost: 2200,
    ),
  ),
  WorkshopJobRecord(
    id: 'request-gt3',
    customerName: 'David Chen',
    customerPhone: '+974 5510 3338',
    vehicleName: 'Porsche 911 GT3',
    licensePlate: 'GT-3001',
    location: 'Msheireb Downtown',
    issueSummary: 'Approved engine cooling service is underway.',
    statusHeadline: 'Service in progress',
    statusBody: 'Technicians are completing the final cooling-system work.',
    distanceLabel: '2.9 km away',
    requestedAtLabel: 'Started 38 mins ago',
    requestTypeLabel: 'Workshop Service',
    specialtyLabel: 'Track Prep',
    capacityLabel: 'Bay 2',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDT_zELXm-aUTm5csNSVEXaMNv_m2VlO7-dZKhGhQepFRlG6kPABRFC8Ncbe7aIN9SdxhsRznrGjsaP_SCd8pvUlGQsWGWVeiEKmiTYh59zmiNlJDf3ne7sz8wEajvzNmvMDU9HR572WWLud4xbxsQIPIuBDr4NCj8YEXQdm1Bvm3uGSa5ysF6FgawTNRw9pEgtG1zJSmwB3dlAYjRCxNHo7jkYi52OcqBFUqbXr_hRmuSanZYz8giH8btoAvBmlPZBtZ01mgpkg-s8',
    rating: 4.9,
    stage: WorkshopJobStage.serviceInProgress,
    pickupEstimateMinutes: 16,
    diagnosisDraft: WorkshopDiagnosisDraft(
      summary: 'Cooling line replacement and pressure test approved.',
      notes: 'Waiting on final road-test after coolant refill.',
      laborCost: 1200,
      partsCost: 2650,
    ),
  ),
];

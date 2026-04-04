import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CourierShellTab { dashboard, orders, earnings, messages, profile }

enum CourierDeliveryStage { newRequest, navigation, confirm, completed }

@immutable
class CourierDeliveryRecord {
  const CourierDeliveryRecord({
    required this.id,
    required this.requestCode,
    required this.shopName,
    required this.workshopName,
    required this.packageSummary,
    required this.itemCount,
    required this.distanceLabel,
    required this.payoutLabel,
    required this.createdAtLabel,
    required this.pickupWindowLabel,
    required this.dropoffWindowLabel,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.recipientName,
    required this.recipientPhone,
    required this.trackingCode,
    required this.statusHeadline,
    required this.statusBody,
    required this.heroImageUrl,
    required this.stage,
    this.priorityLabel,
    this.note,
  });

  final String id;
  final String requestCode;
  final String shopName;
  final String workshopName;
  final String packageSummary;
  final int itemCount;
  final String distanceLabel;
  final String payoutLabel;
  final String createdAtLabel;
  final String pickupWindowLabel;
  final String dropoffWindowLabel;
  final String pickupAddress;
  final String dropoffAddress;
  final String recipientName;
  final String recipientPhone;
  final String trackingCode;
  final String statusHeadline;
  final String statusBody;
  final String heroImageUrl;
  final CourierDeliveryStage stage;
  final String? priorityLabel;
  final String? note;

  CourierDeliveryRecord copyWith({
    String? id,
    String? requestCode,
    String? shopName,
    String? workshopName,
    String? packageSummary,
    int? itemCount,
    String? distanceLabel,
    String? payoutLabel,
    String? createdAtLabel,
    String? pickupWindowLabel,
    String? dropoffWindowLabel,
    String? pickupAddress,
    String? dropoffAddress,
    String? recipientName,
    String? recipientPhone,
    String? trackingCode,
    String? statusHeadline,
    String? statusBody,
    String? heroImageUrl,
    CourierDeliveryStage? stage,
    String? priorityLabel,
    String? note,
  }) {
    return CourierDeliveryRecord(
      id: id ?? this.id,
      requestCode: requestCode ?? this.requestCode,
      shopName: shopName ?? this.shopName,
      workshopName: workshopName ?? this.workshopName,
      packageSummary: packageSummary ?? this.packageSummary,
      itemCount: itemCount ?? this.itemCount,
      distanceLabel: distanceLabel ?? this.distanceLabel,
      payoutLabel: payoutLabel ?? this.payoutLabel,
      createdAtLabel: createdAtLabel ?? this.createdAtLabel,
      pickupWindowLabel: pickupWindowLabel ?? this.pickupWindowLabel,
      dropoffWindowLabel: dropoffWindowLabel ?? this.dropoffWindowLabel,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropoffAddress: dropoffAddress ?? this.dropoffAddress,
      recipientName: recipientName ?? this.recipientName,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      trackingCode: trackingCode ?? this.trackingCode,
      statusHeadline: statusHeadline ?? this.statusHeadline,
      statusBody: statusBody ?? this.statusBody,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      stage: stage ?? this.stage,
      priorityLabel: priorityLabel ?? this.priorityLabel,
      note: note ?? this.note,
    );
  }
}

@immutable
class CourierEarningEntry {
  const CourierEarningEntry({
    required this.id,
    required this.deliveryId,
    required this.title,
    required this.subtitle,
    required this.dateLabel,
    required this.amountLabel,
    required this.statusLabel,
  });

  final String id;
  final String deliveryId;
  final String title;
  final String subtitle;
  final String dateLabel;
  final String amountLabel;
  final String statusLabel;
}

@immutable
class CourierMessageThread {
  const CourierMessageThread({
    required this.id,
    required this.title,
    required this.preview,
    required this.timestamp,
    this.unreadCount = 0,
  });

  final String id;
  final String title;
  final String preview;
  final String timestamp;
  final int unreadCount;
}

@immutable
class CourierProfileState {
  const CourierProfileState({
    required this.name,
    required this.email,
    required this.phone,
    required this.serviceArea,
    required this.vehicleLabel,
    required this.memberSinceLabel,
    required this.ratingLabel,
    required this.completionRateLabel,
    required this.monthlyPayoutLabel,
    required this.totalTripsLabel,
    required this.avatarUrl,
    required this.coverImageUrl,
    required this.badges,
  });

  final String name;
  final String email;
  final String phone;
  final String serviceArea;
  final String vehicleLabel;
  final String memberSinceLabel;
  final String ratingLabel;
  final String completionRateLabel;
  final String monthlyPayoutLabel;
  final String totalTripsLabel;
  final String avatarUrl;
  final String coverImageUrl;
  final List<String> badges;
}

@immutable
class CourierWorkflowState {
  const CourierWorkflowState({
    required this.isAvailable,
    required this.deliveries,
    required this.earnings,
    required this.messages,
    required this.profile,
  });

  final bool isAvailable;
  final List<CourierDeliveryRecord> deliveries;
  final List<CourierEarningEntry> earnings;
  final List<CourierMessageThread> messages;
  final CourierProfileState profile;

  CourierDeliveryRecord? deliveryById(String id) {
    try {
      return deliveries.firstWhere((delivery) => delivery.id == id);
    } catch (_) {
      return null;
    }
  }

  CourierDeliveryRecord? get activeDelivery {
    try {
      return deliveries.firstWhere(
        (delivery) =>
            delivery.stage == CourierDeliveryStage.navigation ||
            delivery.stage == CourierDeliveryStage.confirm,
      );
    } catch (_) {
      return null;
    }
  }

  int countByStage(CourierDeliveryStage stage) {
    return deliveries.where((delivery) => delivery.stage == stage).length;
  }

  int get activeDeliveryCount =>
      countByStage(CourierDeliveryStage.navigation) +
      countByStage(CourierDeliveryStage.confirm);

  int get newRequestCount => countByStage(CourierDeliveryStage.newRequest);

  int get completedCount => countByStage(CourierDeliveryStage.completed);

  CourierWorkflowState copyWith({
    bool? isAvailable,
    List<CourierDeliveryRecord>? deliveries,
    List<CourierEarningEntry>? earnings,
    List<CourierMessageThread>? messages,
    CourierProfileState? profile,
  }) {
    return CourierWorkflowState(
      isAvailable: isAvailable ?? this.isAvailable,
      deliveries: deliveries ?? this.deliveries,
      earnings: earnings ?? this.earnings,
      messages: messages ?? this.messages,
      profile: profile ?? this.profile,
    );
  }
}

class CourierWorkflowNotifier extends Notifier<CourierWorkflowState> {
  @override
  CourierWorkflowState build() {
    return const CourierWorkflowState(
      isAvailable: true,
      deliveries: _seedDeliveries,
      earnings: _seedEarnings,
      messages: _seedMessages,
      profile: _seedProfile,
    );
  }

  void toggleAvailability() {
    state = state.copyWith(isAvailable: !state.isAvailable);
  }

  void acceptDelivery(String id) {
    _updateDelivery(
      id,
      (delivery) => delivery.copyWith(
        stage: CourierDeliveryStage.navigation,
        statusHeadline: 'Heading to pickup',
        statusBody:
            'The request is locked to your route. Turn-by-turn pickup guidance is now active.',
      ),
    );
  }

  void advanceToConfirmation(String id) {
    _updateDelivery(
      id,
      (delivery) => delivery.copyWith(
        stage: CourierDeliveryStage.confirm,
        statusHeadline: 'Ready for proof of delivery',
        statusBody:
            'The package reached the workshop. Verify the recipient and capture the final handover.',
      ),
    );
  }

  void completeDelivery(String id) {
    final delivery = state.deliveryById(id);
    if (delivery == null) {
      return;
    }

    _updateDelivery(
      id,
      (current) => current.copyWith(
        stage: CourierDeliveryStage.completed,
        statusHeadline: 'Delivery completed',
        statusBody:
            'Proof of delivery is recorded and the payout is queued in your earnings ledger.',
      ),
    );

    if (state.earnings.every((entry) => entry.deliveryId != id)) {
      state = state.copyWith(
        earnings: [
          CourierEarningEntry(
            id: 'earning-$id',
            deliveryId: id,
            title: '${delivery.shopName} to ${delivery.workshopName}',
            subtitle: delivery.packageSummary,
            dateLabel: 'Just now',
            amountLabel: delivery.payoutLabel,
            statusLabel: 'Processing',
          ),
          ...state.earnings,
        ],
      );
    }
  }

  void _updateDelivery(
    String id,
    CourierDeliveryRecord Function(CourierDeliveryRecord delivery) transform,
  ) {
    state = state.copyWith(
      deliveries: [
        for (final delivery in state.deliveries)
          if (delivery.id == id) transform(delivery) else delivery,
      ],
    );
  }
}

final courierWorkflowProvider =
    NotifierProvider<CourierWorkflowNotifier, CourierWorkflowState>(
      CourierWorkflowNotifier.new,
    );

final courierDeliveryProvider = Provider.family<CourierDeliveryRecord?, String>(
  (ref, id) {
    return ref.watch(courierWorkflowProvider).deliveryById(id);
  },
);

const _seedDeliveries = <CourierDeliveryRecord>[
  CourierDeliveryRecord(
    id: 'drv-1001',
    requestCode: 'DRV-1001',
    shopName: 'Al Sadd Performance Parts',
    workshopName: 'Apex Auto Lab',
    packageSummary: 'Brake kit, ABS sensor, fluid pack',
    itemCount: 3,
    distanceLabel: '4.2 km',
    payoutLabel: 'QAR 28',
    createdAtLabel: 'Requested 4 mins ago',
    pickupWindowLabel: 'Pickup by 16:20',
    dropoffWindowLabel: 'Dropoff by 16:55',
    pickupAddress: 'Unit 14, Al Sadd Commercial Avenue',
    dropoffAddress: 'Bay 6, Apex Auto Lab, West Bay Service Road',
    recipientName: 'Hassan Malik',
    recipientPhone: '+974 5580 1220',
    trackingCode: 'OC-DRV-1001',
    statusHeadline: 'New premium delivery request',
    statusBody:
        'A same-day parts run is ready for pickup. Accept quickly to keep the promised workshop slot.',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCLPoq2fM0Skxax3T1b4lO6HqqwD0P8nPj1MhsEV8My6RJqaXwgFvWlLrH40wDZb5UR16GXeb8ORC5sNc8iRCg0Wo6be1Y7I9WvpksYB1c0m_Fb6Q51GfVdU5dl1y7oQj65Rbdb4-zDZ-0nApPeG5D3vGlqkN5qcFF0dEkI5mR4qJaXg2jlYWIF00j9o9LONxQ17nZPX8L1cewt1dvUS6-96gAd7gxL1Cbi3x1vmo9b0kcLKw0bUji1gqe5-Cm5E0zG8PzYfN9qLQ',
    stage: CourierDeliveryStage.newRequest,
    priorityLabel: 'Priority',
    note: 'Customer requested a handoff call 5 minutes before arrival.',
  ),
  CourierDeliveryRecord(
    id: 'drv-1014',
    requestCode: 'DRV-1014',
    shopName: 'Lusail OEM Parts',
    workshopName: 'Torque House',
    packageSummary: 'Cooling hose set, clamps',
    itemCount: 2,
    distanceLabel: '6.1 km',
    payoutLabel: 'QAR 34',
    createdAtLabel: 'Accepted 11 mins ago',
    pickupWindowLabel: 'Pickup by 16:35',
    dropoffWindowLabel: 'Dropoff by 17:05',
    pickupAddress: 'Marina Plaza 3, Lusail Boulevard',
    dropoffAddress: 'Torque House, Industrial Area Gate 2',
    recipientName: 'Nader Salem',
    recipientPhone: '+974 5518 4044',
    trackingCode: 'OC-DRV-1014',
    statusHeadline: 'Active delivery navigation',
    statusBody:
        'Pickup is confirmed. Navigation is focused on the fastest workshop handover route.',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCfEqBpKf31Y4s439TrlWXVuJCf2hhGIc0cr_nd3rcTgtxkC-5GHP8-kUWmhOPuMFLf_NBmBcTIsw50cbmfhPycLHTsMQi2YtluG_qFWwTcD25gOYsgzIp2XTn84rdE_WMtV_vBx2-vma_1SlHS3iEh_9sv6ZOSlm9fdrAdllg5HNGogeeYHrIoJ_P3G8vlLKZiVFn-DLu1NwNJjmTIa4M4d06QJZNxHOsKZHON6ayGfAFuDd-JxVYydSKjuOfj6mDdwde8SJgOgDN-',
    stage: CourierDeliveryStage.navigation,
    note: 'Workshop lift is reserved for 17:00.',
  ),
  CourierDeliveryRecord(
    id: 'drv-1038',
    requestCode: 'DRV-1038',
    shopName: 'Pearl Performance Store',
    workshopName: 'Summit Garage',
    packageSummary: 'Ignition coil set',
    itemCount: 1,
    distanceLabel: '3.8 km',
    payoutLabel: 'QAR 24',
    createdAtLabel: 'On-site now',
    pickupWindowLabel: 'Picked up at 15:52',
    dropoffWindowLabel: 'Arrived 16:08',
    pickupAddress: 'Pearl District Building 8, Retail Level',
    dropoffAddress: 'Summit Garage, North Service Cluster',
    recipientName: 'Omar Rahman',
    recipientPhone: '+974 5522 0902',
    trackingCode: 'OC-DRV-1038',
    statusHeadline: 'Waiting for delivery confirmation',
    statusBody:
        'The parts package is at the workshop. Capture proof and finalize the drop to release payout.',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDBvR4sUygK97HQyz2jwzNtmK5D-srEJTs7G04gN73whW_yt3KKC15SIdJYNU7Yq2Vpqi5FPDgSNs3wIPzfcwJbUQkP9TOm2FJ7Ck0n1gJwW4qf0xv-WxH_bodW3I2BpzjNw00VyjFqktR3eAPFTy5ET9e9kxxuflN8wD8ElQbxPFUKsw8s_0dR2fFz0Hc1Wz-5N3d2isOjHdQ3rDeDJ0SpsaP9Djlwm7X9sB0hCU2Sbjw5Bd3cr-ZdiiuY2X8rSgWm3d4uF5TQ2Q',
    stage: CourierDeliveryStage.confirm,
  ),
  CourierDeliveryRecord(
    id: 'drv-0982',
    requestCode: 'DRV-0982',
    shopName: 'Motor District Parts',
    workshopName: 'Racing Line Works',
    packageSummary: 'Turbo inlet pipe',
    itemCount: 1,
    distanceLabel: '5.4 km',
    payoutLabel: 'QAR 30',
    createdAtLabel: 'Completed 35 mins ago',
    pickupWindowLabel: 'Pickup 14:55',
    dropoffWindowLabel: 'Delivered 15:24',
    pickupAddress: 'Motor District Unit 5',
    dropoffAddress: 'Racing Line Works, Box 17',
    recipientName: 'Tariq M.',
    recipientPhone: '+974 5591 6655',
    trackingCode: 'OC-DRV-0982',
    statusHeadline: 'Delivery completed',
    statusBody:
        'The workshop signed off on the parcel and the run is already queued in earnings.',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCLPoq2fM0Skxax3T1b4lO6HqqwD0P8nPj1MhsEV8My6RJqaXwgFvWlLrH40wDZb5UR16GXeb8ORC5sNc8iRCg0Wo6be1Y7I9WvpksYB1c0m_Fb6Q51GfVdU5dl1y7oQj65Rbdb4-zDZ-0nApPeG5D3vGlqkN5qcFF0dEkI5mR4qJaXg2jlYWIF00j9o9LONxQ17nZPX8L1cewt1dvUS6-96gAd7gxL1Cbi3x1vmo9b0kcLKw0bUji1gqe5-Cm5E0zG8PzYfN9qLQ',
    stage: CourierDeliveryStage.completed,
  ),
  CourierDeliveryRecord(
    id: 'drv-1044',
    requestCode: 'DRV-1044',
    shopName: 'Downtown Chassis Supply',
    workshopName: 'Blue Line Customs',
    packageSummary: 'Suspension bushings, mounting kit',
    itemCount: 2,
    distanceLabel: '7.2 km',
    payoutLabel: 'QAR 39',
    createdAtLabel: 'Requested 2 mins ago',
    pickupWindowLabel: 'Pickup by 16:45',
    dropoffWindowLabel: 'Dropoff by 17:20',
    pickupAddress: 'Downtown Logistics Row 2',
    dropoffAddress: 'Blue Line Customs, Service Yard 3',
    recipientName: 'Salem Q.',
    recipientPhone: '+974 5534 9711',
    trackingCode: 'OC-DRV-1044',
    statusHeadline: 'Fresh dispatch request',
    statusBody:
        'A workshop is waiting for a tight suspension delivery window. Claim the request to add it to your route.',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCfEqBpKf31Y4s439TrlWXVuJCf2hhGIc0cr_nd3rcTgtxkC-5GHP8-kUWmhOPuMFLf_NBmBcTIsw50cbmfhPycLHTsMQi2YtluG_qFWwTcD25gOYsgzIp2XTn84rdE_WMtV_vBx2-vma_1SlHS3iEh_9sv6ZOSlm9fdrAdllg5HNGogeeYHrIoJ_P3G8vlLKZiVFn-DLu1NwNJjmTIa4M4d06QJZNxHOsKZHON6ayGfAFuDd-JxVYydSKjuOfj6mDdwde8SJgOgDN-',
    stage: CourierDeliveryStage.newRequest,
  ),
];

const _seedEarnings = <CourierEarningEntry>[
  CourierEarningEntry(
    id: 'earning-1',
    deliveryId: 'drv-0982',
    title: 'Motor District Parts to Racing Line Works',
    subtitle: 'Turbo inlet pipe',
    dateLabel: 'Today • 15:24',
    amountLabel: 'QAR 30',
    statusLabel: 'Paid',
  ),
  CourierEarningEntry(
    id: 'earning-2',
    deliveryId: 'drv-0891',
    title: 'Pearl Performance Store to Summit Garage',
    subtitle: 'Cooling components',
    dateLabel: 'Today • 13:40',
    amountLabel: 'QAR 26',
    statusLabel: 'Paid',
  ),
  CourierEarningEntry(
    id: 'earning-3',
    deliveryId: 'drv-0830',
    title: 'Lusail OEM Parts to Torque House',
    subtitle: 'OEM service bundle',
    dateLabel: 'Yesterday • 18:05',
    amountLabel: 'QAR 34',
    statusLabel: 'Processing',
  ),
];

const _seedMessages = <CourierMessageThread>[
  CourierMessageThread(
    id: 'thread-1',
    title: 'Dispatch Control',
    preview: 'Stay on the Marina route. Workshop bay is ready at 17:00.',
    timestamp: '2m',
    unreadCount: 2,
  ),
  CourierMessageThread(
    id: 'thread-2',
    title: 'Al Sadd Performance Parts',
    preview: 'Package is sealed and waiting at the front counter.',
    timestamp: '12m',
  ),
  CourierMessageThread(
    id: 'thread-3',
    title: 'Apex Auto Lab',
    preview: 'Call on arrival. Lift access is open for delivery vehicles.',
    timestamp: '33m',
  ),
];

const _seedProfile = CourierProfileState(
  name: 'Yousef Rahman',
  email: 'yousef.rahman@onlycars.app',
  phone: '+974 5566 1904',
  serviceArea: 'West Bay, Lusail, Al Sadd',
  vehicleLabel: 'OnlyCars courier bike • QAT 4421',
  memberSinceLabel: 'Since 2023',
  ratingLabel: '4.9',
  completionRateLabel: '98%',
  monthlyPayoutLabel: 'QAR 8.4K',
  totalTripsLabel: '842 trips',
  avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCfEqBpKf31Y4s439TrlWXVuJCf2hhGIc0cr_nd3rcTgtxkC-5GHP8-kUWmhOPuMFLf_NBmBcTIsw50cbmfhPycLHTsMQi2YtluG_qFWwTcD25gOYsgzIp2XTn84rdE_WMtV_vBx2-vma_1SlHS3iEh_9sv6ZOSlm9fdrAdllg5HNGogeeYHrIoJ_P3G8vlLKZiVFn-DLu1NwNJjmTIa4M4d06QJZNxHOsKZHON6ayGfAFuDd-JxVYydSKjuOfj6mDdwde8SJgOgDN-',
  coverImageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCLPoq2fM0Skxax3T1b4lO6HqqwD0P8nPj1MhsEV8My6RJqaXwgFvWlLrH40wDZb5UR16GXeb8ORC5sNc8iRCg0Wo6be1Y7I9WvpksYB1c0m_Fb6Q51GfVdU5dl1y7oQj65Rbdb4-zDZ-0nApPeG5D3vGlqkN5qcFF0dEkI5mR4qJaXg2jlYWIF00j9o9LONxQ17nZPX8L1cewt1dvUS6-96gAd7gxL1Cbi3x1vmo9b0kcLKw0bUji1gqe5-Cm5E0zG8PzYfN9qLQ',
  badges: ['Same-day parts', 'Priority runs', 'Premium workshops'],
);

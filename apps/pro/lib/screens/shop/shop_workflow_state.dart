import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ShopShellTab { dashboard, orders, products, messages, profile }

enum ShopOrderStage {
  newOrder,
  packing,
  deliveryRequest,
  searchingDriver,
  courierAssigned,
  handover,
  tracking,
  completed,
}

@immutable
class ShopCourierAssignment {
  const ShopCourierAssignment({
    required this.name,
    required this.phone,
    required this.vehicleLabel,
    required this.etaLabel,
    this.avatarUrl,
  });

  final String name;
  final String phone;
  final String vehicleLabel;
  final String etaLabel;
  final String? avatarUrl;
}

@immutable
class ShopOrderLineItem {
  const ShopOrderLineItem({
    required this.name,
    required this.sku,
    required this.quantity,
    required this.priceLabel,
    required this.imageUrl,
  });

  final String name;
  final String sku;
  final int quantity;
  final String priceLabel;
  final String imageUrl;
}

@immutable
class ShopOrderRecord {
  const ShopOrderRecord({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.createdAtLabel,
    required this.deliveryWindowLabel,
    required this.totalLabel,
    required this.subtotalLabel,
    required this.deliveryFeeLabel,
    required this.statusHeadline,
    required this.statusBody,
    required this.vehicleLabel,
    required this.plateLabel,
    required this.trackingCode,
    required this.heroImageUrl,
    required this.items,
    required this.stage,
    this.priorityLabel,
    this.courier,
  });

  final String id;
  final String orderNumber;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String createdAtLabel;
  final String deliveryWindowLabel;
  final String totalLabel;
  final String subtotalLabel;
  final String deliveryFeeLabel;
  final String statusHeadline;
  final String statusBody;
  final String vehicleLabel;
  final String plateLabel;
  final String trackingCode;
  final String heroImageUrl;
  final List<ShopOrderLineItem> items;
  final ShopOrderStage stage;
  final String? priorityLabel;
  final ShopCourierAssignment? courier;

  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);

  ShopOrderRecord copyWith({
    String? id,
    String? orderNumber,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? createdAtLabel,
    String? deliveryWindowLabel,
    String? totalLabel,
    String? subtotalLabel,
    String? deliveryFeeLabel,
    String? statusHeadline,
    String? statusBody,
    String? vehicleLabel,
    String? plateLabel,
    String? trackingCode,
    String? heroImageUrl,
    List<ShopOrderLineItem>? items,
    ShopOrderStage? stage,
    String? priorityLabel,
    ShopCourierAssignment? courier,
  }) {
    return ShopOrderRecord(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      createdAtLabel: createdAtLabel ?? this.createdAtLabel,
      deliveryWindowLabel: deliveryWindowLabel ?? this.deliveryWindowLabel,
      totalLabel: totalLabel ?? this.totalLabel,
      subtotalLabel: subtotalLabel ?? this.subtotalLabel,
      deliveryFeeLabel: deliveryFeeLabel ?? this.deliveryFeeLabel,
      statusHeadline: statusHeadline ?? this.statusHeadline,
      statusBody: statusBody ?? this.statusBody,
      vehicleLabel: vehicleLabel ?? this.vehicleLabel,
      plateLabel: plateLabel ?? this.plateLabel,
      trackingCode: trackingCode ?? this.trackingCode,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      items: items ?? this.items,
      stage: stage ?? this.stage,
      priorityLabel: priorityLabel ?? this.priorityLabel,
      courier: courier ?? this.courier,
    );
  }
}

@immutable
class ShopInventoryRecord {
  const ShopInventoryRecord({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.priceLabel,
    required this.stockCount,
    required this.imageUrl,
    this.highlightLabel,
  });

  final String id;
  final String name;
  final String sku;
  final String category;
  final String priceLabel;
  final int stockCount;
  final String imageUrl;
  final String? highlightLabel;

  bool get isLowStock => stockCount <= 4;

  ShopInventoryRecord copyWith({
    String? id,
    String? name,
    String? sku,
    String? category,
    String? priceLabel,
    int? stockCount,
    String? imageUrl,
    String? highlightLabel,
  }) {
    return ShopInventoryRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      category: category ?? this.category,
      priceLabel: priceLabel ?? this.priceLabel,
      stockCount: stockCount ?? this.stockCount,
      imageUrl: imageUrl ?? this.imageUrl,
      highlightLabel: highlightLabel ?? this.highlightLabel,
    );
  }
}

@immutable
class ShopMessagePreview {
  const ShopMessagePreview({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.unreadCount = 0,
  });

  final String title;
  final String subtitle;
  final String timestamp;
  final int unreadCount;
}

@immutable
class ShopProfileState {
  const ShopProfileState({
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.coverageLabel,
    required this.operatingHours,
    required this.availableBalanceLabel,
    required this.ordersThisWeekLabel,
    required this.shopRatingLabel,
    required this.responseTimeLabel,
    required this.avatarUrl,
    required this.coverImageUrl,
    required this.tags,
  });

  final String shopName;
  final String ownerName;
  final String email;
  final String phone;
  final String address;
  final String coverageLabel;
  final String operatingHours;
  final String availableBalanceLabel;
  final String ordersThisWeekLabel;
  final String shopRatingLabel;
  final String responseTimeLabel;
  final String avatarUrl;
  final String coverImageUrl;
  final List<String> tags;
}

@immutable
class ShopWorkflowState {
  const ShopWorkflowState({
    required this.orders,
    required this.inventory,
    required this.profile,
    required this.messages,
  });

  final List<ShopOrderRecord> orders;
  final List<ShopInventoryRecord> inventory;
  final ShopProfileState profile;
  final List<ShopMessagePreview> messages;

  ShopOrderRecord? orderById(String id) {
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }

  int countByStage(ShopOrderStage stage) {
    return orders.where((order) => order.stage == stage).length;
  }

  ShopWorkflowState copyWith({
    List<ShopOrderRecord>? orders,
    List<ShopInventoryRecord>? inventory,
    ShopProfileState? profile,
    List<ShopMessagePreview>? messages,
  }) {
    return ShopWorkflowState(
      orders: orders ?? this.orders,
      inventory: inventory ?? this.inventory,
      profile: profile ?? this.profile,
      messages: messages ?? this.messages,
    );
  }
}

class ShopWorkflowNotifier extends Notifier<ShopWorkflowState> {
  @override
  ShopWorkflowState build() {
    return const ShopWorkflowState(
      orders: _seedOrders,
      inventory: _seedInventory,
      profile: _seedProfile,
      messages: _seedMessages,
    );
  }

  void startPacking(String id) {
    _updateOrder(
      id,
      (order) => order.copyWith(
        stage: ShopOrderStage.packing,
        statusHeadline: 'Packing in progress',
        statusBody:
            'The pick list is locked and the parcel is being packed for dispatch.',
      ),
    );
  }

  void requestDelivery(String id) {
    _updateOrder(
      id,
      (order) => order.copyWith(
        stage: ShopOrderStage.deliveryRequest,
        statusHeadline: 'Delivery request prepared',
        statusBody:
            'Packaging is confirmed and the delivery request is ready to send.',
      ),
    );
  }

  void sendDeliveryRequest(String id) {
    _updateOrder(
      id,
      (order) => order.copyWith(
        stage: ShopOrderStage.searchingDriver,
        statusHeadline: 'Searching for driver',
        statusBody:
            'OnlyCars dispatch is matching the best courier for this route.',
      ),
    );
  }

  void assignCourier(String id) {
    _updateOrder(
      id,
      (order) => order.copyWith(
        stage: ShopOrderStage.courierAssigned,
        statusHeadline: 'Courier assigned',
        statusBody:
            'Dispatch has assigned a courier and the handover window is locked.',
        courier: const ShopCourierAssignment(
          name: 'Nasser Al-Harbi',
          phone: '+974 5544 1102',
          vehicleLabel: 'OnlyCars delivery van',
          etaLabel: 'Arrives in 12 mins',
          avatarUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCfEqBpKf31Y4s439TrlWXVuJCf2hhGIc0cr_nd3rcTgtxkC-5GHP8-kUWmhOPuMFLf_NBmBcTIsw50cbmfhPycLHTsMQi2YtluG_qFWwTcD25gOYsgzIp2XTn84rdE_WMtV_vBx2-vma_1SlHS3iEh_9sv6ZOSlm9fdrAdllg5HNGogeeYHrIoJ_P3G8vlLKZiVFn-DLu1NwNJjmTIa4M4d06QJZNxHOsKZHON6ayGfAFuDd-JxVYydSKjuOfj6mDdwde8SJgOgDN-',
        ),
      ),
    );
  }

  void prepareHandover(String id) {
    _updateOrder(
      id,
      (order) => order.copyWith(
        stage: ShopOrderStage.handover,
        statusHeadline: 'Ready for handover',
        statusBody:
            'Courier has arrived. Verify the sealed parcel and release the shipment.',
      ),
    );
  }

  void confirmHandover(String id) {
    _updateOrder(
      id,
      (order) => order.copyWith(
        stage: ShopOrderStage.tracking,
        statusHeadline: 'Delivery in progress',
        statusBody:
            'The parcel has left the shop and the customer can track the route live.',
      ),
    );
  }

  void markDelivered(String id) {
    _updateOrder(
      id,
      (order) => order.copyWith(
        stage: ShopOrderStage.completed,
        statusHeadline: 'Delivery completed',
        statusBody:
            'Proof of delivery has been captured and this order is closed.',
      ),
    );
  }

  void addInventoryItem({
    required String name,
    required String sku,
    required String priceLabel,
    required int stockCount,
  }) {
    final nextIndex = state.inventory.length + 1;
    state = state.copyWith(
      inventory: [
        ShopInventoryRecord(
          id: 'inventory-$nextIndex',
          name: name,
          sku: sku,
          category: 'New Arrival',
          priceLabel: priceLabel,
          stockCount: stockCount,
          imageUrl:
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDBvR4sUygK97HQyz2jwzNtmK5D-srEJTs7G04gN73whW_yt3KKC15SIdJYNU7Yq2Vpqi5FPDgSNs3wIPzfcwJbUQkP9TOm2FJ7Ck0n1gJwW4qf0xv-WxH_bodW3I2BpzjNw00VyjFqktR3eAPFTy5ET9e9kxxuflN8wD8ElQbxPFUKsw8s_0dR2fFz0Hc1Wz-5N3d2isOjHdQ3rDeDJ0SpsaP9Djlwm7X9sB0hCU2Sbjw5Bd3cr-ZdiiuY2X8rSgWm3d4uF5TQ2Q',
          highlightLabel: 'New',
        ),
        ...state.inventory,
      ],
    );
  }

  void _updateOrder(
    String id,
    ShopOrderRecord Function(ShopOrderRecord order) transform,
  ) {
    state = state.copyWith(
      orders: [
        for (final order in state.orders)
          if (order.id == id) transform(order) else order,
      ],
    );
  }
}

final shopWorkflowProvider =
    NotifierProvider<ShopWorkflowNotifier, ShopWorkflowState>(
      ShopWorkflowNotifier.new,
    );

final shopOrderProvider = Provider.family<ShopOrderRecord?, String>((ref, id) {
  return ref.watch(shopWorkflowProvider).orderById(id);
});

const _seedOrders = <ShopOrderRecord>[
  ShopOrderRecord(
    id: 'oc-2048',
    orderNumber: 'OC-2048',
    customerName: 'Marcus Hale',
    customerPhone: '+974 5542 1188',
    customerAddress: 'Tower 11, Lusail Marina District',
    createdAtLabel: 'Placed 8 mins ago',
    deliveryWindowLabel: 'Today • 16:30 - 17:15',
    totalLabel: 'QAR 1,480',
    subtotalLabel: 'QAR 1,445',
    deliveryFeeLabel: 'QAR 35',
    statusHeadline: 'New high-priority order',
    statusBody:
        'Two premium brake parts are reserved and waiting for packing confirmation.',
    vehicleLabel: 'Porsche 911 Turbo S',
    plateLabel: '911-TS',
    trackingCode: 'PKG-2048',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCLPoq2fM0Skxax3T1b4lO6HqqwD0P8nPj1MhsEV8My6RJqaXwgFvWlLrH40wDZb5UR16GXeb8ORC5sNc8iRCg0Wo6be1Y7I9WvpksYB1c0m_Fb6Q51GfVdU5dl1y7oQj65Rbdb4-zDZ-0nApPeG5D3vGlqkN5qcFF0dEkI5mR4qJaXg2jlYWIF00j9o9LONxQ17nZPX8L1cewt1dvUS6-96gAd7gxL1Cbi3x1vmo9b0kcLKw0bUji1gqe5-Cm5E0zG8PzYfN9qLQ',
    items: [
      ShopOrderLineItem(
        name: 'Brembo Ceramic Brake Kit',
        sku: 'BRK-991-CS',
        quantity: 1,
        priceLabel: 'QAR 1,240',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDk5rjd0Oeh8v2aMp1j49A1PWKZZOR44VxrkF6JfD7ZgS9g5N1SyQx7znv7wzh0uJtxi7p00C5lYBbKfPiR-vjvK-xnO5vQv7__eVPAPx7MGkcq6yaSkvlk6rNStXQv8L8Tyq6Ezhd7DFcEDo6X27kBty4cn-7U08zI-0m1pI6v0J4QkKAtwK1Y4OXl_bC7Xvd1j6n6jvhGR4LxvfYYZBIMs9PWkhxXNSuW7xIOp-t5WvLfovk2qGiQ-wxKrtnXgvuVb2ZZs_nB9g',
      ),
      ShopOrderLineItem(
        name: 'Motul RBF 700 Fluid',
        sku: 'MTL-RBF700',
        quantity: 1,
        priceLabel: 'QAR 205',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDWG1Kf0y25EWs3Bn5SaR3yl_QpWpg13vNwkcgBPpM7k0n7lWSy5pTMyq0BoJe4M5T-h84S9CZVbEUm_j9vrW0fGEsHJT1x-DdN4_vthhvbSjx8tLma_TTLLOhZRpI9HyC5k4fcyYEu9uW0rRKq3FnLQPyJ_hNk0h6SRGxsl75cC4Bxzzx-8mOQ-S3QR1Q3pZ4Dwp5q7FQFHW4GdB-6Yh6y4oPGM2F4z-yYf3d6BycGjiPbc-lsGxF_HToBZj03x6b1Ch0XWQ',
      ),
    ],
    stage: ShopOrderStage.newOrder,
    priorityLabel: 'Priority',
  ),
  ShopOrderRecord(
    id: 'oc-1987',
    orderNumber: 'OC-1987',
    customerName: 'Sara Khan',
    customerPhone: '+974 5501 4432',
    customerAddress: 'West Bay Residence 22',
    createdAtLabel: 'Packed 12 mins ago',
    deliveryWindowLabel: 'Today • 17:00 - 18:00',
    totalLabel: 'QAR 640',
    subtotalLabel: 'QAR 605',
    deliveryFeeLabel: 'QAR 35',
    statusHeadline: 'Packed and ready',
    statusBody:
        'Parcel is sealed and the courier request can be sent without extra checks.',
    vehicleLabel: 'Toyota Land Cruiser',
    plateLabel: 'LC-4477',
    trackingCode: 'PKG-1987',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD1d6z7g5vbA5HkKJxG0fT5sQeEUs3gWvdD4NO8X2fZ6M8SXcCyyWmDZlCb8NNPODgn6Vn4c-Vl7WdZKsG9vqJbMpcQ1H2W2VdbtU2e1JBxL5HTiT0Od3A9kC9d6V87q_ahh1hPHH4sLWvg9szs__7DN3V8B4Q5LLdB9rff2BvLQHTd5PHvP2CxBkxbE3k4GJcLgi7W2jvDVvPq1h3UqylL0eYlcKikHc__6hP1bjrWyeTiIMzR2sSI6rlMQfFmKuj2i4FUsA',
    items: [
      ShopOrderLineItem(
        name: 'OEM Oil Filter Set',
        sku: 'OEM-OIL-2GR',
        quantity: 2,
        priceLabel: 'QAR 140',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCvQ4gTG4V7m7Xni6osnQhGtCcBo44Sg9FqDo1KbZJjTqsT_2xT6cr7EizZp3v_8xodBBEYcB2AUrzEx5qjy6YVe9rLtmJUqN9nFNl0hE7vRArxKc9Q1tC9lWwrGy3LGV5c9GsnQWZ9fK3_VxF1H-I4WNBISVe6eKObuPd34A0vQpJxJJmQJsLQsX4f8qVQ47bV7XfY1hZlgSr0_5Dyrc5vT7E0CIY5vALu12dN6l3ckgN5J3g-l9bGx8_kh8OS4CdmI3Q',
      ),
      ShopOrderLineItem(
        name: 'Cabin Air Filter',
        sku: 'CAB-LC200',
        quantity: 1,
        priceLabel: 'QAR 325',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAu_OyU0O9dK4eVwB7n7qazl6kwqstl4v-xyKzU0xI3Uu7P1DveL9oSEU4RM-jbUEIeO9ENaE1ibovG_yaF1x9w8ebO3bSOyWP70QG-PJ23v_lwJP4Vyq8NFWlf4Y0TSni2GGBxW2s2GOGa1ydS2IYr4twR6kG59KKnVGe6zzfiv0aH2MMqYef1TRj6mCw1wBrUuM9F1SkN14lY4a36N0T10f2AZM3IKk4g8dWgqIXaBJeuM7GjZpU5q3v2z0QLMsmg',
      ),
    ],
    stage: ShopOrderStage.packing,
  ),
  ShopOrderRecord(
    id: 'oc-1944',
    orderNumber: 'OC-1944',
    customerName: 'Alya Mansoor',
    customerPhone: '+974 6621 2209',
    customerAddress: 'Pearl Qatar, Viva Bahriya',
    createdAtLabel: 'Courier requested 6 mins ago',
    deliveryWindowLabel: 'Today • 17:30 - 18:15',
    totalLabel: 'QAR 915',
    subtotalLabel: 'QAR 880',
    deliveryFeeLabel: 'QAR 35',
    statusHeadline: 'Driver search live',
    statusBody:
        'Dispatch is searching the nearest available driver for premium same-day drop-off.',
    vehicleLabel: 'Mercedes G63',
    plateLabel: 'G63-77',
    trackingCode: 'PKG-1944',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA1j-Q8uOZp5gLiM59J3V0iyt-i9V3oAg_b_5z7dktHmS3K2OUPGm_WJ7R_u5BvP6Nn3VeqhbeHUwTQY5hoLQeCd6P_R8IcMBaYjMwK3cBA1grAqk3p_d5nTz6gxliCVW2nMrCu4dQm7W2S_u8zO7Dj-LX3aH2LuGqJTYvq4T9IlmJ42XvJuq7q0tGG-5oHWbHZEbCTGn1oIw48V1e0STVzaNIKClFnt-8tb4YQW3t14Rc96tZza0bYW-zD8GcZ2T_r45uVpQ',
    items: [
      ShopOrderLineItem(
        name: 'Performance Air Intake',
        sku: 'INT-G63-01',
        quantity: 1,
        priceLabel: 'QAR 880',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuAkF8nL1pMpyEsMCoATBu6cVOBBvUoxPXznZy0W8T2WzE6qMfW3mQ5v5h5-OkCj7OH2T5xyMQxRkzvA4NY_XiC2R0N1z5YMbJw1TnY7w2Uzh6lCe2kO2KNoVcM6GRP9K0RTiQm0f5iiPRArb97Wjivh6ob4nUiRCS-22ZdF73fj66QLuS3RrB8jSE0fIHHpWJm6v6K3wItR4jvShnB_qLiO93e0KjTn87ZqtWQ1EcsS4DMe7q5YyrdRG8uB9eBq_oQw',
      ),
    ],
    stage: ShopOrderStage.searchingDriver,
  ),
  ShopOrderRecord(
    id: 'oc-1875',
    orderNumber: 'OC-1875',
    customerName: 'Nadia Farouk',
    customerPhone: '+974 6640 8801',
    customerAddress: 'Msheireb Downtown Block A',
    createdAtLabel: 'Courier assigned 9 mins ago',
    deliveryWindowLabel: 'Today • 18:00 - 18:45',
    totalLabel: 'QAR 2,150',
    subtotalLabel: 'QAR 2,115',
    deliveryFeeLabel: 'QAR 35',
    statusHeadline: 'Courier on the way',
    statusBody:
        'Courier ETA is confirmed and the shop should prepare final handover checks.',
    vehicleLabel: 'BMW M4 Competition',
    plateLabel: 'M4-875',
    trackingCode: 'PKG-1875',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD4Ix3fXtWa0-9mQjwv8q2E_rQPO-8saH9u09p_A_rhPczDw7T6ECSRo5pYEMK1pZ78gkISFMSkFj1dI2fI6L-4LGd_FdQwAkDZ4LJwWJB9w8agMxg6ckQBP2Vj5F1uHCvmuSldQmBNiybW1xfKEoImYoCGiL1_nZAA6xVaS3WR0eM8HKkfd0BtKMIIBQ5f6kg7_4lBDW49UzPqFnY38gOq3ylsWU73e0yTfKOn0gI8DiN9UuHaLrRrsCVkMjT1L6C0dYI',
    items: [
      ShopOrderLineItem(
        name: 'Adaptive Damper Set',
        sku: 'DMP-M4-ADP',
        quantity: 1,
        priceLabel: 'QAR 2,115',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCYvJ4m3wR7IgRCdsGXg3_EqA8MsJiNKKKr0em8cAhV8AzbTfrxUex3KpNrQr8lScI6XeX9zL0xQ_hR9Rh_dQ6Lq3vgtQY4PeI2UhVya9VG6j1hL1T4N-0ZC8zbyMZC7hGDI1gKQwN4n9oK2B3PeT7WaD4q8BL4q7RXU0tZpb67D4E2dTSv9S10RMVQKzxAB4Y2NOecKWYnPdd2gWb6i_7sCAkWb69nP1d7GT9DTrLqqi7I2LmuTi5VON1eEhEqJ-4uQ',
      ),
    ],
    stage: ShopOrderStage.courierAssigned,
    courier: ShopCourierAssignment(
      name: 'Lina Haddad',
      phone: '+974 6633 1200',
      vehicleLabel: 'OnlyCars rapid courier bike',
      etaLabel: 'ETA 9 mins',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAHVMTjKc1iZ4N_ixjLw1uduTr5EkrirUhitxwDh3Zr8HlKnS0I_weBlJRuGm7KCenNUfahQnixjh4Bo3PBiiWkxBuzg_5UH_7QyevG868kzlBNCq76ywdMZjLl1wjJna0S8sQqHP_sGcLCyOONTu_2np---kSUxtwAA9us6fmQiC-x5eeJTRVosiD2WrNFhOvHOiK9mr4-91FsywWzoM8A4KzLV1h8Z6Z2p9DJo9qfTDG56DZA6b4H_ZSRKbsTnBkkpCHUAdOGdEH3',
    ),
  ),
  ShopOrderRecord(
    id: 'oc-1742',
    orderNumber: 'OC-1742',
    customerName: 'Omar Siddiq',
    customerPhone: '+974 6655 9987',
    customerAddress: 'The Pearl Gate 3',
    createdAtLabel: 'Left shop 14 mins ago',
    deliveryWindowLabel: 'Today • 18:15 - 19:00',
    totalLabel: 'QAR 780',
    subtotalLabel: 'QAR 745',
    deliveryFeeLabel: 'QAR 35',
    statusHeadline: 'Parcel en route',
    statusBody:
        'Courier cleared the handover checkpoint and is progressing toward the customer.',
    vehicleLabel: 'Nissan Patrol',
    plateLabel: 'PTL-742',
    trackingCode: 'PKG-1742',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD_T7MkhKBOi_1v7R0Y9CIhG40Ue_8l_bV3PdbnrjZ4o2tC_Zvv0WwI1oea21RK3P6G51n_nkYhYx-cqOP0HaQGd81W0A_Yhqj1XypAzZVNcy4V9hDgNSEk7vUbP3G33C7DZgk1i3YJ89s74rLDA7WLvIo6Er5bM8d9W57gkQSB2Hk0iBdT-cGyTb2rRO7IyaPW1qJpVCWc3TnEKpq8yf7kf-WZfPeV0u6dbN9HfvixJrdziYd34tZefFQ0y7VcjKiKcJw',
    items: [
      ShopOrderLineItem(
        name: 'OEM Belt Tensioner',
        sku: 'BELT-PTL-01',
        quantity: 1,
        priceLabel: 'QAR 745',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA0zr4ioYF8jl0iYukfzB1y2VT9h76qly9U0NNljCRoWjQvqlJ82V8Gyy6bbtw8-0D4znKSLzKj5Z6n2OC5dyP2yJr7ge4w8kxgqAlN9S-3n8ZcwEqFTGWl8mXXUi-Vg-S5vz75M2JvMfzvshKQH4t_lhTcaZPzlHJQz27qRyiKW8Tu4s0m07TOCQ7x4o4S0w-h4SRav9H__40RP_D4qsOqB95uXTez3VQPU1QU7KE3g-cgQ9vLyqzjWBJwkiwS3g',
      ),
    ],
    stage: ShopOrderStage.tracking,
    courier: ShopCourierAssignment(
      name: 'Hassan Malik',
      phone: '+974 6610 4501',
      vehicleLabel: 'OnlyCars cargo scooter',
      etaLabel: 'ETA 18 mins',
      avatarUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCrL-Tf3E9-vs0Jravam2_evgl4TUwPqZx6IQlbqNmd1jgrp7bkigkYJxDMw_pXYag4TahVXKsBMKFcpM03nfMNw6hZcSghXBB-2vwwZxcLGLypjwXwO7wyILKHhTkQf7LpCJiNW8ISvetbpSs4aFkBXaCjmvXqb9w3x5K9aKdDXFcVAPOtXNNOeNrrkGpX7AuSBvV1uLiY1yMQ0wGHP9L8FbilBtpj7wTUBBRMmrMxChVeaxrxi6VRBnAcSkjQArhB9ZxzKrLuvy9o',
    ),
  ),
  ShopOrderRecord(
    id: 'oc-1601',
    orderNumber: 'OC-1601',
    customerName: 'Khaled Jaber',
    customerPhone: '+974 6620 7741',
    customerAddress: 'Education City, Gate 5',
    createdAtLabel: 'Completed 26 mins ago',
    deliveryWindowLabel: 'Today • 15:30 - 16:15',
    totalLabel: 'QAR 420',
    subtotalLabel: 'QAR 385',
    deliveryFeeLabel: 'QAR 35',
    statusHeadline: 'Delivered successfully',
    statusBody:
        'Customer received the package and proof-of-delivery has been recorded.',
    vehicleLabel: 'Toyota Camry',
    plateLabel: 'CAM-601',
    trackingCode: 'PKG-1601',
    heroImageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAxnuK2lA3S29SkY0nDpXxZB4XBI6tFq6k0y0RrBvvmCrvE9p2kNKl9mJU0dPvZQX9MORhVAQkNjtJ89sNQXBQ_zwHhEkVZJzUAluWJUbkuP3P0N9N8DxU1W7FL1qP0Y5D1J0rK4yU5td5GXfKy4zc3cD0ay0Q0W6A_D3AQ1DQxsyap8QdDBKc0NYoKpqNWCj1QoX6LznVsnxg7rqwb2suUfw3E1G8g5wwaivQeM9i8vCgYorG6F0Ror7-FaOb9ZwwWNA',
    items: [
      ShopOrderLineItem(
        name: 'Wiper Blade Pair',
        sku: 'WIP-CAM-24',
        quantity: 1,
        priceLabel: 'QAR 385',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBO87cMOYvLeFagP5qrSgHjHiR8lK2P1_H6obvGg2z8-rt82TdU9vtSZtY2MNWQUNcVh_L7r6WJ-IenP5k0QQXjDmOlRRd_sx8o3DE6tW5LhV2LMY0yQ2LKy0BjldKt6JLUKcH0HCr4e4Bo1zK7ehqg6cTknN9yYNl1KXv8dX0oX2cQh3p8w8eY9SaRyp14Om4zRgN5AabOzU1mZkgadCkbLtEr40m9C9iiPO-w4ltw8DcYzJENCKRQF2FZJkUaWDg',
      ),
    ],
    stage: ShopOrderStage.completed,
  ),
];

const _seedInventory = <ShopInventoryRecord>[
  ShopInventoryRecord(
    id: 'inv-1',
    name: 'Brembo Ceramic Brake Kit',
    sku: 'BRK-991-CS',
    category: 'Brakes',
    priceLabel: 'QAR 1,240',
    stockCount: 3,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDk5rjd0Oeh8v2aMp1j49A1PWKZZOR44VxrkF6JfD7ZgS9g5N1SyQx7znv7wzh0uJtxi7p00C5lYBbKfPiR-vjvK-xnO5vQv7__eVPAPx7MGkcq6yaSkvlk6rNStXQv8L8Tyq6Ezhd7DFcEDo6X27kBty4cn-7U08zI-0m1pI6v0J4QkKAtwK1Y4OXl_bC7Xvd1j6n6jvhGR4LxvfYYZBIMs9PWkhxXNSuW7xIOp-t5WvLfovk2qGiQ-wxKrtnXgvuVb2ZZs_nB9g',
    highlightLabel: 'Low Stock',
  ),
  ShopInventoryRecord(
    id: 'inv-2',
    name: 'Adaptive Damper Set',
    sku: 'DMP-M4-ADP',
    category: 'Suspension',
    priceLabel: 'QAR 2,115',
    stockCount: 6,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCYvJ4m3wR7IgRCdsGXg3_EqA8MsJiNKKKr0em8cAhV8AzbTfrxUex3KpNrQr8lScI6XeX9zL0xQ_hR9Rh_dQ6Lq3vgtQY4PeI2UhVya9VG6j1hL1T4N-0ZC8zbyMZC7hGDI1gKQwN4n9oK2B3PeT7WaD4q8BL4q7RXU0tZpb67D4E2dTSv9S10RMVQKzxAB4Y2NOecKWYnPdd2gWb6i_7sCAkWb69nP1d7GT9DTrLqqi7I2LmuTi5VON1eEhEqJ-4uQ',
    highlightLabel: 'Featured',
  ),
  ShopInventoryRecord(
    id: 'inv-3',
    name: 'Performance Air Intake',
    sku: 'INT-G63-01',
    category: 'Engine',
    priceLabel: 'QAR 880',
    stockCount: 9,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAkF8nL1pMpyEsMCoATBu6cVOBBvUoxPXznZy0W8T2WzE6qMfW3mQ5v5h5-OkCj7OH2T5xyMQxRkzvA4NY_XiC2R0N1z5YMbJw1TnY7w2Uzh6lCe2kO2KNoVcM6GRP9K0RTiQm0f5iiPRArb97Wjivh6ob4nUiRCS-22ZdF73fj66QLuS3RrB8jSE0fIHHpWJm6v6K3wItR4jvShnB_qLiO93e0KjTn87ZqtWQ1EcsS4DMe7q5YyrdRG8uB9eBq_oQw',
  ),
  ShopInventoryRecord(
    id: 'inv-4',
    name: 'OEM Belt Tensioner',
    sku: 'BELT-PTL-01',
    category: 'Drive Belt',
    priceLabel: 'QAR 745',
    stockCount: 2,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA0zr4ioYF8jl0iYukfzB1y2VT9h76qly9U0NNljCRoWjQvqlJ82V8Gyy6bbtw8-0D4znKSLzKj5Z6n2OC5dyP2yJr7ge4w8kxgqAlN9S-3n8ZcwEqFTGWl8mXXUi-Vg-S5vz75M2JvMfzvshKQH4t_lhTcaZPzlHJQz27qRyiKW8Tu4s0m07TOCQ7x4o4S0w-h4SRav9H__40RP_D4qsOqB95uXTez3VQPU1QU7KE3g-cgQ9vLyqzjWBJwkiwS3g',
    highlightLabel: 'Low Stock',
  ),
];

const _seedProfile = ShopProfileState(
  shopName: 'OnlyCars Parts Hub',
  ownerName: 'Rayan Motors Trading',
  email: 'ops@onlycars.parts',
  phone: '+974 5511 9088',
  address: 'Industrial Area, Street 21, Gate 4',
  coverageLabel: 'Same-day Doha & Lusail coverage',
  operatingHours: 'Sat-Thu • 08:00 - 21:00',
  availableBalanceLabel: 'QAR 48,240',
  ordersThisWeekLabel: '126 orders',
  shopRatingLabel: '4.9 / 5',
  responseTimeLabel: '3 min avg.',
  avatarUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAWIzEN0K2x2Ut9OOsNDOQcbxuhhW7sFFO_rbz2hTI0Oo_vO-S9pFcOEdrx0_LIEA85023XCr2iloJZzubLmZDACDhwD-r9rPGhEA_X_zTct4AZfu_NtrxDF-DW2nmUQjhg8kQhAxF7lWuTu0xTORf3CjVLCtCcKrpQqD94FvrN2VBR7o9XcU5uxUHUlyxR7ym0qB87d0tyK78Atds1ypjeklKnOB7pFmbvAFpE2joqFBSHlxdG44AwQo8fc6HNyBrUxhrdgzcPdN_w',
  coverImageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAZmSwwjYGC6qHc32nLG8kAGpUSd6ddHDa6rQnAa5yl8bbFg50o7Q8mW5qZBCUKRrj9dpcMxFPzr45Xgye5tJmO4nEJAtDBQZ1u2L_vjKNnHHo9KG_EqqsJZNL7WMN2VCoK7lLhjlRog1WBD-S4hI7VngYvJY51m7cTG5g-wJzqo45Uu7WdXJ7KJ2yvjBqvdDS9JgsiA3qIG3v5MjHvwq2jiIj8VZ3Y9xgQaY7jvqeSHwBMOX3KteSg0teE3gFNyGaTMj0xIic',
  tags: <String>['Porsche', 'BMW M', 'Premium Delivery', 'OEM Stock'],
);

const _seedMessages = <ShopMessagePreview>[
  ShopMessagePreview(
    title: 'Dispatch Desk',
    subtitle: 'Courier allocation sync is planned for the next backend pass.',
    timestamp: '2m ago',
    unreadCount: 1,
  ),
  ShopMessagePreview(
    title: 'VIP Customers',
    subtitle:
        'Messaging stays intentionally lightweight in this UI-first delivery.',
    timestamp: '12m ago',
  ),
];

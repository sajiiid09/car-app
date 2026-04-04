import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProChatRole { workshop, shop, driver }

@immutable
class ProChatParticipant {
  const ProChatParticipant({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String? avatarUrl;
}

@immutable
class ProChatMessage {
  const ProChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });

  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;
}

@immutable
class ProChatThread {
  const ProChatThread({
    required this.id,
    required this.participant,
    required this.messages,
    this.unreadCount = 0,
  });

  final String id;
  final ProChatParticipant participant;
  final List<ProChatMessage> messages;
  final int unreadCount;

  ProChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;

  ProChatThread copyWith({
    String? id,
    ProChatParticipant? participant,
    List<ProChatMessage>? messages,
    int? unreadCount,
  }) {
    return ProChatThread(
      id: id ?? this.id,
      participant: participant ?? this.participant,
      messages: messages ?? this.messages,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

@immutable
class ProChatRoleState {
  const ProChatRoleState({required this.currentUser, required this.threads});

  final ProChatParticipant currentUser;
  final List<ProChatThread> threads;

  ProChatThread? threadById(String threadId) {
    for (final thread in threads) {
      if (thread.id == threadId) {
        return thread;
      }
    }
    return null;
  }

  ProChatRoleState copyWith({
    ProChatParticipant? currentUser,
    List<ProChatThread>? threads,
  }) {
    return ProChatRoleState(
      currentUser: currentUser ?? this.currentUser,
      threads: threads ?? this.threads,
    );
  }
}

@immutable
class ProChatState {
  const ProChatState({required this.roles});

  final Map<ProChatRole, ProChatRoleState> roles;

  ProChatRoleState roleState(ProChatRole role) => roles[role]!;

  ProChatState copyWithRole(ProChatRole role, ProChatRoleState roleState) {
    return ProChatState(roles: {...roles, role: roleState});
  }
}

class ProChatNotifier extends Notifier<ProChatState> {
  @override
  ProChatState build() => ProChatState(
    roles: {
      ProChatRole.workshop: _seedWorkshopChats,
      ProChatRole.shop: _seedShopChats,
      ProChatRole.driver: _seedDriverChats,
    },
  );

  void markThreadRead(ProChatRole role, String threadId) {
    final roleState = state.roleState(role);
    final updatedThreads = [
      for (final thread in roleState.threads)
        if (thread.id == threadId) thread.copyWith(unreadCount: 0) else thread,
    ];

    state = state.copyWithRole(
      role,
      roleState.copyWith(threads: updatedThreads),
    );
  }

  void sendMessage({
    required ProChatRole role,
    required String threadId,
    required String text,
  }) {
    final roleState = state.roleState(role);
    final currentUser = roleState.currentUser;
    final timestamp = DateTime.now();
    final updatedThreads = [
      for (final thread in roleState.threads)
        if (thread.id == threadId)
          thread.copyWith(
            unreadCount: 0,
            messages: [
              ...thread.messages,
              ProChatMessage(
                id: '${thread.id}-${timestamp.microsecondsSinceEpoch}',
                senderId: currentUser.id,
                text: text,
                sentAt: timestamp,
              ),
            ],
          )
        else
          thread,
    ];

    state = state.copyWithRole(
      role,
      roleState.copyWith(threads: updatedThreads),
    );
  }
}

final proChatProvider = NotifierProvider<ProChatNotifier, ProChatState>(
  ProChatNotifier.new,
);

final _seedWorkshopChats = ProChatRoleState(
  currentUser: const ProChatParticipant(
    id: 'workshop-self',
    name: 'Apex Workshop',
  ),
  threads: [
    ProChatThread(
      id: 'workshop-thread-ava',
      participant: const ProChatParticipant(
        id: 'customer-ava',
        name: 'Ava Stone',
      ),
      unreadCount: 2,
      messages: [
        ProChatMessage(
          id: 'wk-ava-1',
          senderId: 'customer-ava',
          text: 'Hi, is my Audi ready for pickup today?',
          sentAt: DateTime(2026, 4, 5, 10, 24),
        ),
        ProChatMessage(
          id: 'wk-ava-2',
          senderId: 'workshop-self',
          text: 'Almost done. Final quality check is underway.',
          sentAt: DateTime(2026, 4, 5, 10, 27),
        ),
        ProChatMessage(
          id: 'wk-ava-3',
          senderId: 'customer-ava',
          text: 'Perfect, please message me when the driver leaves.',
          sentAt: DateTime(2026, 4, 5, 10, 30),
        ),
      ],
    ),
    ProChatThread(
      id: 'workshop-thread-courier',
      participant: const ProChatParticipant(
        id: 'driver-omar',
        name: 'Omar Rahman',
      ),
      messages: [
        ProChatMessage(
          id: 'wk-omr-1',
          senderId: 'workshop-self',
          text: 'Vehicle is ready at bay 2.',
          sentAt: DateTime(2026, 4, 5, 11, 14),
        ),
        ProChatMessage(
          id: 'wk-omr-2',
          senderId: 'driver-omar',
          text: 'Received. I will arrive in eight minutes.',
          sentAt: DateTime(2026, 4, 5, 11, 39),
        ),
      ],
    ),
    ProChatThread(
      id: 'workshop-thread-shop',
      participant: const ProChatParticipant(
        id: 'shop-vertex',
        name: 'Vertex Parts',
      ),
      messages: [
        ProChatMessage(
          id: 'wk-shop-1',
          senderId: 'shop-vertex',
          text: 'The tie rod set is packed and ready for dispatch.',
          sentAt: DateTime(2026, 4, 5, 14, 50),
        ),
      ],
    ),
  ],
);

final _seedShopChats = ProChatRoleState(
  currentUser: const ProChatParticipant(id: 'shop-self', name: 'Apex Parts'),
  threads: [
    ProChatThread(
      id: 'shop-thread-trendz',
      participant: const ProChatParticipant(
        id: 'workshop-trendz',
        name: 'Trendz',
      ),
      unreadCount: 1,
      messages: [
        ProChatMessage(
          id: 'shop-trendz-1',
          senderId: 'workshop-trendz',
          text: 'Can you hold the brake kit until the courier arrives?',
          sentAt: DateTime(2026, 4, 5, 10, 30),
        ),
      ],
    ),
    ProChatThread(
      id: 'shop-thread-oliver',
      participant: const ProChatParticipant(
        id: 'customer-oliver',
        name: 'Oliver',
      ),
      messages: [
        ProChatMessage(
          id: 'shop-oliver-1',
          senderId: 'shop-self',
          text: 'yhh',
          sentAt: DateTime(2026, 4, 5, 11, 39),
        ),
      ],
    ),
    ProChatThread(
      id: 'shop-thread-sophia',
      participant: const ProChatParticipant(
        id: 'customer-sophia',
        name: 'Sophia',
      ),
      messages: [
        ProChatMessage(
          id: 'shop-sophia-1',
          senderId: 'customer-sophia',
          text: 'ok sure',
          sentAt: DateTime(2026, 4, 5, 14, 30),
        ),
      ],
    ),
    ProChatThread(
      id: 'shop-thread-ava',
      participant: const ProChatParticipant(id: 'driver-ava', name: 'Ava'),
      messages: [
        ProChatMessage(
          id: 'shop-ava-1',
          senderId: 'driver-ava',
          text: 'nice work',
          sentAt: DateTime(2026, 4, 5, 14, 50),
        ),
      ],
    ),
  ],
);

final _seedDriverChats = ProChatRoleState(
  currentUser: const ProChatParticipant(id: 'driver-self', name: 'Omar Rahman'),
  threads: [
    ProChatThread(
      id: 'driver-thread-dispatch',
      participant: const ProChatParticipant(id: 'dispatch', name: 'Dispatch'),
      unreadCount: 1,
      messages: [
        ProChatMessage(
          id: 'drv-dispatch-1',
          senderId: 'dispatch',
          text: 'New delivery request just landed near West Bay.',
          sentAt: DateTime(2026, 4, 5, 9, 48),
        ),
      ],
    ),
    ProChatThread(
      id: 'driver-thread-shop',
      participant: const ProChatParticipant(
        id: 'shop-north',
        name: 'Northline Parts',
      ),
      messages: [
        ProChatMessage(
          id: 'drv-shop-1',
          senderId: 'shop-north',
          text: 'Package is ready at the front desk.',
          sentAt: DateTime(2026, 4, 5, 11, 22),
        ),
        ProChatMessage(
          id: 'drv-shop-2',
          senderId: 'driver-self',
          text: 'On my way.',
          sentAt: DateTime(2026, 4, 5, 11, 24),
        ),
      ],
    ),
    ProChatThread(
      id: 'driver-thread-workshop',
      participant: const ProChatParticipant(
        id: 'workshop-crest',
        name: 'Crest Workshop',
      ),
      messages: [
        ProChatMessage(
          id: 'drv-workshop-1',
          senderId: 'workshop-crest',
          text: 'Call before you arrive, the gate will be closed.',
          sentAt: DateTime(2026, 4, 5, 15, 2),
        ),
      ],
    ),
  ],
);

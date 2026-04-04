import 'dart:async';

import 'package:consumer/l10n/app_localizations.dart';
import 'package:consumer/providers.dart';
import 'package:consumer/screens/chat/chat_detail_screen.dart';
import 'package:consumer/screens/chat/chat_list_screen.dart';
import 'package:consumer/screens/home/home_shell.dart';
import 'package:consumer/screens/workshops/workshop_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_api/oc_api.dart';
import 'package:oc_models/oc_models.dart';
import 'package:oc_ui/oc_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('consumer chat screens', () {
    testWidgets(
      'inbox renders the new compact layout and keeps chat tab active',
      (tester) async {
        final router = await _pumpHarness(tester, initialLocation: '/chat');

        expect(
          find.byKey(const ValueKey('consumerChatListScreen')),
          findsOneWidget,
        );
        expect(find.text('Chats'), findsOneWidget);
        expect(find.text('Messages'), findsOneWidget);

        final chatNav = find.byKey(const ValueKey('customerNav-/chat'));
        expect(chatNav, findsOneWidget);

        final animatedContainer = tester.widget<AnimatedContainer>(
          find.descendant(
            of: chatNav,
            matching: find.byType(AnimatedContainer),
          ),
        );
        final decoration = animatedContainer.decoration! as BoxDecoration;
        expect(decoration.color, isNotNull);
        expect(router.routeInformationProvider.value.uri.path, '/chat');
      },
    );

    testWidgets(
      'thread route renders outside shell with back navigation and composer',
      (tester) async {
        await _pumpHarness(tester, initialLocation: '/chat/room-1');

        expect(
          find.byKey(const ValueKey('consumerChatDetailScreen')),
          findsOneWidget,
        );
        expect(find.byType(OcChatComposer), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
        expect(find.byKey(const ValueKey('customerNav-/chat')), findsNothing);
      },
    );

    testWidgets('unread and read rows use different title styling', (
      tester,
    ) async {
      await _pumpHarness(tester, initialLocation: '/chat');

      final unreadTitle = tester.widget<Text>(find.text('Trendz'));
      final readTitle = tester.widget<Text>(find.text('Oliver'));

      expect(unreadTitle.style?.color, OcColors.accent);
      expect(readTitle.style?.color, OcColors.textPrimary);
    });

    testWidgets(
      'workshop detail contact action still lands in the chat thread',
      (tester) async {
        await _pumpHarness(tester, initialLocation: '/workshop/ws-1');

        final buttonFinder = find.widgetWithText(
          ElevatedButton,
          'تواصل مع الورشة',
        );
        await tester.ensureVisible(buttonFinder);
        final button = tester.widget<ElevatedButton>(buttonFinder);
        button.onPressed?.call();
        await tester.pumpAndSettle();

        expect(
          find.byKey(const ValueKey('consumerChatDetailScreen')),
          findsOneWidget,
        );
      },
    );
  });
}

Future<GoRouter> _pumpHarness(
  WidgetTester tester, {
  required String initialLocation,
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final chatService = _FakeChatService();
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/chat/:id',
        builder: (_, state) =>
            ChatDetailScreen(roomId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/workshop/:id',
        builder: (_, state) =>
            WorkshopDetailScreen(workshopId: state.pathParameters['id']!),
      ),
      ShellRoute(
        builder: (_, _, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/profile',
            builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
          ),
          GoRoute(path: '/chat', builder: (_, _) => const ChatListScreen()),
          GoRoute(
            path: '/orders',
            builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
          ),
          GoRoute(
            path: '/map',
            builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
          ),
          GoRoute(
            path: '/home',
            builder: (_, _) => const Scaffold(body: SizedBox.shrink()),
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        chatServiceProvider.overrideWithValue(chatService),
        workshopServiceProvider.overrideWithValue(_FakeWorkshopService()),
        userProfileProvider.overrideWith((_) async {
          return const OcUser(
            id: 'current-user',
            phone: '+97450000000',
            name: 'Mason Lee',
          );
        }),
        currentChatUserIdProvider.overrideWithValue('current-user'),
      ],
      child: MaterialApp.router(
        theme: OcTheme.light,
        darkTheme: OcTheme.dark,
        themeMode: ThemeMode.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

class _FakeChatService implements ChatService {
  _FakeChatService()
    : _rooms = {
        'room-1': ChatRoom(
          id: 'room-1',
          participant1: 'current-user',
          participant2: 'trendz-user',
          lastMessage: 'Can you confirm the drop-off time?',
          lastMessageAt: DateTime(2026, 4, 5, 10, 30),
          otherUser: const {'id': 'trendz-user', 'name': 'Trendz'},
        ),
        'room-2': ChatRoom(
          id: 'room-2',
          participant1: 'current-user',
          participant2: 'oliver-user',
          lastMessage: 'Thanks, see you soon.',
          lastMessageAt: DateTime(2026, 4, 5, 11, 39),
          otherUser: const {'id': 'oliver-user', 'name': 'Oliver'},
        ),
      },
      _messagesByRoom = {
        'room-1': [
          ChatMessage(
            id: 'room-1-msg-1',
            roomId: 'room-1',
            senderId: 'trendz-user',
            content: 'Can you confirm the drop-off time?',
            createdAt: DateTime(2026, 4, 5, 10, 30),
          ),
        ],
        'room-2': [
          ChatMessage(
            id: 'room-2-msg-1',
            roomId: 'room-2',
            senderId: 'current-user',
            content: 'Thanks, see you soon.',
            createdAt: DateTime(2026, 4, 5, 11, 39),
          ),
        ],
      },
      _unreadCounts = {'room-1': 2, 'room-2': 0},
      _controllers = {
        'room-1': StreamController<ChatMessage>.broadcast(),
        'room-2': StreamController<ChatMessage>.broadcast(),
      };

  final Map<String, ChatRoom> _rooms;
  final Map<String, List<ChatMessage>> _messagesByRoom;
  final Map<String, int> _unreadCounts;
  final Map<String, StreamController<ChatMessage>> _controllers;

  @override
  Future<ChatRoom> getOrCreateRoom({
    required String otherUserId,
    String? orderId,
  }) async {
    for (final room in _rooms.values) {
      if (room.participant2 == otherUserId ||
          room.participant1 == otherUserId) {
        return room;
      }
    }

    final room = ChatRoom(
      id: 'room-new',
      participant1: 'current-user',
      participant2: otherUserId,
      orderId: orderId,
      otherUser: const {'id': 'workshop-owner', 'name': 'Apex Workshop'},
    );
    _rooms[room.id] = room;
    _messagesByRoom[room.id] = [];
    _unreadCounts[room.id] = 0;
    _controllers[room.id] = StreamController<ChatMessage>.broadcast();
    return room;
  }

  @override
  Future<List<ChatRoom>> getRooms() async {
    final rooms = _rooms.values.toList(growable: false)
      ..sort((a, b) {
        final aTime = a.lastMessageAt ?? DateTime(1970);
        final bTime = b.lastMessageAt ?? DateTime(1970);
        return bTime.compareTo(aTime);
      });
    return rooms;
  }

  @override
  Future<int> getUnreadCount(String roomId) async => _unreadCounts[roomId] ?? 0;

  @override
  Future<List<ChatMessage>> getMessages(String roomId, {int limit = 50}) async {
    final messages = List<ChatMessage>.from(_messagesByRoom[roomId] ?? const [])
      ..sort((a, b) {
        final aTime = a.createdAt ?? DateTime(1970);
        final bTime = b.createdAt ?? DateTime(1970);
        return bTime.compareTo(aTime);
      });
    return messages.take(limit).toList(growable: false);
  }

  @override
  Future<ChatMessage> sendMessage({
    required String roomId,
    required String content,
    String type = 'text',
    String? mediaUrl,
    Map<String, dynamic>? metadata,
  }) async {
    final timestamp = DateTime(2026, 4, 5, 12, 8);
    final message = ChatMessage(
      id: '$roomId-sent-${(_messagesByRoom[roomId] ?? const []).length + 1}',
      roomId: roomId,
      senderId: 'current-user',
      content: content,
      type: type,
      mediaUrl: mediaUrl,
      metadata: metadata ?? const {},
      createdAt: timestamp,
    );

    _messagesByRoom[roomId] = [...?_messagesByRoom[roomId], message];
    final existingRoom = _rooms[roomId];
    if (existingRoom != null) {
      _rooms[roomId] = existingRoom.copyWith(
        lastMessage: content,
        lastMessageAt: timestamp,
      );
    }
    _controllers[roomId]?.add(message);
    return message;
  }

  @override
  Stream<ChatMessage> subscribeToMessages(String roomId) {
    return _controllers
        .putIfAbsent(roomId, () => StreamController<ChatMessage>.broadcast())
        .stream;
  }

  @override
  Future<void> markAsRead(String roomId) async {
    _unreadCounts[roomId] = 0;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeWorkshopService implements WorkshopService {
  @override
  Future<WorkshopProfile?> getWorkshopById(String id) async {
    return WorkshopProfile(
      id: id,
      userId: 'workshop-owner',
      nameAr: 'ورشة أبيكس',
      code: 'AXP-100',
      descriptionAr: 'ورشة متخصصة في أعمال الأداء والصيانة السريعة.',
      phone: '+974 5000 1111',
      lat: 25.2854,
      lng: 51.5310,
      zone: 'West Bay',
      street: 'Workshop Street',
      building: '12',
      specialties: const ['Diagnostics', 'Brakes'],
      avgRating: 4.8,
      totalReviews: 12,
      totalJobsCompleted: 185,
      isVerified: true,
      isApproved: true,
    );
  }

  @override
  Future<List<Review>> getReviews(String workshopId) async {
    return const [];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

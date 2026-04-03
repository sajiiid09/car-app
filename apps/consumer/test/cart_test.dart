import 'package:consumer/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oc_models/oc_models.dart';

void main() {
  group('CartNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('starts empty', () {
      expect(container.read(cartProvider), isEmpty);
    });

    test('add item increases quantity', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.add(_part('part-123'));

      final cartItem = container.read(cartProvider)['part-123'];
      expect(cartItem, isNotNull);
      expect(cartItem!.quantity, 1);
    });

    test('add same item increments qty', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.add(_part('part-123'));
      notifier.add(_part('part-123'));

      expect(container.read(cartProvider)['part-123']!.quantity, 2);
    });

    test('remove decrements qty', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.add(_part('part-123'));
      notifier.add(_part('part-123'));
      notifier.remove('part-123');

      expect(container.read(cartProvider)['part-123']!.quantity, 1);
    });

    test('remove last item removes key', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.add(_part('part-123'));
      notifier.remove('part-123');

      expect(container.read(cartProvider).containsKey('part-123'), isFalse);
    });

    test('clear empties cart', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.add(_part('part-1'));
      notifier.add(_part('part-2'));
      notifier.add(_part('part-3'));
      notifier.clear();

      expect(container.read(cartProvider), isEmpty);
    });

    test('totalItems counts all quantities', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.add(_part('part-1'));
      notifier.add(_part('part-1'));
      notifier.add(_part('part-2'));

      expect(notifier.totalItems, 3);
    });

    test('multiple items tracked independently', () {
      final notifier = container.read(cartProvider.notifier);
      notifier.add(_part('part-a'));
      notifier.add(_part('part-b'));
      notifier.add(_part('part-b'));

      final cart = container.read(cartProvider);
      expect(cart['part-a']!.quantity, 1);
      expect(cart['part-b']!.quantity, 2);
    });
  });
}

Part _part(String id) {
  return Part(
    id: id,
    shopId: 'shop-1',
    nameAr: id,
    price: 10,
    imageUrls: const [],
  );
}

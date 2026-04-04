import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oc_models/oc_models.dart';

import '../../providers.dart';

final orderDetailProvider = FutureProvider.family<Order?, String>((
  ref,
  id,
) async {
  final service = ref.read(orderServiceProvider);
  return service.getOrderById(id);
});

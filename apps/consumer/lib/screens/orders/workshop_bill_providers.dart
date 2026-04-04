import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oc_models/oc_models.dart';

import '../../providers.dart';

final billDetailProvider = FutureProvider.family<WorkshopBill?, String>((
  ref,
  id,
) async {
  final service = ref.read(billServiceProvider);
  return service.getBillById(id);
});

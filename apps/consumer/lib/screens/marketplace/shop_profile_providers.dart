import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oc_api/oc_api.dart';
import 'package:oc_models/oc_models.dart';

import '../../providers.dart';

final shopDetailProvider = FutureProvider.family<Map<String, dynamic>?, String>(
  (ref, shopId) async {
    final client = OcSupabase.client;
    return client.from('shop_profiles').select().eq('id', shopId).maybeSingle();
  },
);

final shopPartsProvider = FutureProvider.family<List<Part>, String>((
  ref,
  shopId,
) async {
  final service = ref.read(partsServiceProvider);
  return service.getPartsByShopId(shopId);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oc_models/oc_models.dart';

import '../../providers.dart';

final workshopDetailProvider = FutureProvider.family<WorkshopProfile?, String>((
  ref,
  id,
) async {
  final service = ref.read(workshopServiceProvider);
  return service.getWorkshopById(id);
});

final workshopReviewsProvider = FutureProvider.family<List<Review>, String>((
  ref,
  workshopId,
) async {
  final service = ref.read(workshopServiceProvider);
  return service.getReviews(workshopId);
});

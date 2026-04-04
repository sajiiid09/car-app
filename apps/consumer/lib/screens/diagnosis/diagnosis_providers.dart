import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oc_models/oc_models.dart';

import '../../providers.dart';

final diagnosisDetailProvider = FutureProvider.family<DiagnosisReport?, String>(
  (ref, id) async {
    final service = ref.read(diagnosisServiceProvider);
    return service.getReportById(id);
  },
);

import 'package:flutter/material.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'courier_workflow_state.dart';

String courierDeliveryRoute(CourierDeliveryRecord delivery) {
  return switch (delivery.stage) {
    CourierDeliveryStage.newRequest => '/driver/orders/${delivery.id}',
    CourierDeliveryStage.navigation =>
      '/driver/orders/${delivery.id}/navigation',
    CourierDeliveryStage.confirm => '/driver/orders/${delivery.id}/confirm',
    CourierDeliveryStage.completed => '/driver/orders/${delivery.id}/completed',
  };
}

String courierStageLabel(BuildContext context, CourierDeliveryStage stage) {
  final l10n = AppLocalizations.of(context)!;
  return switch (stage) {
    CourierDeliveryStage.newRequest => l10n.driverStageNewRequest,
    CourierDeliveryStage.navigation => l10n.driverStageNavigation,
    CourierDeliveryStage.confirm => l10n.driverStageConfirm,
    CourierDeliveryStage.completed => l10n.driverStageCompleted,
  };
}

Color courierStageColor(CourierDeliveryStage stage) {
  return switch (stage) {
    CourierDeliveryStage.newRequest => PartnerFlowPalette.warning,
    CourierDeliveryStage.navigation => PartnerFlowPalette.secondaryStart,
    CourierDeliveryStage.confirm => PartnerFlowPalette.primaryEnd,
    CourierDeliveryStage.completed => PartnerFlowPalette.success,
  };
}

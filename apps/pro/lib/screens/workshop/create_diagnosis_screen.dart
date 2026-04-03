import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'workshop_job_flow_screens.dart';
import 'workshop_shared.dart';
import 'workshop_workflow_state.dart';

class CreateDiagnosisScreen extends ConsumerStatefulWidget {
  const CreateDiagnosisScreen({
    super.key,
    required this.jobId,
  });

  final String jobId;

  @override
  ConsumerState<CreateDiagnosisScreen> createState() =>
      _CreateDiagnosisScreenState();
}

class _CreateDiagnosisScreenState extends ConsumerState<CreateDiagnosisScreen> {
  late final TextEditingController _summaryController;
  late final TextEditingController _notesController;
  late final TextEditingController _laborController;
  late final TextEditingController _partsController;

  @override
  void initState() {
    super.initState();
    final job = ref.read(workshopJobProvider(widget.jobId));
    final draft = job?.diagnosisDraft ?? const WorkshopDiagnosisDraft();
    _summaryController = TextEditingController(text: draft.summary);
    _notesController = TextEditingController(text: draft.notes);
    _laborController = TextEditingController(
      text: draft.laborCost == 0 ? '' : draft.laborCost.toStringAsFixed(0),
    );
    _partsController = TextEditingController(
      text: draft.partsCost == 0 ? '' : draft.partsCost.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _notesController.dispose();
    _laborController.dispose();
    _partsController.dispose();
    super.dispose();
  }

  WorkshopDiagnosisDraft get _draft {
    return WorkshopDiagnosisDraft(
      summary: _summaryController.text.trim(),
      notes: _notesController.text.trim(),
      laborCost: double.tryParse(_laborController.text.trim()) ?? 0,
      partsCost: double.tryParse(_partsController.text.trim()) ?? 0,
      photoUrls: const [
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBEvq3oYHSS13-p5ZHKvehsYV0fMbt6QVfU0GXu2ElVBi2vu_TOLseOKIkGrYF0CjqukX-5-1-C9aDGeAJlLJ8D4os3qDCG44j-MREOYJ1f2Ayvx3S8LRdHkOs2YfJMHOce4kMdlwy_MN_CLdWSXOpH5yNnsSpUAChwRfxRgeIqUvUOOgeZJqXsr-1yVAkf5br3Sv_Y9Q5v-wHfJVeWH1x1j2MovFS2dbQPkC-8u_oZm_a4QCu_DtIip8et0OcqsrsGQXU5-sNBnwev',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD65jkGK6Lc_nxRI6Qjt_2HqHrSPT_VHwrn5GZDCcNCKW4pF8H-PVk5MANFKh9T-iBquA8SzxfcmTSEO7Et9zRuuUBnlrwjPRVAdG1m98MYwuy0XoPrrksTX6gY56uX2WSCgWBXJf0mwRa-hgdVUjjBdrqlPb9oAEJa8xysuRRkir_H0b6bsTs5KzE319kpUxbq_fHTeupBVbB-e5ibvAYgZk0rbcBxaYnJIRzMdM4YL_5zedNQOfqH_ZpRuOgXVvgCOTBimAbyvHhG',
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD2Eh624ztnH2oj-dsWPjMrNImNtJXfjbc-xzXoyg_V47Bq5_vp6aQRhKdoanBR1EQ2MB2IFI60P68uiYK39PNPL3E72ywsGmOWVGqknow1nHBUCcvO3omlULJcwleem5b_d1jGCKIKyXLFXxFbc7qFXe5Jtg9HsBc91Bb7DKj8NhpTujgpDzw4z1bd1YRm5j5uShOHCaW99C5G625dKA3OboRNabjGVCWA6U3qARn-vdE3AkgrsV4QyH3nR5po9r3s1ADE13ZOE7xT',
      ],
    );
  }

  bool get _canSubmit =>
      _summaryController.text.trim().isNotEmpty &&
      _laborController.text.trim().isNotEmpty &&
      _partsController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(widget.jobId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopJobNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopDiagnosisEyebrow,
            title: l10n.workshopCreateDiagnosisTitle,
            subtitle: l10n.workshopCreateDiagnosisSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkshopRemoteImage(
                  url: job.imageUrl,
                  height: 210,
                ),
                const SizedBox(height: 18),
                Text(
                  job.vehicleName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  job.issueSummary,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                _DiagnosisField(
                  key: const Key('workshopDiagnosisSummaryField'),
                  controller: _summaryController,
                  label: l10n.workshopDiagnosisSummaryLabel,
                  maxLines: 3,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DiagnosisField(
                        key: const Key('workshopDiagnosisLaborField'),
                        controller: _laborController,
                        label: l10n.workshopLaborEstimateLabel,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DiagnosisField(
                        key: const Key('workshopDiagnosisPartsField'),
                        controller: _partsController,
                        label: l10n.workshopPartsEstimateLabel,
                        keyboardType: TextInputType.number,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DiagnosisField(
                  key: const Key('workshopDiagnosisNotesField'),
                  controller: _notesController,
                  label: l10n.workshopDiagnosisNotesLabel,
                  maxLines: 4,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.workshopDiagnosisPhotosLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 110,
                        child: WorkshopRemoteImage(
                          url: _draft.photoUrls[index],
                          height: 90,
                          borderRadius: const BorderRadius.all(Radius.circular(18)),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 12),
                    itemCount: _draft.photoUrls.length,
                  ),
                ),
                const SizedBox(height: 24),
                WorkshopPrimaryButton(
                  key: const Key('workshopSubmitDiagnosisButton'),
                  label: l10n.workshopSubmitForApproval,
                  onPressed: _canSubmit
                      ? () {
                          ref
                              .read(workshopWorkflowProvider.notifier)
                              .submitDiagnosis(job.id, _draft);
                          context.go('/workshop/jobs/job/${job.id}/approval-pending');
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DiagnosisField extends StatelessWidget {
  const _DiagnosisField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.keyboardType,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: PartnerFlowPalette.textSecondary,
          fontWeight: FontWeight.w800,
        ),
        filled: true,
        fillColor: PartnerFlowPalette.surfaceSoft,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

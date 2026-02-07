import 'package:application/core/constants/colors.dart';
import 'package:application/core/constants/text_styles.dart';
import 'package:application/features/voice_check/voice_check_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'clinical_input_sheet.dart'; // 👈 make sure this exists

class VoiceCheckView extends StatelessWidget {
  const VoiceCheckView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _VoiceCheckBody();
  }
}

class _VoiceCheckBody extends StatefulWidget {
  const _VoiceCheckBody();

  @override
  State<_VoiceCheckBody> createState() => _VoiceCheckBodyState();
}

class _VoiceCheckBodyState extends State<_VoiceCheckBody> {
  bool _formShown = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_formShown) {
      _formShown = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          builder: (_) => const ClinicalInputSheet(),
        );

        if (!mounted || result == null) return;

        final vm = context.read<VoiceCheckViewModel>();

        // ✅ Store clinical inputs
        vm.setClinicalInputs(
          ac: result['ac'],
          nth: result['nth'],
          htn: result['htn'],
        );

        // ✅ Start recording ONLY after inputs
        vm.startRecording();
      });
    }
  }

  void _checkAndNavigate(VoiceCheckViewModel vm) {
    if (vm.shouldNavigateToProcessing) {
      vm.resetNavigationFlags();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/processing');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await context.read<VoiceCheckViewModel>().stopRecording();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () async {
              await context.read<VoiceCheckViewModel>().stopRecording();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          title: const Text('Voice Check', style: AppTextStyles.title),
        ),
        body: SafeArea(
          child: Consumer<VoiceCheckViewModel>(
            builder: (_, vm, __) {
              _checkAndNavigate(vm);

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const _InstructionCard(),
                    const SizedBox(height: 40),
                    const _WaveBars(),
                    const SizedBox(height: 24),
                    const _StatusChip(),
                    const SizedBox(height: 32),
                    Text(vm.formattedTime, style: AppTextStyles.timer),
                    const SizedBox(height: 8),
                    const Text(
                      "RECORDING TIME",
                      style: TextStyle(
                        letterSpacing: 2,
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    _StopButton(vm),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/* ===================== UI WIDGETS ===================== */

class _InstructionCard extends StatelessWidget {
  const _InstructionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(blurRadius: 20, color: AppColors.lightBlack)],
      ),
      child: Column(
        children: const [
          Text("Level 1", style: AppTextStyles.stepText),
          SizedBox(height: 10),
          Text('Say "aaaa"', style: AppTextStyles.title),
          SizedBox(height: 8),
          Text(
            "Keep your voice steady for 10–15 seconds.",
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}

class _WaveBars extends StatelessWidget {
  const _WaveBars();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          7,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 10,
            height: 60 + (index % 2) * 20,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.successGreen,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text(
            "Nice and steady!",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoiceCheckViewModel vm;
  const _StopButton(this.vm);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: vm.stopRecording,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.dangerRed,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text(
        "Stop Recording",
        style: TextStyle(fontSize: 18, color: AppColors.lightBlueBg),
      ),
    );
  }
}

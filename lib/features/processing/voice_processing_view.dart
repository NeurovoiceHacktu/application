import 'package:neurovoice_app/core/constants/colors.dart';
import 'package:neurovoice_app/core/constants/strings.dart';
import 'package:neurovoice_app/features/voice_check/voice_check_viewmodel.dart';
import 'package:neurovoice_app/shared/widgets/did_you_know_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VoiceProcessingView extends StatefulWidget {
  const VoiceProcessingView({super.key});

  @override
  State<VoiceProcessingView> createState() => _VoiceProcessingViewState();
}

class _VoiceProcessingViewState extends State<VoiceProcessingView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final vm = context.watch<VoiceCheckViewModel>();

    // ✅ Navigate ONLY when ML is actually done
    if (vm.shouldNavigateToResults) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          '/results',
          arguments: {'riskScore': vm.confidence, 'riskLevel': vm.riskLevel},
        );

        vm.resetNavigationFlags();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VoiceCheckViewModel>();

    final double progress = vm.isUploading
        ? vm.processProgress.clamp(0.0, 1.0)
        : 1.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // HEADER (fixed)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Voice Processing',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 60,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),

                          const Text(
                            'Just a moment...',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 36),

                          // RIPPLE + ICON
                          SizedBox(
                            height: 260,
                            width: 260,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                _circle(220, 0.05),
                                _circle(180, 0.10),
                                _circle(140, 0.18),
                                _circle(100, 0.30),
                                Container(
                                  height: 72,
                                  width: 72,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF13B6EC),
                                        Color(0xFF5ACFF5),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x6613B6EC),
                                        blurRadius: 25,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.graphic_eq,
                                    color: AppColors.white,
                                    size: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          Text(
                            vm.isUploading
                                ? 'Analyzing voice stability...'
                                : 'Finalizing results...',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 8),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Checking pitch consistency and tone patterns against healthy baselines.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 32),

                          // PROGRESS BAR
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    minHeight: 10,
                                    backgroundColor: AppColors.progressInactive,
                                    valueColor: const AlwaysStoppedAnimation(
                                      AppColors.accentBlue,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Voice Processing',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                    Text(
                                      '${(progress * 100).toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // FOOTER CONTENT
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFEAF0F3),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF13B6EC,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.lightbulb_outline,
                                          color: Color(0xFF13B6EC),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      DidYouKnowCard(
                                        fact: AppStrings.dailyFactVoice,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 20),

                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel Analysis',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.gray,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.lock_outline,
                                      size: 14,
                                      color: AppColors.gray,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Your data is processed privately.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static Widget _circle(double size, double opacity) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryRipple.withOpacity(opacity),
      ),
    );
  }
}
